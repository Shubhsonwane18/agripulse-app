import 'dart:math';
import '../models/mandi_model.dart';

class CityLocation {
  final String id;
  final String nameEn;
  final String nameMr;
  final String nameHi;
  final String nameTe;
  final String nameKn;
  final String nameGu;
  final double lat;
  final double lon;

  const CityLocation({
    required this.id,
    required this.nameEn,
    required this.nameMr,
    required this.nameHi,
    required this.nameTe,
    required this.nameKn,
    required this.nameGu,
    required this.lat,
    required this.lon,
  });

  String getName(String locale) {
    switch (locale) {
      case 'mr': return nameMr;
      case 'hi': return nameHi;
      case 'te': return nameTe;
      case 'kn': return nameKn;
      case 'gu': return nameGu;
      default: return nameEn;
    }
  }
}

class CropItem {
  final String id;
  final String nameEn;
  final String nameMr;
  final String nameHi;
  final String nameTe;
  final String nameKn;
  final String nameGu;
  final String icon;
  final String categoryId;
  final double benchmarkPrice; // Typical price per Quintal

  const CropItem({
    required this.id,
    required this.nameEn,
    required this.nameMr,
    required this.nameHi,
    required this.nameTe,
    required this.nameKn,
    required this.nameGu,
    required this.icon,
    required this.categoryId,
    required this.benchmarkPrice,
  });

  String getName(String locale) {
    switch (locale) {
      case 'mr': return '$icon $nameMr';
      case 'hi': return '$icon $nameHi';
      case 'te': return '$icon $nameTe';
      case 'kn': return '$icon $nameKn';
      case 'gu': return '$icon $nameGu';
      default: return '$icon $nameEn';
    }
  }
}

class CropCategoryItem {
  final String id;
  final String nameEn;
  final String nameMr;
  final String nameHi;
  final String nameTe;
  final String nameKn;
  final String nameGu;
  final String icon;

  const CropCategoryItem({
    required this.id,
    required this.nameEn,
    required this.nameMr,
    required this.nameHi,
    required this.nameTe,
    required this.nameKn,
    required this.nameGu,
    required this.icon,
  });

  String getName(String locale) {
    switch (locale) {
      case 'mr': return '$icon $nameMr';
      case 'hi': return '$icon $nameHi';
      case 'te': return '$icon $nameTe';
      case 'kn': return '$icon $nameKn';
      case 'gu': return '$icon $nameGu';
      default: return '$icon $nameEn';
    }
  }
}

class WholesaleApmcHub {
  final String id;
  final String name;
  final String city;
  final String state;
  final double lat;
  final double lon;
  final double pricePremiumRatio; // e.g. 1.05 = pays 5% above baseline

  const WholesaleApmcHub({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.lat,
    required this.lon,
    this.pricePremiumRatio = 1.0,
  });
}

