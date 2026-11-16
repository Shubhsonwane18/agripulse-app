import 'package:flutter/foundation.dart';
import '../models/mandi_model.dart';
import '../services/api_service.dart';

class MandiViewModel extends ChangeNotifier {
  final ApiService _apiService;

  double _weightQuintals = 25.0;
  String _selectedVehicle = 'tata_ace';
  double _dieselPrice = 92.0;
  String _selectedCommodity = 'Soybean';

  bool _isLoading = false;
  List<MandiEvaluation> _rankings = [];
  String? _errorMessage;

  MandiViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService() {
    calculateArbitrage();
  }

  double get weightQuintals => _weightQuintals;
  String get selectedVehicle => _selectedVehicle;
  double get dieselPrice => _dieselPrice;
  String get selectedCommodity => _selectedCommodity;
  bool get isLoading => _isLoading;
  List<MandiEvaluation> get rankings => _rankings;
  String? get errorMessage => _errorMessage;

  MandiEvaluation? get bestMandi => _rankings.isNotEmpty ? _rankings.first : null;
  MandiEvaluation? get nearestMandi {
    if (_rankings.isEmpty) return null;
    var sortedByDist = List<MandiEvaluation>.from(_rankings);
    sortedByDist.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return sortedByDist.first;
  }

  double get netProfitDelta {
    if (bestMandi != null && nearestMandi != null && bestMandi != nearestMandi) {
      return bestMandi!.netEarnings - nearestMandi!.netEarnings;
    }
    return 0.0;
  }

  void setWeight(double weight) {
    if (weight > 0 && _weightQuintals != weight) {
      _weightQuintals = weight;
      calculateArbitrage();
    }
  }

  void setVehicle(String vehicleId) {
    if (_selectedVehicle != vehicleId) {
      _selectedVehicle = vehicleId;
      calculateArbitrage();
    }
  }

  void setCommodity(String commodity) {
    if (_selectedCommodity != commodity) {
      _selectedCommodity = commodity;
      calculateArbitrage();
    }
  }

  Future<void> calculateArbitrage() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final candidates = _getCandidatesForCommodity(_selectedCommodity);
      final results = await _apiService.calculateArbitrage(
        weightQuintals: _weightQuintals,
        vehicleType: _selectedVehicle,
        mandis: candidates,
      );

      _rankings = results;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<MandiCandidate> _getCandidatesForCommodity(String commodity) {
    // Verified real APMC mandis matching backend seed
    switch (commodity) {
      case 'Onion':
        return [
          MandiCandidate(id: 'lasalgaon-nashik', name: 'Lasalgaon Mandi Yard', distanceKm: 85.0, modalPricePerQtl: 2350.0, district: 'Nashik'),
          MandiCandidate(id: 'pimpalgaon-nashik', name: 'Pimpalgaon Baswant APMC', distanceKm: 65.0, modalPricePerQtl: 2260.0, district: 'Nashik'),
          MandiCandidate(id: 'yeola-nashik', name: 'Yeola Sub-Market Yard', distanceKm: 42.0, modalPricePerQtl: 2180.0, district: 'Nashik'),
          MandiCandidate(id: 'pune-gultekdi', name: 'Pune Gultekdi APMC', distanceKm: 140.0, modalPricePerQtl: 2480.0, district: 'Pune'),
        ];
      case 'Tomato':
        return [
          MandiCandidate(id: 'narayangaon-pune', name: 'Narayangaon Tomato Yard', distanceKm: 70.0, modalPricePerQtl: 2150.0, district: 'Pune'),
          MandiCandidate(id: 'sangamner-ahmednagar', name: 'Sangamner APMC', distanceKm: 45.0, modalPricePerQtl: 1980.0, district: 'Ahmednagar'),
          MandiCandidate(id: 'pimpalgaon-nashik', name: 'Pimpalgaon Baswant APMC', distanceKm: 65.0, modalPricePerQtl: 2240.0, district: 'Nashik'),
          MandiCandidate(id: 'kolhapur-market', name: 'Kolhapur Shahu Market Yard', distanceKm: 22.0, modalPricePerQtl: 2120.0, district: 'Kolhapur'),
        ];
      case 'Cotton':
        return [
          MandiCandidate(id: 'jalna-cotton', name: 'Jalna Cotton Market Yard', distanceKm: 105.0, modalPricePerQtl: 7250.0, district: 'Jalna'),
          MandiCandidate(id: 'hinganghat-apmc', name: 'Hinganghat APMC Yard', distanceKm: 140.0, modalPricePerQtl: 7480.0, district: 'Wardha'),
          MandiCandidate(id: 'yavatmal-cotton', name: 'Yavatmal APMC Mandi', distanceKm: 95.0, modalPricePerQtl: 7180.0, district: 'Yavatmal'),
          MandiCandidate(id: 'akola-cotton', name: 'Akola Cotton Market Yard', distanceKm: 75.0, modalPricePerQtl: 7320.0, district: 'Akola'),
        ];
      case 'Tur':
        return [
          MandiCandidate(id: 'latur-tur', name: 'Latur APMC Pulses Yard', distanceKm: 70.0, modalPricePerQtl: 9850.0, district: 'Latur'),
          MandiCandidate(id: 'akola-tur', name: 'Akola Dal & Pulses Mandi', distanceKm: 85.0, modalPricePerQtl: 9620.0, district: 'Akola'),
          MandiCandidate(id: 'solapur-tur', name: 'Solapur APMC Yard', distanceKm: 55.0, modalPricePerQtl: 9450.0, district: 'Solapur'),
          MandiCandidate(id: 'gulbarga-tur', name: 'Kalaburagi / Gulbarga APMC', distanceKm: 110.0, modalPricePerQtl: 10120.0, district: 'Kalaburagi'),
        ];
      case 'Wheat':
        return [
          MandiCandidate(id: 'pune-wheat', name: 'Pune Gultekdi APMC Yard', distanceKm: 60.0, modalPricePerQtl: 2850.0, district: 'Pune'),
          MandiCandidate(id: 'kolhapur-wheat', name: 'Kolhapur Shahu Market', distanceKm: 25.0, modalPricePerQtl: 2740.0, district: 'Kolhapur'),
          MandiCandidate(id: 'sangli-wheat', name: 'Sangli APMC Market Yard', distanceKm: 38.0, modalPricePerQtl: 2780.0, district: 'Sangli'),
          MandiCandidate(id: 'solapur-wheat', name: 'Solapur Market Yard', distanceKm: 90.0, modalPricePerQtl: 2920.0, district: 'Solapur'),
        ];
      case 'Soybean':
      default:
        return [
          MandiCandidate(id: 'latur-apmc', name: 'Latur APMC Main Yard', distanceKm: 110.0, modalPricePerQtl: 4680.0, district: 'Latur'),
          MandiCandidate(id: 'sangli-apmc', name: 'Sangli Market Yard', distanceKm: 38.0, modalPricePerQtl: 4520.0, district: 'Sangli'),
          MandiCandidate(id: 'kolhapur-apmc', name: 'Kolhapur Shahu Market', distanceKm: 18.0, modalPricePerQtl: 4410.0, district: 'Kolhapur'),
          MandiCandidate(id: 'solapur-apmc', name: 'Solapur APMC Yard', distanceKm: 85.0, modalPricePerQtl: 4580.0, district: 'Solapur'),
        ];
    }
  }
}
