import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../constants/api_constants.dart';
import '../models/mandi_model.dart';
import '../models/weather_model.dart';
import '../models/disease_model.dart';
import '../models/village_model.dart';
import '../models/store_model.dart';
import '../models/chat_model.dart';
import 'kisan_ai_chatbot_service.dart';

class ApiService {
  final String _baseUrl;

  ApiService({String? baseUrl}) : _baseUrl = baseUrl ?? ApiConstants.activeBaseUrl;

  // 1. Mandi Net Arbitrage Engine
  Future<List<MandiEvaluation>> calculateArbitrage({
    required double weightQuintals,
    required String vehicleType,
    required List<MandiCandidate> mandis,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl${ApiConstants.endpointArbitrage}');
      final payload = {
        'weight_quintals': weightQuintals,
        'vehicle_type': vehicleType,
        'mandis': mandis.map((m) => m.toJson()).toList(),
      };

      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(ApiConstants.receiveTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = (data['ranking'] ?? data['data'] ?? []) as List;
        return list.map((e) => MandiEvaluation.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      print('[ApiService] calculateArbitrage error: $e');
    }

    // Offline / fallback calculation if backend is unreachable
    return _calculateLocalArbitrageFallback(weightQuintals, vehicleType, mandis);
  }

  // Fallback local math when completely offline
  List<MandiEvaluation> _calculateLocalArbitrageFallback(
    double weight,
    String vehicle,
    List<MandiCandidate> mandis,
  ) {
    const mileageMap = {'tata_ace': 11.0, 'pickup_407': 8.5, 'tractor': 5.0, 'three_wheeler': 18.0};
    final mileage = mileageMap[vehicle] ?? 10.0;
    const dieselPrice = 92.0;
    const loadingFee = 25.0;
    const cessPct = 0.0105;

    List<MandiEvaluation> evals = [];
    for (final m in mandis) {
      final gross = weight * m.modalPricePerQtl;
      final fuel = (2.0 * m.distanceKm / mileage) * dieselPrice;
      final handling = weight * loadingFee;
      final cess = gross * cessPct;
      final totalOverhead = fuel + handling + cess;
      final net = gross - totalOverhead;
      final netRate = net / weight;

      evals.add(MandiEvaluation(
        mandiId: m.id,
        mandiName: m.name,
        distanceKm: m.distanceKm,
        quotedGrossRate: m.modalPricePerQtl,
        grossRevenue: gross,
        logisticsOverhead: totalOverhead,
        fuelCost: fuel,
        handlingFee: handling,
        cessFee: cess,
        netEarnings: net,
        effectiveNetRate: netRate,
        district: m.district,
        yardTier: m.yardTier,
      ));
    }
    evals.sort((a, b) => b.netEarnings.compareTo(a.netEarnings));
    return evals;
  }

  // 2. Hyperlocal Weather & Spray Window with MOS Downscaling
  Future<WeatherReport?> getSprayWindow({
    required double lat,
    required double lon,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl${ApiConstants.endpointSprayWindow}?lat=$lat&lon=$lon');
      final res = await http.get(url).timeout(ApiConstants.receiveTimeout);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final eval = data['evaluation'] ?? data;
        return WeatherReport.fromJson(eval);
      }
    } catch (e) {
      print('[ApiService] getSprayWindow error: $e');
    }
    return null;
  }

  // 3. Leaf Crop Pathology Diagnosis
  Future<CropPathologyResult?> diagnoseCrop({
    required File imageFile,
    String cropName = 'Leaf',
    double? lat,
    double? lon,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl${ApiConstants.endpointCropDiagnose}');
      var request = http.MultipartRequest('POST', url);

      request.fields['crop_name'] = cropName;
      if (lat != null) request.fields['lat'] = lat.toString();
      if (lon != null) request.fields['lon'] = lon.toString();

      final fileStream = http.ByteStream(imageFile.openRead());
      final length = await imageFile.length();
      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        length,
        filename: imageFile.path.split(Platform.pathSeparator).last,
        contentType: MediaType('image', 'jpeg'),
      );

      request.files.add(multipartFile);
      final streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return CropPathologyResult.fromJson(data);
      }
    } catch (e) {
      print('[ApiService] diagnoseCrop error: $e');
    }
    return null;
  }

  // 4. LGD Village Directory Search
  Future<List<VillageRecord>> searchVillages(String query) async {
    try {
      final url = Uri.parse('$_baseUrl${ApiConstants.endpointVillageSearch}?q=${Uri.encodeComponent(query)}&limit=15');
      final res = await http.get(url).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = (data['records'] ?? data['villages'] ?? data['data'] ?? []) as List;
        return list.map((e) => VillageRecord.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      print('[ApiService] searchVillages error: $e');
    }
    return [];
  }

  // 5. KisanMitra AI Voice & Text Chat
  Future<ChatMessage> sendChatMessage({
    required String message,
    required String locale,
    List<Map<String, String>> history = const [],
  }) async {
    // 1. Try remote server first (3.5s timeout so user never waits if server is offline)
    try {
      final url = Uri.parse('$_baseUrl${ApiConstants.endpointChat}');
      final payload = {
        'message': message,
        'language': locale,
        'history': history,
      };

      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      ).timeout(const Duration(milliseconds: 3500));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final replyText = data['reply'] ?? data['response'] ?? data['message'];
        if (replyText != null && replyText.toString().trim().isNotEmpty) {
          return ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: replyText.toString(),
            isUser: false,
            timestamp: DateTime.now(),
            audioUrl: data['audio_url'] ?? data['audioUrl'],
            quickReplies: (data['quick_replies'] as List?)?.map((e) => e.toString()).toList(),
          );
        }
      }
    } catch (e) {
      print('[ApiService] sendChatMessage remote fallback: $e');
    }

    // 2. High-intelligence on-device agronomy engine fallback: guaranteed instant response
    return KisanAiChatbotService.getResponse(
      query: message,
      locale: locale,
    );
  }

  // 6. Products Catalog
  Future<List<Product>> fetchProducts({String category = 'all'}) async {
    try {
      final url = Uri.parse('$_baseUrl${ApiConstants.endpointProducts}');
      final res = await http.get(url).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = (data['products'] ?? data['data'] ?? []) as List;
        return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      print('[ApiService] fetchProducts error: $e');
    }

    // Default curated agricultural items
    return [
      Product(
        id: 'urea-neem-50kg',
        name: 'Neem Coated Urea (46% N)',
        localName: 'निम कोटेड युरिया',
        category: 'fertilizers',
        price: 266.50,
        unit: '45 kg bag',
        description: 'Subsidized fertilizer for rapid vegetative growth and chlorophyll synthesis.',
        inStock: true,
      ),
      Product(
        id: 'dap-iffco-50kg',
        name: 'IFFCO DAP (18:46:0)',
        localName: 'इफको डीएपी',
        category: 'fertilizers',
        price: 1350.00,
        unit: '50 kg bag',
        description: 'High phosphorus fertilizer for vigorous root establishment.',
        inStock: true,
      ),
      Product(
        id: 'azoxystrobin-fungicide',
        name: 'Azoxystrobin 18.2% + Difenoconazole',
        localName: 'अमेस्टो प्राइम फुरशीनाशक',
        category: 'pesticides',
        price: 840.00,
        unit: '200 ml bottle',
        description: 'Broad-spectrum systemic fungicide for downy mildew & blights.',
        inStock: true,
      ),
      Product(
        id: 'soybean-js335-seeds',
        name: 'Certified Soybean JS-335 Seeds',
        localName: 'सोयाबीन बियाणे JS-335',
        category: 'seeds',
        price: 3200.00,
        unit: '30 kg bag',
        description: 'High germination certified drought-resistant seed grade.',
        inStock: true,
      ),
    ];
  }
}