class MandiDirectoryService {
  // 1. Comprehensive Regional Agricultural Cities
  static const List<CityLocation> cities = [
    CityLocation(id: 'pune', nameEn: 'Pune', nameMr: 'पुणे', nameHi: 'पुणे', nameTe: 'పుణె', nameKn: 'ಪುಣೆ', nameGu: 'પુણે', lat: 18.5204, lon: 73.8567),
    CityLocation(id: 'nashik', nameEn: 'Nashik', nameMr: 'नाशिक', nameHi: 'नासिक', nameTe: 'నాసిక్', nameKn: 'ನಾಸಿಕ್', nameGu: 'નાસિક', lat: 19.9975, lon: 73.7898),
    CityLocation(id: 'kolhapur', nameEn: 'Kolhapur', nameMr: 'कोल्हापूर', nameHi: 'कोल्हापुर', nameTe: 'కొల్హాపూర్', nameKn: 'ಕೊಲ್ಹಾಪುರ', nameGu: 'કોલ્હાપુર', lat: 16.7050, lon: 74.2433),
    CityLocation(id: 'latur', nameEn: 'Latur', nameMr: 'लातूर', nameHi: 'लातूर', nameTe: 'లాతూర్', nameKn: 'ಲಾತೂರ್', nameGu: 'લાતુર', lat: 18.4088, lon: 76.5604),
    CityLocation(id: 'solapur', nameEn: 'Solapur', nameMr: 'सोलापूर', nameHi: 'सोलापुर', nameTe: 'సోలాపూర్', nameKn: 'ಸೋಲಾಪುರ', nameGu: 'સોલાપુર', lat: 17.6599, lon: 75.9064),
    CityLocation(id: 'sangli', nameEn: 'Sangli', nameMr: 'सांगली', nameHi: 'सांगली', nameTe: 'సాంగ్లీ', nameKn: 'ಸಾಂಗ್ಲಿ', nameGu: 'સાંગલી', lat: 16.8524, lon: 74.5815),
    CityLocation(id: 'ahmednagar', nameEn: 'Ahmednagar', nameMr: 'अहमदनगर', nameHi: 'अहमदनगर', nameTe: 'అహ్మద్ నగర్', nameKn: 'ಅಹ್ಮದ್ ನಗರ', nameGu: 'અહમદનગર', lat: 19.0948, lon: 74.7480),
    CityLocation(id: 'nagpur', nameEn: 'Nagpur', nameMr: 'नागपूर', nameHi: 'नागपुर', nameTe: 'నాగ్‌పూర్', nameKn: 'ನಾಗಪುರ', nameGu: 'નાગપુર', lat: 21.1458, lon: 79.0882),
    CityLocation(id: 'aurangabad', nameEn: 'Chhatrapati Sambhaji Nagar', nameMr: 'छत्रपती संभाजीनगर', nameHi: 'संभाजीनगर (औरंगाबाद)', nameTe: 'సంభాజీనగర్', nameKn: 'ಸಂಭಾಜಿನಗರ', nameGu: 'સંભાજીનગર', lat: 19.8762, lon: 75.3433),
    CityLocation(id: 'jalgaon', nameEn: 'Jalgaon', nameMr: 'जळगाव', nameHi: 'जलगांव', nameTe: 'జల్గావ్', nameKn: 'ಜಲಗಾಂವ್', nameGu: 'જળગાંવ', lat: 21.0077, lon: 75.5626),
    CityLocation(id: 'amravati', nameEn: 'Amravati', nameMr: 'अमरावती', nameHi: 'अमरावती', nameTe: 'అమరావతి', nameKn: 'ಅಮರಾವತಿ', nameGu: 'અમરાવતી', lat: 20.9320, lon: 77.7523),
    CityLocation(id: 'nanded', nameEn: 'Nanded', nameMr: 'नांदेड', nameHi: 'नांदेड़', nameTe: 'నాందేడ్', nameKn: 'ನಾಂದೇಡ್', nameGu: 'નાંદેડ', lat: 19.1383, lon: 77.3210),
    CityLocation(id: 'akola', nameEn: 'Akola', nameMr: 'अकोला', nameHi: 'अकोला', nameTe: 'అకోలా', nameKn: 'ಅಕೋಲಾ', nameGu: 'અકોલા', lat: 20.7002, lon: 77.0082),
    CityLocation(id: 'satara', nameEn: 'Satara', nameMr: 'सातारा', nameHi: 'सतारा', nameTe: 'సతారా', nameKn: 'ಸತಾರಾ', nameGu: 'સાતારા', lat: 17.6805, lon: 74.0183),
    CityLocation(id: 'mumbai', nameEn: 'Mumbai / Vashi', nameMr: 'मुंबई / वाशी', nameHi: 'मुंबई / वाशी', nameTe: 'ముంబై / వాషి', nameKn: 'ಮುಂಬೈ / ವಾಶಿ', nameGu: 'મુંબઈ / વાશી', lat: 19.0760, lon: 72.8777),
    CityLocation(id: 'indore', nameEn: 'Indore (MP)', nameMr: 'इंदूर (म.प्र.)', nameHi: 'इंदौर (म.प्र.)', nameTe: 'ఇండోర్', nameKn: 'ಇಂದೋರ್', nameGu: 'ઇન્દોર', lat: 22.7196, lon: 75.8577),
    CityLocation(id: 'belagavi', nameEn: 'Belagavi (KA)', nameMr: 'बेळगाव (कर्नाटक)', nameHi: 'बेलगाम (कर्नाटक)', nameTe: 'బెళగావి', nameKn: 'ಬೆಳಗಾವಿ', nameGu: 'બેલગામ', lat: 15.8497, lon: 74.4977),
    CityLocation(id: 'hyderabad', nameEn: 'Hyderabad (TG)', nameMr: 'हैदराबाद (तेलंगणा)', nameHi: 'हैदराबाद (तेलंगाना)', nameTe: 'హైదరాబాద్', nameKn: 'ಹೈದರಾಬಾದ್', nameGu: 'હૈદરાબાદ', lat: 17.3850, lon: 78.4867),
    CityLocation(id: 'surat', nameEn: 'Surat (Gujarat)', nameMr: 'सुरत (गुजरात)', nameHi: 'सूरत (गुजरात)', nameTe: 'సూరత్', nameKn: 'ಸೂರತ್', nameGu: 'સુરત', lat: 21.1702, lon: 72.8311),
  ];

