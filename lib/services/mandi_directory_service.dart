import 'dart:math';
import '../models/mandi_model.dart';

class StateLocation {
  final String id;
  final String nameEn;
  final String nameMr;
  final String nameHi;
  final String nameTe;
  final String nameKn;
  final String nameGu;
  final String icon;

  const StateLocation({
    required this.id,
    required this.nameEn,
    required this.nameMr,
    required this.nameHi,
    required this.nameTe,
    required this.nameKn,
    required this.nameGu,
    this.icon = '🏛️',
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

class CityLocation {
  final String id;
  final String stateId;
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
    required this.stateId,
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
  // 1. All Indian Agricultural States
  static const List<StateLocation> states = [
    StateLocation(id: 'maharashtra', nameEn: 'Maharashtra', nameMr: 'महाराष्ट्र', nameHi: 'महाराष्ट्र', nameTe: 'మహారాష్ట్ర', nameKn: 'ಮಹಾರಾಷ್ಟ್ರ', nameGu: 'મહારાષ્ટ્ર', icon: '🚩'),
    StateLocation(id: 'gujarat', nameEn: 'Gujarat', nameMr: 'गुजरात', nameHi: 'गुजरात', nameTe: 'గుజరాత్', nameKn: 'ಗುಜರಾತ್', nameGu: 'ગુજરાત', icon: '🦁'),
    StateLocation(id: 'madhya_pradesh', nameEn: 'Madhya Pradesh', nameMr: 'मध्य प्रदेश', nameHi: 'मध्य प्रदेश', nameTe: 'మధ్యప్రదేశ్', nameKn: 'ಮಧ್ಯಪ್ರದೇಶ', nameGu: 'મધ્ય પ્રદેશ', icon: '🌾'),
    StateLocation(id: 'karnataka', nameEn: 'Karnataka', nameMr: 'कर्नाटक', nameHi: 'कर्नाटक', nameTe: 'కర్ణాటక', nameKn: 'ಕರ್ನಾಟಕ', nameGu: 'કર્ણાટક', icon: '🌿'),
    StateLocation(id: 'uttar_pradesh', nameEn: 'Uttar Pradesh', nameMr: 'उत्तर प्रदेश', nameHi: 'उत्तर प्रदेश', nameTe: 'ఉత్తరప్రదేశ్', nameKn: 'ಉತ್ತರ ಪ್ರದೇಶ', nameGu: 'ઉત્તર પ્રદેશ', icon: '🚜'),
    StateLocation(id: 'rajasthan', nameEn: 'Rajasthan', nameMr: 'राजस्थान', nameHi: 'राजस्थान', nameTe: 'రాజస్థాన్', nameKn: 'ರಾಜಸ್ಥಾನ', nameGu: 'રાજસ્થાન', icon: '🏰'),
    StateLocation(id: 'punjab', nameEn: 'Punjab', nameMr: 'पंजाब', nameHi: 'पंजाब', nameTe: 'పంజాబ్', nameKn: 'ಪಂಜಾಬ್', nameGu: 'પંજાબ', icon: '🌾'),
    StateLocation(id: 'haryana', nameEn: 'Haryana', nameMr: 'हरियाणा', nameHi: 'हरियाणा', nameTe: 'హర్యానా', nameKn: 'ಹರಿಯಾಣ', nameGu: 'હરિયાણા', icon: '🌱'),
    StateLocation(id: 'andhra_pradesh', nameEn: 'Andhra Pradesh', nameMr: 'आंध्र प्रदेश', nameHi: 'आंध्र प्रदेश', nameTe: 'ఆంధ్రప్రదేశ్', nameKn: 'ಆಂಧ್ರಪ್ರದೇಶ', nameGu: 'આંધ્ર પ્રદેશ', icon: '🌶️'),
    StateLocation(id: 'telangana', nameEn: 'Telangana', nameMr: 'तेलंगणा', nameHi: 'तेलंगाना', nameTe: 'తెలంగాణ', nameKn: 'ತೆಲಂಗಾಣ', nameGu: 'તેલંગાણા', icon: '🌾'),
    StateLocation(id: 'tamil_nadu', nameEn: 'Tamil Nadu', nameMr: 'तमिळनाडू', nameHi: 'तमिलनाडु', nameTe: 'తమిళనాడు', nameKn: 'ತಮಿಳುನಾಡು', nameGu: 'તમિલનાડુ', icon: '🌴'),
    StateLocation(id: 'bihar', nameEn: 'Bihar', nameMr: 'बिहार', nameHi: 'बिहार', nameTe: 'బీహార్', nameKn: 'ಬಿಹಾರ', nameGu: 'બિહાર', icon: '🌽'),
    StateLocation(id: 'west_bengal', nameEn: 'West Bengal', nameMr: 'पश्चिम बंगाल', nameHi: 'पश्चिम बंगाल', nameTe: 'పశ్చిమ బెంగాల్', nameKn: 'ಪಶ್ಚಿಮ ಬಂಗಾಳ', nameGu: 'પશ્ચિમ બંગાળ', icon: '🍚'),
  ];

  // 2. Comprehensive Agricultural Cities / Districts Mapped by State
  static const List<CityLocation> cities = [
    // --- Maharashtra ---
    CityLocation(id: 'kolhapur', stateId: 'maharashtra', nameEn: 'Kolhapur', nameMr: 'कोल्हापूर', nameHi: 'कोल्हापुर', nameTe: 'కొల్హాపూర్', nameKn: 'ಕೊಲ್ಹಾಪುರ', nameGu: 'કોલ્હાપુર', lat: 16.7050, lon: 74.2433),
    CityLocation(id: 'pune', stateId: 'maharashtra', nameEn: 'Pune', nameMr: 'पुणे', nameHi: 'पुणे', nameTe: 'పుణె', nameKn: 'ಪುಣೆ', nameGu: 'પુણે', lat: 18.5204, lon: 73.8567),
    CityLocation(id: 'nashik', stateId: 'maharashtra', nameEn: 'Nashik', nameMr: 'नाशिक', nameHi: 'नासिक', nameTe: 'నాసిక్', nameKn: 'ನಾಸಿಕ್', nameGu: 'નાસિક', lat: 19.9975, lon: 73.7898),
    CityLocation(id: 'latur', stateId: 'maharashtra', nameEn: 'Latur', nameMr: 'लातूर', nameHi: 'लातूर', nameTe: 'లాతూర్', nameKn: 'ಲಾತೂರ್', nameGu: 'લાતુર', lat: 18.4088, lon: 76.5604),
    CityLocation(id: 'solapur', stateId: 'maharashtra', nameEn: 'Solapur', nameMr: 'सोलापूर', nameHi: 'सोलापुर', nameTe: 'సోలాపూర్', nameKn: 'ಸೋಲಾಪುರ', nameGu: 'સોલાપુર', lat: 17.6599, lon: 75.9064),
    CityLocation(id: 'sangli', stateId: 'maharashtra', nameEn: 'Sangli', nameMr: 'सांगली', nameHi: 'सांगली', nameTe: 'సాంగ్లీ', nameKn: 'ಸಾಂಗ್ಲಿ', nameGu: 'સાંગલી', lat: 16.8524, lon: 74.5815),
    CityLocation(id: 'ahmednagar', stateId: 'maharashtra', nameEn: 'Ahmednagar', nameMr: 'अहमदनगर', nameHi: 'अहमदनगर', nameTe: 'అహ్మద్ నగర్', nameKn: 'ಅಹ್ಮದ್ ನಗರ', nameGu: 'અહમદનગર', lat: 19.0948, lon: 74.7480),
    CityLocation(id: 'nagpur', stateId: 'maharashtra', nameEn: 'Nagpur', nameMr: 'नागपूर', nameHi: 'नागपुर', nameTe: 'నాగ్‌పూర్', nameKn: 'ನಾಗಪುರ', nameGu: 'નાગપુર', lat: 21.1458, lon: 79.0882),
    CityLocation(id: 'aurangabad', stateId: 'maharashtra', nameEn: 'Chhatrapati Sambhaji Nagar', nameMr: 'छत्रपती संभाजीनगर', nameHi: 'संभाजीनगर (औरंगाबाद)', nameTe: 'సంభాజీనగర్', nameKn: 'ಸಂಭಾಜಿನಗರ', nameGu: 'સંભાજીનગર', lat: 19.8762, lon: 75.3433),
    CityLocation(id: 'jalgaon', stateId: 'maharashtra', nameEn: 'Jalgaon', nameMr: 'जळगाव', nameHi: 'जलगांव', nameTe: 'జల్గావ్', nameKn: 'ಜಲಗಾಂವ್', nameGu: 'જળગાંવ', lat: 21.0077, lon: 75.5626),
    CityLocation(id: 'amravati', stateId: 'maharashtra', nameEn: 'Amravati', nameMr: 'अमरावती', nameHi: 'अमरावती', nameTe: 'అమరావతి', nameKn: 'ಅಮರಾವತಿ', nameGu: 'અમરાવતી', lat: 20.9320, lon: 77.7523),
    CityLocation(id: 'nanded', stateId: 'maharashtra', nameEn: 'Nanded', nameMr: 'नांदेड', nameHi: 'नांदेड़', nameTe: 'నాందేడ్', nameKn: 'ನಾಂದೇಡ್', nameGu: 'નાંદેડ', lat: 19.1383, lon: 77.3210),
    CityLocation(id: 'akola', stateId: 'maharashtra', nameEn: 'Akola', nameMr: 'अकोला', nameHi: 'अकोला', nameTe: 'అకోలా', nameKn: 'ಅಕೋಲಾ', nameGu: 'અકોલા', lat: 20.7002, lon: 77.0082),
    CityLocation(id: 'satara', stateId: 'maharashtra', nameEn: 'Satara', nameMr: 'सातारा', nameHi: 'सतारा', nameTe: 'సతారా', nameKn: 'ಸತಾರಾ', nameGu: 'સાતારા', lat: 17.6805, lon: 74.0183),
    CityLocation(id: 'mumbai', stateId: 'maharashtra', nameEn: 'Mumbai / Vashi', nameMr: 'मुंबई / वाशी', nameHi: 'मुंबई / वाशी', nameTe: 'ముంబై / వాషి', nameKn: 'ಮುಂಬೈ / ವಾಶಿ', nameGu: 'મુંબઈ / વાશી', lat: 19.0760, lon: 72.8777),

    // --- Gujarat ---
    CityLocation(id: 'surat', stateId: 'gujarat', nameEn: 'Surat', nameMr: 'सुरत', nameHi: 'सूरत', nameTe: 'సూరత్', nameKn: 'ಸೂರತ್', nameGu: 'સુરત', lat: 21.1702, lon: 72.8311),
    CityLocation(id: 'rajkot', stateId: 'gujarat', nameEn: 'Rajkot', nameMr: 'राजकोट', nameHi: 'राजकोट', nameTe: 'రాజ్‌కోట్', nameKn: 'ರಾಜಕೋಟ್', nameGu: 'રાજકોટ', lat: 22.3039, lon: 70.8022),
    CityLocation(id: 'ahmedabad', stateId: 'gujarat', nameEn: 'Ahmedabad', nameMr: 'अहमदाबाद', nameHi: 'अहमदाबाद', nameTe: 'అహ్మదాబాద్', nameKn: 'ಅಹಮದಾಬಾದ್', nameGu: 'અમદાવાદ', lat: 23.0225, lon: 72.5714),
    CityLocation(id: 'gondal', stateId: 'gujarat', nameEn: 'Gondal (Groundnut Hub)', nameMr: 'गोंडल', nameHi: 'गोंडल', nameTe: 'గోండల్', nameKn: 'ಗೊಂದಿಗೆ', nameGu: 'ગોંડલ', lat: 21.9619, lon: 70.7936),
    CityLocation(id: 'unjha', stateId: 'gujarat', nameEn: 'Unjha (Jeera & Spices Hub)', nameMr: 'उंझा (जिरे मंडी)', nameHi: 'ऊंझा (मंडी)', nameTe: 'ఉంజా', nameKn: 'ಉಂಜಾ', nameGu: 'ઊંઝા (જીરું માર્કેટ)', lat: 23.8037, lon: 72.3957),
    CityLocation(id: 'vadodara', stateId: 'gujarat', nameEn: 'Vadodara', nameMr: 'वडोदरा', nameHi: 'वडोदरा', nameTe: 'వడోదర', nameKn: 'ವಡೋದರಾ', nameGu: 'વડોદરા', lat: 22.3072, lon: 73.1812),

    // --- Madhya Pradesh ---
    CityLocation(id: 'indore', stateId: 'madhya_pradesh', nameEn: 'Indore', nameMr: 'इंदूर', nameHi: 'इंदौर', nameTe: 'ఇండోర్', nameKn: 'ಇಂದೋರ್', nameGu: 'ઇન્દોર', lat: 22.7196, lon: 75.8577),
    CityLocation(id: 'ujjoin', stateId: 'madhya_pradesh', nameEn: 'Ujjain', nameMr: 'उज्जैन', nameHi: 'उज्जैन', nameTe: 'ఉజ్జయిని', nameKn: 'ಉಜ್ಜಯಿನಿ', nameGu: 'ઉજ્જૈન', lat: 23.1765, lon: 75.7885),
    CityLocation(id: 'bhopal', stateId: 'madhya_pradesh', nameEn: 'Bhopal', nameMr: 'भोपाळ', nameHi: 'भोपाल', nameTe: 'భోపాల్', nameKn: 'ಭೋಪಾಲ್', nameGu: 'ભોપાલ', lat: 23.2599, lon: 77.4126),
    CityLocation(id: 'neemuch', stateId: 'madhya_pradesh', nameEn: 'Neemuch (Garlic Hub)', nameMr: 'नीमच (लसूण मंडी)', nameHi: 'नीमच (लहसुन मंडी)', nameTe: 'నీమచ్', nameKn: 'ನೀಮಚ್', nameGu: 'નીમચ (લસણ)', lat: 24.4646, lon: 74.8732),
    CityLocation(id: 'mandsaur', stateId: 'madhya_pradesh', nameEn: 'Mandsaur', nameMr: 'मंदसौर', nameHi: 'मंदसौर', nameTe: 'మంద్సౌర్', nameKn: 'ಮಂದಸೌರ್', nameGu: 'મંદસૌર', lat: 24.0722, lon: 75.0683),

    // --- Karnataka ---
    CityLocation(id: 'belagavi', stateId: 'karnataka', nameEn: 'Belagavi', nameMr: 'बेळगाव', nameHi: 'बेलगाम', nameTe: 'బెళగావి', nameKn: 'ಬೆಳಗಾವಿ', nameGu: 'બેલગામ', lat: 15.8497, lon: 74.4977),
    CityLocation(id: 'hubballi', stateId: 'karnataka', nameEn: 'Hubballi - Dharwad', nameMr: 'हुबळी-धारवाड', nameHi: 'हुबली-धारवाड़', nameTe: 'హుబ్లీ-ధార్వాడ్', nameKn: 'ಹುಬ್ಬಳ್ಳಿ-ಧಾರವಾಡ', nameGu: 'હુબલી', lat: 15.3647, lon: 75.1240),
    CityLocation(id: 'bengaluru', stateId: 'karnataka', nameEn: 'Bengaluru (Yeshwanthpur)', nameMr: 'बंगळूरू', nameHi: 'बेंगलुरु', nameTe: 'బెంగళూరు', nameKn: 'ಬೆಂಗಳೂರು (ಯಶವಂತಪುರ)', nameGu: 'બેંગ્લોર', lat: 12.9716, lon: 77.5946),
    CityLocation(id: 'kalaburagi', stateId: 'karnataka', nameEn: 'Kalaburagi (Gulbarga Tur)', nameMr: 'कलबुर्गी (तूर हब)', nameHi: 'कलबुर्गी (गुलबर्गा)', nameTe: 'కలబురగి', nameKn: 'ಕಲಬುರಗಿ (ತೊಗರಿ ಹಬ್)', nameGu: 'કલબુર્ગી', lat: 17.3297, lon: 76.8343),
    CityLocation(id: 'vijayapura', stateId: 'karnataka', nameEn: 'Vijayapura (Bijapur)', nameMr: 'विजापूर', nameHi: 'बीजापुर', nameTe: 'విజయపుర', nameKn: 'ವಿಜಯಪುರ', nameGu: 'વિજયપુરા', lat: 16.8302, lon: 75.7100),

    // --- Uttar Pradesh ---
    CityLocation(id: 'agra', stateId: 'uttar_pradesh', nameEn: 'Agra (Potato Hub)', nameMr: 'आग्रा (बटाटा हब)', nameHi: 'आगरा (आलू मंडी)', nameTe: 'ఆగ్రా', nameKn: 'ಆಗ್ರಾ', nameGu: 'આગ્રા (બટાકા)', lat: 27.1767, lon: 78.0081),
    CityLocation(id: 'kanpur', stateId: 'uttar_pradesh', nameEn: 'Kanpur', nameMr: 'कानपूर', nameHi: 'कानपुर', nameTe: 'కాన్పూర్', nameKn: 'ಕಾನ್ಪುರ', nameGu: 'કાનપુર', lat: 26.4499, lon: 80.3319),
    CityLocation(id: 'lucknow', stateId: 'uttar_pradesh', nameEn: 'Lucknow', nameMr: 'लखनौ', nameHi: 'लखनऊ', nameTe: 'లక్నో', nameKn: 'ಲಕ್ನೋ', nameGu: 'લખનૌ', lat: 26.8467, lon: 80.9462),
    CityLocation(id: 'varanasi', stateId: 'uttar_pradesh', nameEn: 'Varanasi', nameMr: 'वाराणसी', nameHi: 'वाराणसी', nameTe: 'వారణాసి', nameKn: 'ವಾರಣಾಸಿ', nameGu: 'વારાણસી', lat: 25.3176, lon: 82.9739),

    // --- Rajasthan ---
    CityLocation(id: 'jaipur', stateId: 'rajasthan', nameEn: 'Jaipur', nameMr: 'जयपूर', nameHi: 'जयपुर', nameTe: 'జైపూర్', nameKn: 'ಜೈಪುರ', nameGu: 'જયપુર', lat: 26.9124, lon: 75.7873),
    CityLocation(id: 'kota', stateId: 'rajasthan', nameEn: 'Kota (Grain & Soybean Mandi)', nameMr: 'कोटा', nameHi: 'कोटा (सोयाबीन व अनाज मंडी)', nameTe: 'కోట', nameKn: 'ಕೋಟಾ', nameGu: 'કોટા', lat: 25.2138, lon: 75.8648),
    CityLocation(id: 'bikaner', stateId: 'rajasthan', nameEn: 'Bikaner (Moth/Guar Hub)', nameMr: 'बिकानेर', nameHi: 'बीकानेर', nameTe: 'బికనీర్', nameKn: 'ಬಿಕಾನೇರ್', nameGu: 'બિકાનેર', lat: 28.0229, lon: 73.3119),

    // --- Punjab ---
    CityLocation(id: 'khanna', stateId: 'punjab', nameEn: 'Khanna (Asia Largest Grain Mandi)', nameMr: 'खन्ना (धान्य बाजार)', nameHi: 'खन्ना (एशिया की सबसे बड़ी मंडी)', nameTe: 'ఖన్నా', nameKn: 'ಖನ್ನಾ', nameGu: 'ખન્ના (અનાજ માર્કેટ)', lat: 30.7073, lon: 76.2167),
    CityLocation(id: 'ludhiana', stateId: 'punjab', nameEn: 'Ludhiana', nameMr: 'लुधियाना', nameHi: 'लुधियाना', nameTe: 'లుధియానా', nameKn: 'ಲುಧಿಯಾನಾ', nameGu: 'લુધિયાણા', lat: 30.9010, lon: 75.8573),
    CityLocation(id: 'amritsar', stateId: 'punjab', nameEn: 'Amritsar', nameMr: 'अमृतसर', nameHi: 'अमृतसर', nameTe: 'అమృత్‌సర్', nameKn: 'ಅಮೃತಸರ', nameGu: 'અમૃતસર', lat: 31.6340, lon: 74.8723),

    // --- Haryana ---
    CityLocation(id: 'karnal', stateId: 'haryana', nameEn: 'Karnal (Basmati Rice Hub)', nameMr: 'करनाल (बासमती हब)', nameHi: 'करनाल (बासमती चावल)', nameTe: 'కర్నాల్', nameKn: 'ಕರ್ನಾಲ್', nameGu: 'કરનાલ', lat: 29.6857, lon: 76.9905),
    CityLocation(id: 'sirsa', stateId: 'haryana', nameEn: 'Sirsa (Cotton Yard)', nameMr: 'सिरसा (कापूस)', nameHi: 'सिरसा (कपास मंडी)', nameTe: 'సిర్సా', nameKn: 'ಸಿರ್ಸಾ', nameGu: 'સિરસા', lat: 29.5349, lon: 75.0298),

    // --- Andhra Pradesh ---
    CityLocation(id: 'guntur', stateId: 'andhra_pradesh', nameEn: 'Guntur (Asia Chilli Capital)', nameMr: 'गुंटूर (मिरची हब)', nameHi: 'गुंटूर (मिर्च मंडी)', nameTe: 'గుంటూరు (మిర్చి యార్డ్)', nameKn: 'ಗುಂಟೂರು', nameGu: 'ગુંટુર (મરચાં માર્કેટ)', lat: 16.3067, lon: 80.4365),
    CityLocation(id: 'vijayawada', stateId: 'andhra_pradesh', nameEn: 'Vijayawada', nameMr: 'विजयवाडा', nameHi: 'विजयवाड़ा', nameTe: 'విజయవాడ', nameKn: 'ವಿಜಯವಾಡ', nameGu: 'વિજયવાડા', lat: 16.5062, lon: 80.6480),
    CityLocation(id: 'kurnool', stateId: 'andhra_pradesh', nameEn: 'Kurnool', nameMr: 'कुर्नूल', nameHi: 'कुरनूल', nameTe: 'కర్నూలు', nameKn: 'ಕರ್ನೂಲ್', nameGu: 'કુર્નૂલ', lat: 15.8281, lon: 78.0373),

    // --- Telangana ---
    CityLocation(id: 'hyderabad', stateId: 'telangana', nameEn: 'Hyderabad (Bowenpally)', nameMr: 'हैदराबाद', nameHi: 'हैदराबाद', nameTe: 'హైదరాబాద్ (బోయిన్‌పల్లి)', nameKn: 'ಹೈದರಾಬಾದ್', nameGu: 'હૈદરાબાદ', lat: 17.3850, lon: 78.4867),
    CityLocation(id: 'warangal', stateId: 'telangana', nameEn: 'Warangal (Cotton & Grain Yard)', nameMr: 'वारंगल', nameHi: 'वारंगल', nameTe: 'వరంగల్', nameKn: 'ವರಂಗಲ್', nameGu: 'વારંગલ', lat: 17.9689, lon: 79.5941),
    CityLocation(id: 'nizamabad', stateId: 'telangana', nameEn: 'Nizamabad (Turmeric Mandi)', nameMr: 'निजामाबाद (हळद)', nameHi: 'निजामाबाद (हल्दी)', nameTe: 'నిజామాబాద్ (పసుపు మార్కెట్)', nameKn: 'ನಿಜಾಮಾಬಾದ್', nameGu: 'નિઝામાબાદ', lat: 18.6725, lon: 78.0941),

    // --- Tamil Nadu ---
    CityLocation(id: 'erode', stateId: 'tamil_nadu', nameEn: 'Erode (Turmeric City)', nameMr: 'इरोड (हळद मंडी)', nameHi: 'इरोड (हल्दी मंडी)', nameTe: 'ఈరోడ్', nameKn: 'ಈರೋಡ್', nameGu: 'ઇરોડ', lat: 11.3410, lon: 77.7172),
    CityLocation(id: 'chennai', stateId: 'tamil_nadu', nameEn: 'Chennai (Koyambedu Wholesale)', nameMr: 'चेन्नई (कोयंबेडू)', nameHi: 'चेन्नई (कोयम्बेडु)', nameTe: 'చెన్నై', nameKn: 'ಚೆನ್ನೈ', nameGu: 'ચેન્નઈ', lat: 13.0827, lon: 80.2707),

    // --- Bihar ---
    CityLocation(id: 'purnia', stateId: 'bihar', nameEn: 'Purnia (Gulabbagh Maize Hub)', nameMr: 'पूर्णिया (गुलाबबाग मका)', nameHi: 'पूर्णिया (गुलाबबाग मक्का मंडी)', nameTe: 'పూర్ణియా', nameKn: 'ಪೂರ್ಣಿಯಾ', nameGu: 'પૂર્ણિયા (મકાઈ)', lat: 25.7771, lon: 87.4753),
    CityLocation(id: 'patna', stateId: 'bihar', nameEn: 'Patna', nameMr: 'पाटणा', nameHi: 'पटना', nameTe: 'పాట్నా', nameKn: 'ಪಾಟ್ನಾ', nameGu: 'પટના', lat: 25.5941, lon: 85.1376),

    // --- West Bengal ---
    CityLocation(id: 'kolkata', stateId: 'west_bengal', nameEn: 'Kolkata (Posta Bazar)', nameMr: 'कोलकाता', nameHi: 'कोलकाता (पोस्ता बाज़ार)', nameTe: 'కోల్‌కతా', nameKn: 'ಕೋಲ್ಕತ್ತಾ', nameGu: 'કોલકાતા', lat: 22.5726, lon: 88.3639),
    CityLocation(id: 'siliguri', stateId: 'west_bengal', nameEn: 'Siliguri', nameMr: 'सिलीगुडी', nameHi: 'सिलीगुड़ी', nameTe: 'సిలిగురి', nameKn: 'ಸಿಲಿಗುರಿ', nameGu: 'સિલીગુડી', lat: 26.7271, lon: 88.3953),
  ];

  static List<CityLocation> getCitiesByState(String stateId) {
    final filtered = cities.where((c) => c.stateId == stateId).toList();
    return filtered.isNotEmpty ? filtered : [cities.first];
  }

  // 3. Crop Categories
  static const List<CropCategoryItem> categories = [
    CropCategoryItem(id: 'grains', nameEn: 'Grains & Pulses', nameMr: 'अन्नधान्य व कडधान्ये', nameHi: 'अन्न व दलहन', nameTe: 'ధాన్యాలు & పప్పులు', nameKn: 'ಧಾನ್ಯಗಳು ಮತ್ತು ಬೇಳೆಗಳು', nameGu: 'અનાજ અને કઠોળ', icon: '🌾'),
    CropCategoryItem(id: 'vegetables', nameEn: 'Vegetables', nameMr: 'भाजीपाला', nameHi: 'सब्जियां', nameTe: 'కూరగాయలు', nameKn: 'ತರಕಾರಿಗಳು', nameGu: 'શાકભાજી', icon: '🥦'),
    CropCategoryItem(id: 'fruits', nameEn: 'Fresh Fruits', nameMr: 'फळे', nameHi: 'फल', nameTe: 'పండ్లు', nameKn: 'ಹಣ್ಣುಗಳು', nameGu: 'ફળો', icon: '🍎'),
    CropCategoryItem(id: 'cash_crops', nameEn: 'Cash Crops', nameMr: 'नगदी पिके', nameHi: 'नकदी फसलें', nameTe: 'వాణిజ్య పంటలు', nameKn: 'ವಾಣಿಜ್ಯ ಬೆಳೆಗಳು', nameGu: 'રોકડિયા પાકો', icon: '🎋'),
    CropCategoryItem(id: 'dry_fruits', nameEn: 'Dry Fruits & Spices', nameMr: 'सुका मेवा व मसाले', nameHi: 'सूखे मेवे व मसाले', nameTe: 'డ్రై ఫ్రూట్స్ & మసాలాలు', nameKn: 'ಡ್ರೈ ಫ್ರೂಟ್ಸ್ & ಮಸಾಲೆಗಳು', nameGu: 'સૂકા મેવા અને મસાલા', icon: '🥜'),
  ];

  // 4. Categorized Crops Catalog (34 Crops)
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

  // 5. Wholesale APMC Mandis Registry Across Key Agricultural States
  static const List<WholesaleApmcHub> apmcHubs = [
    // Maharashtra
    WholesaleApmcHub(id: 'pune-gultekdi', name: 'Pune Gultekdi Market Yard', city: 'Pune', state: 'Maharashtra', lat: 18.4900, lon: 73.8640, pricePremiumRatio: 1.05),
    WholesaleApmcHub(id: 'vashi-mumbai', name: 'Mumbai Vashi Terminal APMC', city: 'Mumbai / Vashi', state: 'Maharashtra', lat: 19.0700, lon: 73.0000, pricePremiumRatio: 1.09),
    WholesaleApmcHub(id: 'lasalgaon-nashik', name: 'Lasalgaon APMC (Asia Onion Capital)', city: 'Nashik', state: 'Maharashtra', lat: 20.1470, lon: 74.2250, pricePremiumRatio: 1.07),
    WholesaleApmcHub(id: 'pimpalgaon-nashik', name: 'Pimpalgaon Baswant APMC', city: 'Nashik', state: 'Maharashtra', lat: 20.1700, lon: 73.9800, pricePremiumRatio: 1.06),
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

    // Gujarat
    WholesaleApmcHub(id: 'gondal-apmc', name: 'Gondal Marketing Yard (Groundnut/Chilli)', city: 'Gondal (Groundnut Hub)', state: 'Gujarat', lat: 21.9650, lon: 70.8000, pricePremiumRatio: 1.07),
    WholesaleApmcHub(id: 'unjha-apmc', name: 'Unjha APMC (Asia Cumin/Jeera Capital)', city: 'Unjha (Jeera & Spices Hub)', state: 'Gujarat', lat: 23.8050, lon: 72.4000, pricePremiumRatio: 1.10),
    WholesaleApmcHub(id: 'rajkot-apmc', name: 'Rajkot APMC Bedi Market Yard', city: 'Rajkot', state: 'Gujarat', lat: 22.3100, lon: 70.8100, pricePremiumRatio: 1.05),
    WholesaleApmcHub(id: 'surat-apmc', name: 'Surat APMC Mandi', city: 'Surat', state: 'Gujarat', lat: 21.1800, lon: 72.8400, pricePremiumRatio: 1.05),
    WholesaleApmcHub(id: 'ahmedabad-apmc', name: 'Ahmedabad Jamalpur Wholesale APMC', city: 'Ahmedabad', state: 'Gujarat', lat: 23.0150, lon: 72.5800, pricePremiumRatio: 1.06),

    // Madhya Pradesh
    WholesaleApmcHub(id: 'neemuch-mandi', name: 'Neemuch Krishi Upaj Mandi (Garlic Capital)', city: 'Neemuch (Garlic Hub)', state: 'Madhya Pradesh', lat: 24.4700, lon: 74.8800, pricePremiumRatio: 1.09),
    WholesaleApmcHub(id: 'mandsaur-mandi', name: 'Mandsaur Krishi Upaj Mandi', city: 'Mandsaur', state: 'Madhya Pradesh', lat: 24.0800, lon: 75.0800, pricePremiumRatio: 1.06),
    WholesaleApmcHub(id: 'indore-choithram', name: 'Indore Choithram Terminal Mandi', city: 'Indore', state: 'Madhya Pradesh', lat: 22.6800, lon: 75.8400, pricePremiumRatio: 1.06),
    WholesaleApmcHub(id: 'ujjoin-mandi', name: 'Ujjain Chimanganj Mandi', city: 'Ujjain', state: 'Madhya Pradesh', lat: 23.1800, lon: 75.8000, pricePremiumRatio: 1.04),

    // Karnataka
    WholesaleApmcHub(id: 'belagavi-apmc', name: 'Belagavi APMC Yard', city: 'Belagavi', state: 'Karnataka', lat: 15.8600, lon: 74.5100, pricePremiumRatio: 1.03),
    WholesaleApmcHub(id: 'yeshwanthpur-apmc', name: 'Bengaluru Yeshwanthpur APMC Yard', city: 'Bengaluru (Yeshwanthpur)', state: 'Karnataka', lat: 13.0230, lon: 77.5450, pricePremiumRatio: 1.08),
    WholesaleApmcHub(id: 'kalaburagi-apmc', name: 'Kalaburagi APMC (Tur/Pigeon Pea Hub)', city: 'Kalaburagi (Gulbarga Tur)', state: 'Karnataka', lat: 17.3350, lon: 76.8400, pricePremiumRatio: 1.07),
    WholesaleApmcHub(id: 'hubballi-apmc', name: 'Hubballi Amargol APMC Yard', city: 'Hubballi - Dharwad', state: 'Karnataka', lat: 15.3700, lon: 75.1300, pricePremiumRatio: 1.04),

    // Uttar Pradesh & Delhi NCR
    WholesaleApmcHub(id: 'agra-mandi', name: 'Agra Fatehabad Road Mandi (Potato Hub)', city: 'Agra (Potato Hub)', state: 'Uttar Pradesh', lat: 27.1650, lon: 78.0200, pricePremiumRatio: 1.06),
    WholesaleApmcHub(id: 'kanpur-mandi', name: 'Kanpur Chakeri Mandi Yard', city: 'Kanpur', state: 'Uttar Pradesh', lat: 26.4400, lon: 80.3500, pricePremiumRatio: 1.05),
    WholesaleApmcHub(id: 'varanasi-mandi', name: 'Varanasi Pahariya APMC Mandi', city: 'Varanasi', state: 'Uttar Pradesh', lat: 25.3400, lon: 83.0100, pricePremiumRatio: 1.04),

    // Rajasthan
    WholesaleApmcHub(id: 'kota-mandi', name: 'Kota Bhamashah Krishi Mandi (Soybean Hub)', city: 'Kota (Grain & Soybean Mandi)', state: 'Rajasthan', lat: 25.2100, lon: 75.8700, pricePremiumRatio: 1.07),
    WholesaleApmcHub(id: 'bikaner-mandi', name: 'Bikaner Grain & Moth Mandi', city: 'Bikaner (Moth/Guar Hub)', state: 'Rajasthan', lat: 28.0300, lon: 73.3200, pricePremiumRatio: 1.06),
    WholesaleApmcHub(id: 'jaipur-muhana', name: 'Jaipur Muhana Terminal APMC', city: 'Jaipur', state: 'Rajasthan', lat: 26.8200, lon: 75.7600, pricePremiumRatio: 1.05),

    // Punjab & Haryana
    WholesaleApmcHub(id: 'khanna-mandi', name: 'Khanna Grain Market (Asia No. 1 Wheat Yard)', city: 'Khanna (Asia Largest Grain Mandi)', state: 'Punjab', lat: 30.7100, lon: 76.2200, pricePremiumRatio: 1.08),
    WholesaleApmcHub(id: 'ludhiana-mandi', name: 'Ludhiana Gill Road Mandi', city: 'Ludhiana', state: 'Punjab', lat: 30.9000, lon: 75.8600, pricePremiumRatio: 1.05),
    WholesaleApmcHub(id: 'karnal-mandi', name: 'Karnal Grain & Basmati Rice Market', city: 'Karnal (Basmati Rice Hub)', state: 'Haryana', lat: 29.6900, lon: 77.0000, pricePremiumRatio: 1.07),
    WholesaleApmcHub(id: 'sirsa-mandi', name: 'Sirsa New Cotton Market Yard', city: 'Sirsa (Cotton Yard)', state: 'Haryana', lat: 29.5400, lon: 75.0400, pricePremiumRatio: 1.06),

    // Andhra Pradesh & Telangana
    WholesaleApmcHub(id: 'guntur-mirchi', name: 'Guntur Mirchi Yard (Asia No. 1 Chilli Market)', city: 'Guntur (Asia Chilli Capital)', state: 'Andhra Pradesh', lat: 16.3100, lon: 80.4400, pricePremiumRatio: 1.10),
    WholesaleApmcHub(id: 'nizamabad-apmc', name: 'Nizamabad APMC (Turmeric Terminal)', city: 'Nizamabad (Turmeric Mandi)', state: 'Telangana', lat: 18.6800, lon: 78.1000, pricePremiumRatio: 1.08),
    WholesaleApmcHub(id: 'hyderabad-bowenpally', name: 'Hyderabad Bowenpally Terminal', city: 'Hyderabad (Bowenpally)', state: 'Telangana', lat: 17.4700, lon: 78.4800, pricePremiumRatio: 1.07),
    WholesaleApmcHub(id: 'warangal-apmc', name: 'Warangal Enumamula Grain & Cotton Yard', city: 'Warangal (Cotton & Grain Yard)', state: 'Telangana', lat: 17.9800, lon: 79.6000, pricePremiumRatio: 1.06),

    // Tamil Nadu
    WholesaleApmcHub(id: 'erode-mandi', name: 'Erode Semmampalayam Turmeric Market', city: 'Erode (Turmeric City)', state: 'Tamil Nadu', lat: 11.3450, lon: 77.7200, pricePremiumRatio: 1.09),
    WholesaleApmcHub(id: 'chennai-koyambedu', name: 'Chennai Koyambedu Wholesale Market Complex', city: 'Chennai (Koyambedu Wholesale)', state: 'Tamil Nadu', lat: 13.0700, lon: 80.1900, pricePremiumRatio: 1.08),

    // Bihar & West Bengal
    WholesaleApmcHub(id: 'purnia-gulabbagh', name: 'Gulabbagh Mandi Purnia (Asia Maize Hub)', city: 'Purnia (Gulabbagh Maize Hub)', state: 'Bihar', lat: 25.7800, lon: 87.4900, pricePremiumRatio: 1.08),
    WholesaleApmcHub(id: 'kolkata-posta', name: 'Kolkata Posta Wholesale Bazar', city: 'Kolkata (Posta Bazar)', state: 'West Bengal', lat: 22.5800, lon: 88.3600, pricePremiumRatio: 1.07),
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

      final modalPrice = roundToTen(crop.benchmarkPrice * hub.pricePremiumRatio);
      candidates.add(MandiCandidate(
        id: '${hub.id}-$cropId',
        name: hub.name,
        distanceKm: distance,
        modalPricePerQtl: modalPrice,
        district: hub.city,
        state: hub.state,
        yardTier: (hub.pricePremiumRatio >= 1.07) ? 'Apex Terminal' : 'APMC Yard',
      ));
    }

    // Sort by proximity first, keeping top 5 candidate mandis nearest to the selected city
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
