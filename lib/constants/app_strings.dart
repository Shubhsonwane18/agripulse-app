class AppStrings {
  static const Map<String, Map<String, dynamic>> _localizedValues = {
    'en': {
      'appName': 'AgriPulse',
      'appHindiName': 'किसानमित्र',
      'tagline': 'AI Decision Engine for Farmers',
      'navHome': 'Home',
      'navMarkets': 'Mandi Net',
      'navWeather': 'Weather',
      'navDisease': 'Doctor',
      'navChat': 'Kisan AI',
      'navStore': 'Store',
      'navSoil': 'Soil Health',
      'navProfile': 'Profile',
      
      // Auth & Profile
      'signIn': 'Sign In',
      'signUp': 'Create Account',
      'phoneLabel': 'WhatsApp Mobile Number',
      'emailLabel': 'Email Address',
      'passwordLabel': 'Password',
      'fullNameLabel': 'Full Name (शेतकरी)',
      'demoLogin': '⚡ 1-Click Guest / Demo Login',
      'demoSub': 'Instant access without password (Ramesh Patil - Shirol)',
      'syncNotice': 'Data automatically synced across Web & Mobile App',
      'logout': 'Sign Out',
      'language': 'Language / भाषा',

      // Weather & MOS Downscaler
      'weatherTitle': 'Hyperlocal Weather & Spray Guard',
      'weatherSubtitle': 'AI MOS Downscaling (25km global -> 2km farm resolution)',
      'safeToSpray': '✓ SAFE TO SPRAY NOW',
      'lockoutActive': '⚠ DO NOT SPRAY (LOCKOUT ACTIVE)',
      'rainWashoffRisk': 'Rain Wash-off Risk Detected',
      'windDriftRisk': 'Wind Drift Hazard Detected',
      'foliarHeatRisk': 'Foliar Heat Burn Risk',
      'hourlyWindow': 'Next 24-Hour Spraying Windows',
      'convectiveRisk': '⚡ Convective Downpour Risk',

      // Mandi Arbitrage
      'arbitrageTitle': 'Mandi Net Profit Ranker',
      'arbitrageSubtitle': 'Calculates true in-hand cash after diesel, tolls & cesses',
      'produceWeight': 'Produce Quantity (Quintals)',
      'vehicleType': 'Transport Vehicle',
      'calculateNet': 'Calculate True Net Profit',
      'bestMandi': 'Highest Net Realization',
      'grossRate': 'Gross Rate',
      'netRate': 'Net In-Hand Rate',
      'logisticsDeduction': 'Logistics Deductions',
      'dieselPrice': 'Diesel Price (₹/L)',

      // Disease Scanner
      'diseaseTitle': 'Leaf Disease Scanner',
      'diseaseSubtitle': 'AI Pathology Diagnosis & CIBRC Chemical Dosages',
      'takePhoto': 'Take Photo',
      'uploadPhoto': 'Upload Leaf Photo',
      'diagnoseBtn': 'Analyze Leaf Crop',
      'confidence': 'Model Confidence',
      'chemicalRx': 'CIBRC Prescribed Dosage',
      'sprayingValidation': 'Spray Window Validation',

      // KisanMitra Chat
      'chatTitle': 'KisanMitra Voice Assistant',
      'chatSubtitle': 'Speak in Marathi, Hindi, or English',
      'holdToSpeak': 'Hold to Speak',
      'tapToStop': 'Tap to Stop',
      'chatPlaceholder': 'Ask anything about crops, mandis, or fertilizers...',
      
      // Store & Soil
      'storeTitle': 'Agri Input Store',
      'cart': 'Cart',
      'addToCart': 'Add to Cart',
      'checkout': 'Place Order / Request',
      'soilTitle': 'Soil NPK & Health Calculator',
    },
    'mr': {
      'appName': 'अॅग्रीपल्स',
      'appHindiName': 'किसानमित्र',
      'tagline': 'शेतकऱ्यांसाठी AI निर्णय सहाय्यक',
      'navHome': 'मुख्यपृष्ठ',
      'navMarkets': 'बाजारभाव',
      'navWeather': 'हवामान',
      'navDisease': 'रोग निदान',
      'navChat': 'किसान AI',
      'navStore': 'खते व बियाणे',
      'navSoil': 'माती परीक्षण',
      'navProfile': 'माझे खाते',

      // Auth & Profile
      'signIn': 'लॉगिन करा',
      'signUp': 'नवीन खाते तयार करा',
      'phoneLabel': 'मोबाईल नंबर (व्हॉट्सॲप)',
      'emailLabel': 'ईमेल पत्ता',
      'passwordLabel': 'पासवर्ड',
      'fullNameLabel': 'पूर्ण नाव (शेतकरी)',
      'demoLogin': '⚡ झटपट शेतकरी डेमो लॉगिन',
      'demoSub': 'कोणत्याही पासवर्डशिवाय थेट सुरू करा (रमेश पाटील - शिरोळ)',
      'syncNotice': 'वेबसाइट आणि मोबाईल ॲपमध्ये खात्याचा डेटा थेट सिंक होतो',
      'logout': 'बाहेर पडा (Sign Out)',
      'language': 'भाषा बदला',

      // Weather & MOS Downscaler
      'weatherTitle': 'हवामान व फवारणी खिडकी रक्षक',
      'weatherSubtitle': 'AI डाऊनस्केलिंग (जागतिक २५ किमी -> शेत २ किमी सूक्ष्म-हवामान)',
      'safeToSpray': '✓ आत्ता फवारणी सुरक्षित',
      'lockoutActive': '⚠ आत्ता फवारू नका (धोका)',
      'rainWashoffRisk': 'पावसामुळे औषध वाहून जाण्याचा धोका',
      'windDriftRisk': 'वाऱ्याच्या वेगामुळे फवारा उडून जाण्याचा धोका',
      'foliarHeatRisk': 'तीव्र उन्हामुळे पाने जळण्याचा धोका',
      'hourlyWindow': 'पुढील २४ तासांचे फवारणी वेळापत्रक',
      'convectiveRisk': '⚡ अचानक मुसळधार पावसाचा धोका (Convective)',

      // Mandi Arbitrage
      'arbitrageTitle': 'थेट निव्वळ नफा तुलना (Arbitrage)',
      'arbitrageSubtitle': 'डिझेल, हमाली आणि सेस वजा जाता हातात उरणारा खरा नफा',
      'produceWeight': 'शेतमालाचे वजन (क्विंटल)',
      'vehicleType': 'वाहतुकीचे वाहन',
      'calculateNet': 'खरा नफा मोजा',
      'bestMandi': 'सर्वाधिक निव्वळ नफा देणारी बाजारपेठ',
      'grossRate': 'बाजार भाव',
      'netRate': 'हातात पडणारा निव्वळ दर',
      'logisticsDeduction': 'वाहतूक व बाजार खर्च वजा',
      'dieselPrice': 'डिझेल दर (₹/लीटर)',

      // Disease Scanner
      'diseaseTitle': 'पीक रोग व कीड तपासणी',
      'diseaseSubtitle': 'AI रोग निदान व CIBRC प्रमाणित औषध प्रमाण',
      'takePhoto': 'कॅमेराने फोटो काढा',
      'uploadPhoto': 'गॅलरीतून फोटो निवडा',
      'diagnoseBtn': 'रोगाचे निदान करा',
      'confidence': 'अचूकता',
      'chemicalRx': 'शिफारस केलेले औषध व प्रमाण',
      'sprayingValidation': 'फवारणी हवामान तपासणी',

      // KisanMitra Chat
      'chatTitle': 'किसानमित्र व्हॉईस AI',
      'chatSubtitle': 'मराठी, हिंदी किंवा इंग्रजीमध्ये बोला',
      'holdToSpeak': 'बोलण्यासाठी दाबा',
      'tapToStop': 'थांबवण्यासाठी टॅप करा',
      'chatPlaceholder': 'बाजारभाव, पीक रोग किंवा खतांबद्दल विचारा...',

      // Store & Soil
      'storeTitle': 'कृषी औषधे व खते दुकान',
      'cart': 'माझी खरेदी',
      'addToCart': 'खरेदीत जोडा',
      'checkout': 'ऑर्डर करा',
      'soilTitle': 'माती परीक्षण व खत सल्ला',
    },
    'hi': {
      'appName': 'एग्रीपल्स',
      'appHindiName': 'किसानमित्र',
      'tagline': 'किसानों का विश्वसनीय AI मार्गदर्शक',
      'navHome': 'होम',
      'navMarkets': 'मंडी लाभ',
      'navWeather': 'मौसम',
      'navDisease': 'फसल डॉक्टर',
      'navChat': 'किसान AI',
      'navStore': 'कृषि स्टोर',
      'navSoil': 'मृदा स्वास्थ्य',
      'navProfile': 'मेरी प्रोफाइल',

      // Auth & Profile
      'signIn': 'लॉगिन करें',
      'signUp': 'नया खाता बनाएं',
      'phoneLabel': 'मोबाइल नंबर (व्हाट्सएप)',
      'emailLabel': 'ईमेल पता',
      'passwordLabel': 'पासवर्ड',
      'fullNameLabel': 'पूरा नाम (किसान)',
      'demoLogin': '⚡ 1-क्लिक किसान डेमो लॉगिन',
      'demoSub': 'बिना पासवर्ड तुरंत शुरू करें (रमेश पाटिल - शिरोल)',
      'syncNotice': 'वेबसाइट और ऐप में आपका खाता व डेटा हमेशा सिंक रहेगा',
      'logout': 'लॉगआउट करें',
      'language': 'भाषा चुनें',

      // Weather & MOS Downscaler
      'weatherTitle': 'मौसम एवं छिड़काव विंडो रक्षक',
      'weatherSubtitle': 'AI सूक्ष्म-मौसम डाउनस्केलिंग (25 किमी -> 2 किमी खेत स्तर)',
      'safeToSpray': '✓ अभी छिड़काव सुरक्षित',
      'lockoutActive': '⚠ अभी न छिड़कें (लॉकआउट सक्रिय)',
      'rainWashoffRisk': 'बारिश से दवा बहने का खतरा',
      'windDriftRisk': 'हवा से दवा उड़ने का खतरा',
      'foliarHeatRisk': 'तेज धूप से पत्तियां झुलसने का खतरा',
      'hourlyWindow': 'अगले 24 घंटे की छिड़काव समय-सारणी',
      'convectiveRisk': '⚡ अचानक तेज बौछार का खतरा',

      // Mandi Arbitrage
      'arbitrageTitle': 'मंडी शुद्ध लाभ कैलकुलेटर',
      'arbitrageSubtitle': 'डीजल, हमाली एवं टैक्स घटाने के बाद हाथ में आने वाला शुद्ध लाभ',
      'produceWeight': 'उपज की मात्रा (क्विंटल)',
      'vehicleType': 'परिवहन वाहन',
      'calculateNet': 'शुद्ध मुनाफा निकालें',
      'bestMandi': 'सर्वाधिक शुद्ध लाभ वाली मंडी',
      'grossRate': 'मंडी भाव',
      'netRate': 'हाथ में मिलने वाला शुद्ध भाव',
      'logisticsDeduction': 'परिवहन व मंडी खर्च',
      'dieselPrice': 'डीजल दर (₹/लीटर)',

      // Disease Scanner
      'diseaseTitle': 'फसल रोग पहचान',
      'diseaseSubtitle': 'AI रोग पहचान एवं ICAR/CIBRC प्रमाणित दवा खुराक',
      'takePhoto': 'कैमरा से फोटो लें',
      'uploadPhoto': 'गैलरी से फोटो चुनें',
      'diagnoseBtn': 'रोग पहचानें',
      'confidence': 'सटीकता',
      'chemicalRx': 'प्रमाणित दवा व घोल का अनुपात',
      'sprayingValidation': 'छिड़काव मौसम सुरक्षा जांच',

      // KisanMitra Chat
      'chatTitle': 'किसानमित्र वॉइस AI',
      'chatSubtitle': 'हिंदी, मराठी या अंग्रेजी में बोलें',
      'holdToSpeak': 'बोलने के लिए दबाएं',
      'tapToStop': 'रोकने के लिए टैप करें',
      'chatPlaceholder': 'मंडी भाव, फसल रोग या खाद के बारे में पूछें...',

      // Store & Soil
      'storeTitle': 'कृषि दवा एवं खाद भंडार',
      'cart': 'कार्ट',
      'addToCart': 'कार्ट में डालें',
      'checkout': 'ऑर्डर भेजें',
      'soilTitle': 'मृदा परीक्षण एवं खाद मात्रा',
    }
  };

  static String get(String key, {String locale = 'en'}) {
    final lang = _localizedValues.containsKey(locale) ? locale : 'en';
    return _localizedValues[lang]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}