  // 2. Crop Categories
  static const List<CropCategoryItem> categories = [
    CropCategoryItem(id: 'grains', nameEn: 'Grains & Pulses', nameMr: 'अन्नधान्य व कडधान्ये', nameHi: 'अन्न व दलहन', nameTe: 'ధాన్యాలు & పప్పులు', nameKn: 'ಧಾನ್ಯಗಳು ಮತ್ತು ಬೇಳೆಗಳು', nameGu: 'અનાજ અને કઠોળ', icon: '🌾'),
    CropCategoryItem(id: 'vegetables', nameEn: 'Vegetables', nameMr: 'भाजीपाला', nameHi: 'सब्जियां', nameTe: 'కూరగాయలు', nameKn: 'ತರಕಾರಿಗಳು', nameGu: 'શાકભાજી', icon: '🥦'),
    CropCategoryItem(id: 'fruits', nameEn: 'Fresh Fruits', nameMr: 'फळे', nameHi: 'फल', nameTe: 'పండ్లు', nameKn: 'ಹಣ್ಣುಗಳು', nameGu: 'ફળો', icon: '🍎'),
    CropCategoryItem(id: 'cash_crops', nameEn: 'Cash Crops', nameMr: 'नगदी पिके', nameHi: 'नकदी फसलें', nameTe: 'వాణిజ్య పంటలు', nameKn: 'ವಾಣಿಜ್ಯ ಬೆಳೆಗಳು', nameGu: 'રોકડિયા પાકો', icon: '🎋'),
    CropCategoryItem(id: 'dry_fruits', nameEn: 'Dry Fruits & Spices', nameMr: 'सुका मेवा व मसाले', nameHi: 'सूखे मेवे व मसाले', nameTe: 'డ్రై ఫ్రూట్స్ & మసాలాలు', nameKn: 'ಡ್ರೈ ಫ್ರೂಟ್ಸ್ & ಮಸಾಲೆಗಳು', nameGu: 'સૂકા મેવા અને મસાલા', icon: '🥜'),
  ];

