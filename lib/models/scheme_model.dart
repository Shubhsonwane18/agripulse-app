class GovtScheme {
  final String id;
  final String title;
  final String titleMr;
  final String category; // 'irrigation', 'solar', 'insurance', 'machinery', 'direct_benefit'
  final String categoryLabelMr;
  final String subsidyText;
  final String subsidyHighlight;
  final double maxSubsidyAmount;
  final String eligibility;
  final String eligibilityMr;
  final List<String> requiredDocuments;
  final List<String> applicationSteps;
  final String portalName;
  final String portalUrl;
  final String deadline;
  final bool isFeatured;

  const GovtScheme({
    required this.id,
    required this.title,
    required this.titleMr,
    required this.category,
    required this.categoryLabelMr,
    required this.subsidyText,
    required this.subsidyHighlight,
    required this.maxSubsidyAmount,
    required this.eligibility,
    required this.eligibilityMr,
    required this.requiredDocuments,
    required this.applicationSteps,
    required this.portalName,
    required this.portalUrl,
    required this.deadline,
    this.isFeatured = false,
  });

  static List<GovtScheme> getCuratedSchemes() {
    return const [
      GovtScheme(
        id: 'pm-kusum-solar-pump',
        title: 'PM-KUSUM Solar Agricultural Pump Scheme',
        titleMr: 'पीएम-कुसुम सौर कृषी पंप योजना',
        category: 'solar',
        categoryLabelMr: '☀️ सौर ऊर्जा',
        subsidyText: 'शेतकऱ्यांना ९०% ते ९५% अनुदानावर ३ ते ७.५ HP सौर पंप मिळतो. फक्त ५% ते १०% रक्कम शेतकऱ्याला भरावी लागते.',
        subsidyHighlight: '९०% थेट सरकारी अनुदान',
        maxSubsidyAmount: 225000.0,
        eligibility: 'All farmers with borewell/open well and valid 7/12 extract.',
        eligibilityMr: 'विहीर, बोअरवेल अथवा शेततळे असणारे सर्व शेतकरी (पारंपरिक वीज कनेक्शन नसलेल्यांना प्राधान्य).',
        requiredDocuments: [
          '७/१२ व ८-अ उतारा (६ महिन्यांच्या आतील)',
          'आधार कार्ड (Aadhaar Card)',
          'बँक पासबुक झेरॉक्स (बँक खाते आधारशी लिंक)',
          'विहीर किंवा बोअरवेल पाण्याचा दाखला / स्वयंघोषणापत्र',
          'पासपोर्ट साईज फोटो व मोबाईल नंबर',
        ],
        applicationSteps: [
          '१. महाऊर्जा (MEDA) किंवा महावितरण कुसुम पोर्टलवर नोंदणी करा.',
          '२. ७/१२ व आधार क्रमांक टाकून शेतातील पाण्याची सोय निवडा.',
          '३. पंपाची क्षमता (३ HP / ५ HP / ७.५ HP) निवडून कागदपत्रे अपलोड करा.',
          '४. अर्ज मंजूर झाल्यावर लाभार्थी हिश्श्याची रक्कम (फक्त ५-१०%) ऑनलाइन भरा.',
          '५. कंपनीचे तंत्रज्ञ येऊन शेतात सोलर पॅनेल व पंप मोफत बसवून देतील.',
        ],
        portalName: 'MahaUrja / Mahadiscom KUSUM Portal',
        portalUrl: 'https://kusum.mahadiscom.in',
        deadline: 'अर्ज सध्या सुरू आहेत (Online DBT)',
        isFeatured: true,
      ),
      GovtScheme(
        id: 'mahadbt-drip-irrigation',
        title: 'Pradhan Mantri Krishi Sinchayee Yojana (Micro Irrigation)',
        titleMr: 'महाडीबीटी सूक्ष्म सिंचन योजना (ठिबक व तुषार अनुदान)',
        category: 'irrigation',
        categoryLabelMr: '💧 ठिबक सिंचन',
        subsidyText: 'अल्प व अत्यल्प भूधारक शेतकऱ्यांना ८०% आणि इतर शेतकऱ्यांना ७५% थेट अनुदान.',
        subsidyHighlight: '७५% ते ८०% थेट अनुदान',
        maxSubsidyAmount: 65000.0,
        eligibility: 'Farmers possessing agricultural land with assured water source.',
        eligibilityMr: 'सर्व पिकांसाठी (ऊस, फळबागा, भाजीपाला, कापूस) ठिबक व तुषार सिंचनासाठी उपलब्ध.',
        requiredDocuments: [
          '७/१२ आणि ८-अ उतारा',
          'आधार कार्ड व बँक पासबुक',
          'अधिकृत सिंचन विक्रेत्याचे जीएसटी कोटेशन (Quotation)',
          'विहिरीतील किंवा पाण्याचा स्त्रोताचा दाखला',
        ],
        applicationSteps: [
          '१. महाडीबीटी पोर्टलवर (mahadbt.maharashtra.gov.in) लॉगिन करा.',
          '२. ‘कृषी घटक’ ➔ ‘सूक्ष्म सिंचन’ पर्याय निवडा.',
          '३. पिकाचे नाव व क्षेत्र टाकून कंपनीचे कोटेशन अपलोड करा.',
          '४. पूर्वसंमती पत्र (Pre-Sanction) मिळाल्यावर ठिबक साहित्य शेतात बसवा.',
          '५. कृषी सहाय्यक मोका तपासणी करतील व अनुदान थेट बँक खात्यात जमा होईल.',
        ],
        portalName: 'MahaDBT Farmer Portal',
        portalUrl: 'https://mahadbt.maharashtra.gov.in',
        deadline: 'चालू आर्थिक वर्ष (सतत सुरू)',
        isFeatured: true,
      ),
      GovtScheme(
        id: 'pm-fasal-bima-yojana',
        title: 'Pradhan Mantri Fasal Bima Yojana (1 Rupee Crop Insurance)',
        titleMr: 'प्रधानमंत्री पीक विमा योजना (१ रुपयात सर्वसमावेशक पीक विमा)',
        category: 'insurance',
        categoryLabelMr: '🛡️ पीक विमा',
        subsidyText: 'शेतकऱ्याला केवळ १ रुपया भरून संपूर्ण पिकाचे दुष्काळ, पूर, अतिवृष्टी व कीड-रोगापासून संरक्षण मिळते. उर्वरित हप्ता शासन भरते.',
        subsidyHighlight: 'केवळ ₹१ मध्ये संपूर्ण पीक संरक्षण',
        maxSubsidyAmount: 85000.0,
        eligibility: 'All loanee and non-loanee farmers growing notified crops.',
        eligibilityMr: 'अधिसूचित पिके घेणारे सर्व खातेदार व भाडेपट्टीने शेती करणारे शेतकरी पात्र.',
        requiredDocuments: [
          'चालू वर्षाचा डिजिटल ७/१२ व ८-अ',
          'आधार कार्ड (Aadhaar Card)',
          'पीक पेरा स्वयंघोषणापत्र (ई-पीक पाहणी नोंद)',
          'बँक पासबुक (IFSC कोडसह)',
        ],
        applicationSteps: [
          '१. जवळच्या सीएससी (CSC) केंद्र किंवा pmfby.gov.in पोर्टलवर जा.',
          '२. गाव, गट नंबर व ई-पीक पाहणीनुसार पिकाची नोंद निवडा.',
          '३. १ रुपया नाममात्र शुल्क ऑनलाइन भरा आणि विमा पावती मिळवा.',
          '४. अतिवृष्टी किंवा नुकसान झाल्यास ७२ तासांच्या आत Crop Insurance ॲपवर तक्रार नोंदवा.',
        ],
        portalName: 'PMFBY National Crop Insurance Portal',
        portalUrl: 'https://pmfby.gov.in',
        deadline: 'खरीप: ३१ जुलै | रब्बी: १५ डिसेंबर',
        isFeatured: true,
      ),
      GovtScheme(
        id: 'magel-tyala-shet-tale',
        title: 'Magel Tyala Farm Pond / Well Subsidy Scheme',
        titleMr: 'मागेल त्याला शेततळे व विहीर योजना',
        category: 'irrigation',
        categoryLabelMr: '💧 शेततळे',
        subsidyText: 'शेततळे खोदकाम व प्लास्टिक अस्तरीकरणासाठी थेट ₹७५,००० पर्यंत अनुदान.',
        subsidyHighlight: '₹७५,००० थेट बँक अनुदान',
        maxSubsidyAmount: 75000.0,
        eligibility: 'Individual farmer possessing at least 0.60 hectare land.',
        eligibilityMr: 'किमान ०.६० हेक्टर जमीन असणारे सर्व शेतकरी पात्र.',
        requiredDocuments: [
          '७/१२ व ८-अ उतारा',
          'सहमती पत्र (संयुक्त खातेदार असल्यास)',
          'आधार कार्ड व बँक पासबुक',
        ],
        applicationSteps: [
          '१. महाडीबीटी शेतकरी पोर्टलवर शेततळे घटकासाठी अर्ज सादर करा.',
          '२. कृषी विभागाकडून जागेची पाहणी व तांत्रिक मंजुरी दिली जाते.',
          '३. खोदकाम पूर्ण झाल्यावर जिओ-टॅगिंग करून अनुदान थेट खात्यात वर्ग होते.',
        ],
        portalName: 'MahaDBT Krishi Yojana',
        portalUrl: 'https://mahadbt.maharashtra.gov.in',
        deadline: 'वर्षभर अर्ज सुरू',
      ),
      GovtScheme(
        id: 'smam-farm-machinery',
        title: 'Sub-Mission on Agricultural Mechanization (SMAM)',
        titleMr: 'कृषी यांत्रिकीकरण उप-अभियान (ट्रॅक्टर, रोटाव्हेटर व अवजारे)',
        category: 'machinery',
        categoryLabelMr: '🚜 कृषी अवजारे',
        subsidyText: 'ट्रॅक्टर, रोटाव्हेटर, पॉवर टिलर, पेरणी यंत्र आणि मळणी यंत्रावर ४०% ते ५०% अनुदान.',
        subsidyHighlight: '५०% अनुदान (₹१.२५ लाख पर्यंत)',
        maxSubsidyAmount: 125000.0,
        eligibility: 'Any registered farmer with valid land record.',
        eligibilityMr: 'सर्व शेतकरी (अनुसूचित जाती/जमाती व महिला शेतकऱ्यांना ५०% पर्यंत प्राधान्य).',
        requiredDocuments: [
          '७/१२ व ८-अ उतारा',
          'आधार कार्ड व बँक खाते',
          'अवजाराचे अधिकृत डीलर कोटेशन',
          'ड्रायव्हिंग लायसन्स (ट्रॅक्टरसाठी)',
        ],
        applicationSteps: [
          '१. महाडीबीटी पोर्टलवर कृषी यांत्रिकीकरण घटकांतर्गत अवजार निवडा.',
          '२. ऑनलाइन सोडत (Lottery) पद्धतीने लाभार्थ्यांची निवड केली जाते.',
          '३. निवड झाल्यावर अधिकृत विक्रेत्याकडून अवजार खरेदी करा आणि जीएसटी बिल अपलोड करा.',
          '४. प्रत्यक्ष तपासणीनंतर अनुदान बँक खात्यात थेट जमा होते.',
        ],
        portalName: 'SMAM Central & MahaDBT Portal',
        portalUrl: 'https://agrimachinery.nic.in',
        deadline: 'लॉटरी सोडत नियमित चालू',
      ),
      GovtScheme(
        id: 'pm-kisan-namo-shetkari',
        title: 'PM-Kisan + Namo Shetkari MahaSanman Nidhi',
        titleMr: 'नमो शेतकरी महासन्मान + पीएम-किसान सन्मान निधी',
        category: 'direct_benefit',
        categoryLabelMr: '💰 थेट बँक मदत',
        subsidyText: 'केंद्र सरकारचे ₹६,००० + महाराष्ट्र शासनाचे ₹६,००० = एकूण ₹१२,००० दरवर्षी थेट बँक खात्यात (दर ४ महिन्यांनी ₹२,००० चा हप्ता).',
        subsidyHighlight: 'दरवर्षी ₹१२,००० थेट खात्यात',
        maxSubsidyAmount: 12000.0,
        eligibility: 'Small and marginal landholder farmer families.',
        eligibilityMr: 'शेती असणारे सर्व शेतकरी कुटुंब (e-KYC पूर्ण असणे आवश्यक).',
        requiredDocuments: [
          '७/१२ व ८-अ उतारा',
          'आधार कार्ड (मोबाईल लिंक)',
          'बँक पासबुक (DBT Active)',
        ],
        applicationSteps: [
          '१. pmkisan.gov.in वर जाऊन e-KYC पूर्ण करा.',
          '२. बँक खात्यात आधार DBT सक्षम (Aadhaar Seeded) असल्याची खात्री करा.',
          '३. दर ४ महिन्यांनी केंद्र व राज्य सरकारचे हप्ते आपोआप खात्यात जमा होतात.',
        ],
        portalName: 'PM-Kisan & Namo Shetkari Portal',
        portalUrl: 'https://pmkisan.gov.in',
        deadline: 'कायमस्वरूपी सुरू (e-KYC आवश्यक)',
      ),
    ];
  }
}