  // 3. Categorized Crops Catalog
  static const List<CropItem> crops = [
    // --- Grains & Pulses ---
    CropItem(id: 'Soybean', nameEn: 'Soybean', nameMr: 'सोयाबीन', nameHi: 'सोयाबीन', nameTe: 'సోయాబీన్', nameKn: 'ಸೋಯಾಬೀನ್', nameGu: 'સોયાબીન', icon: '🌱', categoryId: 'grains', benchmarkPrice: 4750.0),
    CropItem(id: 'Wheat', nameEn: 'Wheat', nameMr: 'गहू', nameHi: 'गेहूं', nameTe: 'గోధుమలు', nameKn: 'ಗೋಧಿ', nameGu: 'ઘઉં', icon: '🌾', categoryId: 'grains', benchmarkPrice: 2850.0),
    CropItem(id: 'Rice', nameEn: 'Paddy / Rice', nameMr: 'भात / धान', nameHi: 'धान / चावल', nameTe: 'వరి / బియ్యం', nameKn: 'ಭತ್ತ / ಅಕ್ಕಿ', nameGu: 'ડાંગર / ચોખા', icon: '🍚', categoryId: 'grains', benchmarkPrice: 2650.0),
    CropItem(id: 'Tur', nameEn: 'Tur / Pigeon Pea', nameMr: 'तूर', nameHi: 'अरहर / तूर', nameTe: 'కందులు', nameKn: 'ತೊಗರಿ ಬೇಳೆ', nameGu: 'તુવેર', icon: '🥣', categoryId: 'grains', benchmarkPrice: 9750.0),
    CropItem(id: 'Chana', nameEn: 'Gram / Chana', nameMr: 'हरभरा (चना)', nameHi: 'चना', nameTe: 'శనగలు', nameKn: 'ಕಡಲೆ', nameGu: 'ચણા', icon: '🌰', categoryId: 'grains', benchmarkPrice: 6150.0),
    CropItem(id: 'Maize', nameEn: 'Maize / Corn', nameMr: 'मका', nameHi: 'मक्का', nameTe: 'మొక్కజొన్న', nameKn: 'ಮೆಕ್ಕೆಜೋಳ', nameGu: 'મકાઈ', icon: '🌽', categoryId: 'grains', benchmarkPrice: 2320.0),
    CropItem(id: 'Moong', nameEn: 'Green Gram (Moong)', nameMr: 'मूग', nameHi: 'मूंग', nameTe: 'పెసలు', nameKn: 'ಹೆಸರು ಕಾಳು', nameGu: 'મગ', icon: '🌱', categoryId: 'grains', benchmarkPrice: 8450.0),
    CropItem(id: 'Bajra', nameEn: 'Pearl Millet (Bajra)', nameMr: 'बाजरी', nameHi: 'बाजरा', nameTe: 'సజ్జలు', nameKn: 'ಸಜ್ಜೆ', nameGu: 'બાજરી', icon: '🌾', categoryId: 'grains', benchmarkPrice: 2480.0),
    CropItem(id: 'Jowar', nameEn: 'Sorghum (Jowar)', nameMr: 'ज्वारी', nameHi: 'ज्वार', nameTe: 'జొన్నలు', nameKn: 'ಜೋಳ', nameGu: 'જુવાર', icon: '🌾', categoryId: 'grains', benchmarkPrice: 3450.0),

    // --- Vegetables ---
    CropItem(id: 'Onion', nameEn: 'Onion', nameMr: 'कांदा', nameHi: 'प्याज', nameTe: 'ఉల్లిపాయ', nameKn: 'ಈರುಳ್ಳಿ', nameGu: 'ડુંગળી', icon: '🧅', categoryId: 'vegetables', benchmarkPrice: 2420.0),
    CropItem(id: 'Tomato', nameEn: 'Tomato', nameMr: 'टोमॅटो', nameHi: 'टमाटर', nameTe: 'టమోటా', nameKn: 'ಟೊಮ್ಯಾಟೊ', nameGu: 'ટામેટા', icon: '🍅', categoryId: 'vegetables', benchmarkPrice: 2150.0),
    CropItem(id: 'Potato', nameEn: 'Potato', nameMr: 'बटाटा', nameHi: 'आलू', nameTe: 'బంగాళాదుంప', nameKn: 'ಆಲೂಗಡ್ಡೆ', nameGu: 'બટાકા', icon: '🥔', categoryId: 'vegetables', benchmarkPrice: 1850.0),
    CropItem(id: 'Garlic', nameEn: 'Garlic', nameMr: 'लसूण', nameHi: 'लहसुन', nameTe: 'వెల్లుల్లి', nameKn: 'ಬೆಳ್ಳುಳ್ಳಿ', nameGu: 'લસણ', icon: '🧄', categoryId: 'vegetables', benchmarkPrice: 13500.0),
    CropItem(id: 'Ginger', nameEn: 'Ginger', nameMr: 'आले (अद्रक)', nameHi: 'अदरक', nameTe: 'అల్లం', nameKn: 'ಶುಂಠಿ', nameGu: 'આદુ', icon: '🫚', categoryId: 'vegetables', benchmarkPrice: 7200.0),
    CropItem(id: 'Chilli', nameEn: 'Green Chilli', nameMr: 'हिरवी मिरची', nameHi: 'हरी मिर्च', nameTe: 'పచ్చిమిర్చి', nameKn: 'ಹಸಿಮೆಣಸಿನಕಾಯಿ', nameGu: 'લીલા મરચા', icon: '🌶️', categoryId: 'vegetables', benchmarkPrice: 4200.0),
    CropItem(id: 'Cabbage', nameEn: 'Cabbage', nameMr: 'कोबी', nameHi: 'पत्तागोभी', nameTe: 'క్యాబేజీ', nameKn: 'ಎಲೆಕೋಸು', nameGu: 'કોબીજ', icon: '🥬', categoryId: 'vegetables', benchmarkPrice: 1350.0),
    CropItem(id: 'Cauliflower', nameEn: 'Cauliflower', nameMr: 'फ्लॉवर', nameHi: 'फूलगोभी', nameTe: 'కాలీఫ్లవర్', nameKn: 'ಹೂಕೋಸು', nameGu: 'ફ્લાવર', icon: '🥦', categoryId: 'vegetables', benchmarkPrice: 1650.0),
    CropItem(id: 'Okra', nameEn: 'Okra / Ladyfinger', nameMr: 'भेंडी', nameHi: 'भिंडी', nameTe: 'బెండకాయ', nameKn: 'ಬೆಂಡೆಕಾಯಿ', nameGu: 'ભીંડા', icon: '🥗', categoryId: 'vegetables', benchmarkPrice: 3200.0),

    // --- Fresh Fruits ---
    CropItem(id: 'Pomegranate', nameEn: 'Pomegranate', nameMr: 'डाळिंब (भगवा)', nameHi: 'अनार', nameTe: 'దానిమ్మ', nameKn: 'ದಾಳಿಂಬೆ', nameGu: 'દાડમ', icon: '🫐', categoryId: 'fruits', benchmarkPrice: 9800.0),
    CropItem(id: 'Grapes', nameEn: 'Grapes (Thompson/Tasgaon)', nameMr: 'द्राक्षे (तासगाव)', nameHi: 'अंगूर', nameTe: 'ద్రాక్ష', nameKn: 'ದ್ರಾಕ್ಷಿ', nameGu: 'દ્રાક્ષ', icon: '🍇', categoryId: 'fruits', benchmarkPrice: 7200.0),
    CropItem(id: 'Banana', nameEn: 'Banana (Grand Naine)', nameMr: 'केळी (जळगाव)', nameHi: 'केला', nameTe: 'అరటిపండు', nameKn: 'ಬಾಳೆಹಣ್ಣು', nameGu: 'કેળા', icon: '🍌', categoryId: 'fruits', benchmarkPrice: 1950.0),
    CropItem(id: 'Orange', nameEn: 'Orange / Mosambi', nameMr: 'संत्री / मोसंबी', nameHi: 'संतरा / मौसमी', nameTe: 'నారింజ / బత్తాయి', nameKn: 'ಕಿತ್ತಳೆ / ಮೂಸಂಬಿ', nameGu: 'સંતરા / મોસંબી', icon: '🍊', categoryId: 'fruits', benchmarkPrice: 4800.0),
    CropItem(id: 'Mango', nameEn: 'Alphonso Mango (Hapus)', nameMr: 'हापूस आंबा', nameHi: 'हापुस आम', nameTe: 'మామిడిపండు', nameKn: 'ಮಾವಿನ ಹಣ್ಣು', nameGu: 'હાફૂસ કેરી', icon: '🥭', categoryId: 'fruits', benchmarkPrice: 11500.0),
    CropItem(id: 'CustardApple', nameEn: 'Custard Apple (Sitaphal)', nameMr: 'सीताफळ (गोल्डन)', nameHi: 'शरीफा / सीताफल', nameTe: 'సీతాఫలం', nameKn: 'ಸೀತಾಫಲ', nameGu: 'સીતાફળ', icon: '🍈', categoryId: 'fruits', benchmarkPrice: 5200.0),
    CropItem(id: 'Guava', nameEn: 'Guava (Peru)', nameMr: 'पेरू (सरदार)', nameHi: 'अमरूद', nameTe: 'జామపండు', nameKn: 'ಸೀಬೆಹಣ್ಣು', nameGu: 'જામફળ', icon: '🍐', categoryId: 'fruits', benchmarkPrice: 2800.0),
    CropItem(id: 'Watermelon', nameEn: 'Watermelon', nameMr: 'कलिंगड', nameHi: 'तरबूज', nameTe: 'పుచ్చకాయ', nameKn: 'ಕಲ್ಲಂಗಡಿ', nameGu: 'તરબૂચ', icon: '🍉', categoryId: 'fruits', benchmarkPrice: 1250.0),

    // --- Cash Crops ---
    CropItem(id: 'Cotton', nameEn: 'Cotton (Kapas)', nameMr: 'कापूस', nameHi: 'कपास (कपास)', nameTe: 'పత్తి', nameKn: 'ಹತ್ತಿ', nameGu: 'કપાસ', icon: '☁️', categoryId: 'cash_crops', benchmarkPrice: 7450.0),
    CropItem(id: 'Sugarcane', nameEn: 'Sugarcane (FRP Rate)', nameMr: 'ऊस (प्रति टन)', nameHi: 'गन्ना', nameTe: 'చెరకు', nameKn: 'ಕಬ್ಬು', nameGu: 'શેરડી', icon: '🎋', categoryId: 'cash_crops', benchmarkPrice: 3450.0),
    CropItem(id: 'Turmeric', nameEn: 'Turmeric (Selam / Rajapuri)', nameMr: 'हळद (सांगली/राजापुरी)', nameHi: 'हल्दी', nameTe: 'పసుపు', nameKn: 'ಅರಿಶಿನ', nameGu: 'હળદર', icon: '🥔', categoryId: 'cash_crops', benchmarkPrice: 15800.0),

    // --- Dry Fruits & Spices ---
    CropItem(id: 'Cashew', nameEn: 'Raw Cashew Nut', nameMr: 'काजू बी (कोकण)', nameHi: 'कच्चा काजू', nameTe: 'జీడిపప్పు', nameKn: 'ಗೋಡಂಬಿ ಬೀಜ', nameGu: 'કાજુ', icon: '🥜', categoryId: 'dry_fruits', benchmarkPrice: 12400.0),
    CropItem(id: 'Raisins', nameEn: 'Raisins (Bedana)', nameMr: 'बेदाणे / मनुका (तासगाव)', nameHi: 'किशमिश', nameTe: 'ఎండు ద్రాక్ష', nameKn: 'ಒಣ ದ್ರಾಕ್ಷಿ', nameGu: 'કિસમિસ', icon: '🍇', categoryId: 'dry_fruits', benchmarkPrice: 21500.0),
    CropItem(id: 'Almonds', nameEn: 'Almonds (Badam)', nameMr: 'बदाम', nameHi: 'बादाम', nameTe: 'బాదం', nameKn: 'ಬಾದಾಮಿ', nameGu: 'બદામ', icon: '🌰', categoryId: 'dry_fruits', benchmarkPrice: 52000.0),
    CropItem(id: 'Coriander', nameEn: 'Coriander Seeds (Dhana)', nameMr: 'धने', nameHi: 'धनिया बीज', nameTe: 'ధనియాలు', nameKn: 'ಕೊತ್ತಂಬರಿ ಬೀಜ', nameGu: 'ધાણા', icon: '🌿', categoryId: 'dry_fruits', benchmarkPrice: 8200.0),
    CropItem(id: 'Cumin', nameEn: 'Cumin Seeds (Jeera)', nameMr: 'जिरे', nameHi: 'जीरा', nameTe: 'జీలకర్ర', nameKn: 'ಜೀರಿಗೆ', nameGu: 'જીરું', icon: '🧂', categoryId: 'dry_fruits', benchmarkPrice: 31000.0),
  ];

  // 4. Wholesale APMC Mandis Registry
  static const List<WholesaleApmcHub> apmcHubs = [
    WholesaleApmcHub(id: 'pune-gultekdi', name: 'Pune Gultekdi Market Yard', city: 'Pune', state: 'Maharashtra', lat: 18.4900, lon: 73.8640, pricePremiumRatio: 1.05),
    WholesaleApmcHub(id: 'vashi-mumbai', name: 'Mumbai Vashi Terminal APMC', city: 'Mumbai / Vashi', state: 'Maharashtra', lat: 19.0700, lon: 73.0000, pricePremiumRatio: 1.09),
    WholesaleApmcHub(id: 'lasalgaon-nashik', name: 'Lasalgaon APMC (Asia Onion Capital)', city: 'Nashik', state: 'Maharashtra', lat: 20.1470, lon: 74.2250, pricePremiumRatio: 1.07),
    WholesaleApmcHub(id: 'pimpalgaon-nashik', name: 'Pimpalgaon Baswant APMC', city: 'Nashik', state: 'Maharashtra', lat: 20.1700, lon: 73.9800, pricePremiumRatio: 1.06),
    WholesaleApmcHub(id: 'narayangaon-pune', name: 'Narayangaon Tomato APMC', city: 'Pune', state: 'Maharashtra', lat: 19.1230, lon: 73.9780, pricePremiumRatio: 1.04),
    WholesaleApmcHub(id: 'kolhapur-shahu', name: 'Kolhapur Shahu Market Yard', city: 'Kolhapur', state: 'Maharashtra', lat: 16.7100, lon: 74.2500, pricePremiumRatio: 1.03),
    WholesaleApmcHub(id: 'jaysingpur-apmc', name: 'Jaysingpur APMC Yard', city: 'Kolhapur', state: 'Maharashtra', lat: 16.7800, lon: 74.5600, pricePremiumRatio: 1.02),
    WholesaleApmcHub(id: 'sangli-market', name: 'Sangli APMC Market Yard', city: 'Sangli', state: 'Maharashtra', lat: 16.8600, lon: 74.5900, pricePremiumRatio: 1.04),
    WholesaleApmcHub(id: 'tasgaon-apmc', name: 'Tasgaon APMC (Raisins/Grapes)', city: 'Sangli', state: 'Maharashtra', lat: 17.0300, lon: 74.6000, pricePremiumRatio: 1.08),
    WholesaleApmcHub(id: 'latur-apmc', name: 'Latur APMC Main Yard (Pulses Hub)', city: 'Latur', state: 'Maharashtra', lat: 18.4100, lon: 76.5800, pricePremiumRatio: 1.06),
    WholesaleApmcHub(id: 'solapur-apmc', name: 'Solapur APMC Market Yard', city: 'Solapur', state: 'Maharashtra', lat: 17.6600, lon: 75.9200, pricePremiumRatio: 1.03),
    WholesaleApmcHub(id: 'ahmednagar-apmc', name: 'Ahmednagar APMC Main Yard', city: 'Ahmednagar', state: 'Maharashtra', lat: 19.1000, lon: 74.7500, pricePremiumRatio: 1.03),
    WholesaleApmcHub(id: 'hinganghat-apmc', name: 'Hinganghat APMC (Cotton Hub)', city: 'Nagpur', state: 'Maharashtra', lat: 20.5500, lon: 78.8300, pricePremiumRatio: 1.08),
    WholesaleApmcHub(id: 'kalamna-nagpur', name: 'Nagpur Kalamna Terminal APMC', city: 'Nagpur', state: 'Maharashtra', lat: 21.1800, lon: 79.1300, pricePremiumRatio: 1.05),
    WholesaleApmcHub(id: 'jalgaon-apmc', name: 'Jalgaon Banana & Cotton Mandi', city: 'Jalgaon', state: 'Maharashtra', lat: 21.0100, lon: 75.5700, pricePremiumRatio: 1.05),
    WholesaleApmcHub(id: 'amravati-apmc', name: 'Amravati APMC Yard', city: 'Amravati', state: 'Maharashtra', lat: 20.9400, lon: 77.7600, pricePremiumRatio: 1.03),
    WholesaleApmcHub(id: 'akola-apmc', name: 'Akola Cotton & Pulses Mandi', city: 'Akola', state: 'Maharashtra', lat: 20.7100, lon: 77.0200, pricePremiumRatio: 1.04),
    WholesaleApmcHub(id: 'indore-choithram', name: 'Indore Choithram Mandi', city: 'Indore (MP)', state: 'Madhya Pradesh', lat: 22.6800, lon: 75.8400, pricePremiumRatio: 1.06),
    WholesaleApmcHub(id: 'belagavi-apmc', name: 'Belagavi APMC Yard', city: 'Belagavi (KA)', state: 'Karnataka', lat: 15.8600, lon: 74.5100, pricePremiumRatio: 1.03),
    WholesaleApmcHub(id: 'hyderabad-bowenpally', name: 'Hyderabad Bowenpally Terminal', city: 'Hyderabad (TG)', state: 'Telangana', lat: 17.4700, lon: 78.4800, pricePremiumRatio: 1.07),
    WholesaleApmcHub(id: 'surat-apmc', name: 'Surat APMC Mandi', city: 'Surat (Gujarat)', state: 'Gujarat', lat: 21.1800, lon: 72.8400, pricePremiumRatio: 1.05),
  ];

  // Geodesic Distance Calculation between City and Mandi
  static double calculateRoadDistanceKm({
    required double originLat,
    required double originLon,
    required double destLat,
    required double destLon,
    String? originCityName,
    String? mandiCityName,
  }) {
    // If the origin city matches the mandi city/district, intra-city distance is 5-12 km
    if (originCityName != null &&
        mandiCityName != null &&
        originCityName.toLowerCase().trim() == mandiCityName.toLowerCase().trim()) {
      return 8.0;
    }

    const double earthRadius = 6371.0;
    final dLat = _deg2rad(destLat - originLat);
    final dLon = _deg2rad(destLon - originLon);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(originLat)) * cos(_deg2rad(destLat)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final haversineKm = earthRadius * c;

    // Apply Indian road tortuosity factor (1.28)
    final roadDist = haversineKm * 1.28;
    return (roadDist < 6.0) ? 6.0 : double.parse(roadDist.toStringAsFixed(1));
  }

  static double _deg2rad(double deg) => deg * (pi / 180.0);

  // Get Candidates for a specific commodity calculated from the farmer's city
  static List<MandiCandidate> getCandidatesForCropAndCity({
    required String cropId,
    required CityLocation selectedCity,
  }) {
    final crop = crops.firstWhere(
      (c) => c.id.toLowerCase() == cropId.toLowerCase(),
      orElse: () => crops.first,
    );

    // Compute realistic candidates sorted by proximity and price premium
    List<MandiCandidate> candidates = [];

    for (final hub in apmcHubs) {
      final distance = calculateRoadDistanceKm(
        originLat: selectedCity.lat,
        originLon: selectedCity.lon,
        destLat: hub.lat,
        destLon: hub.lon,
        originCityName: selectedCity.nameEn,
        mandiCityName: hub.city,
      );

      // We filter hubs that are within feasible transit radius or major state terminals
      if (distance <= 380.0 || hub.id == 'vashi-mumbai' || hub.id == 'pune-gultekdi') {
        final modalPrice = roundToTen(crop.benchmarkPrice * hub.pricePremiumRatio);
        candidates.add(MandiCandidate(
          id: '${hub.id}-$cropId',
          name: hub.name,
          distanceKm: distance,
          modalPricePerQtl: modalPrice,
          district: hub.city,
          state: hub.state,
          yardTier: (hub.pricePremiumRatio >= 1.06) ? 'Apex Terminal' : 'APMC Yard',
        ));
      }
    }

    // Sort by proximity first, keeping top 5-6 candidate mandis
    candidates.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    if (candidates.length > 5) {
      return candidates.take(5).toList();
    }
    return candidates;
  }

  static double roundToTen(double value) {
    return (value / 10).round() * 10.0;
  }
}
