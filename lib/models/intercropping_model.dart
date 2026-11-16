class IntercropPlan {
  final String id;
  final String name;
  final String nameMr;
  final String mainCrop;
  final String interCrop;
  final String rowRatio;
  final String rowVisual;
  final String season;
  final String potentialGainText;
  final double extraIncomePerAcre;
  final String spacingGuideline;
  final String scientificRationale;
  final String managementTip;
  final bool isTopRecommended;

  const IntercropPlan({
    required this.id,
    required this.name,
    required this.nameMr,
    required this.mainCrop,
    required this.interCrop,
    required this.rowRatio,
    required this.rowVisual,
    required this.season,
    required this.potentialGainText,
    required this.extraIncomePerAcre,
    required this.spacingGuideline,
    required this.scientificRationale,
    required this.managementTip,
    this.isTopRecommended = false,
  });

  static List<IntercropPlan> getProvenPlans() {
    return const [
      IntercropPlan(
        id: 'soybean-tur-4-2',
        name: 'Soybean + Pigeon Pea (Tur)',
        nameMr: 'सोयाबीन + तूर (४:२ आंतरपीक)',
        mainCrop: 'सोयाबीन (Soybean)',
        interCrop: 'तूर (Pigeon Pea / Arhar)',
        rowRatio: '४:२ (४ ओळी सोयाबीन + २ ओळी तूर)',
        rowVisual: '🌱 🌱 🌱 🌱  🌾 🌾  🌱 🌱 🌱 🌱',
        season: 'खरीप हंगाम (Kharif)',
        potentialGainText: 'एकरी ₹१८,००० ते ₹२६,००० अतिरिक्त निव्वळ नफा',
        extraIncomePerAcre: 22000.0,
        spacingGuideline: 'सोयाबीन ओळीत ३० सेमी अंतर; तुरीच्या दोन ओळींत ६० सेमी अंतर. तुरीची पेरणी सोयाबीनसोबतच करावी.',
        scientificRationale: '१. दोन्ही पिकांचे मुळांचे क्षेत्र वेगळे असते: सोयाबीनची मुळे वरच्या थरात तर तुरीचे सोटमूळ जमिनीत खोल जाऊन ओलावा व अन्नद्रव्ये घेते.\n२. तूर जमिनीत हवेतील नत्र (Nitrogen) स्थिर करते, ज्यामुळे रासायनिक खतांचा खर्च २५% वाचतो.\n३. सोयाबीन ९०-१०० दिवसांत निघून जाते, त्यानंतर तुरीला संपूर्ण सूर्यप्रकाश व विस्तार मिळून भरघोस उत्पादन मिळते.',
        managementTip: 'तुरीवर शेंगा पोखरणारी अळी येऊ नये म्हणून कळी अवस्थेत निंबोळी अर्क ५% किंवा क्लोराँट्रानिलीप्रोलची वेळेवर फवारणी करा.',
        isTopRecommended: true,
      ),
      IntercropPlan(
        id: 'cotton-greengram-1-1',
        name: 'Cotton + Green Gram (Moong)',
        nameMr: 'कापूस + मूग / उडीद (१:१ किंवा १:२ आंतरपीक)',
        mainCrop: 'कापूस (Cotton)',
        interCrop: 'मूग किंवा उडीद (Moong / Urad)',
        rowRatio: '१:१ (कापसाच्या दोन ओळींमध्ये १ ओळ मूग)',
        rowVisual: '☁️  🥜  ☁️  🥜  ☁️',
        season: 'खरीप हंगाम (Kharif)',
        potentialGainText: 'एकरी ₹१२,००० ते ₹१६,००० त्वरित रोख उत्पन्न (६० दिवसांत)',
        extraIncomePerAcre: 14000.0,
        spacingGuideline: 'कापूस ओळींमध्ये १२० सेमी अंतर ठेवून मधोमध मूग किंवा उडीद पेरावा.',
        scientificRationale: '१. कापसाची सुरुवातीची वाढ मंद असते; मूग ६०-६५ दिवसांत तयार होऊन शेतकऱ्याला पेरणीनंतर लगेच खतांसाठी खेळते भांडवल मिळवून देतो.\n२. मुगाचे आच्छादन (Green Canopy) जमिनीवर पडल्याने तणांचा प्रादुर्भाव ५०% कमी होतो व ओलावा टिकून राहतो.\n३. मुगाच्या काढणीनंतर त्याचे अवशेष शेतात गाडल्यास उत्तम सेंद्रिय खत तयार होते.',
        managementTip: 'मुगाची काढणी झाल्यावर कापसाला तात्काळ युरिया + पोटॅशचा पहिला डोस देऊन मातीची भर लावावी.',
        isTopRecommended: true,
      ),
      IntercropPlan(
        id: 'sugarcane-onion-1-2',
        name: 'Sugarcane + Onion / Potato',
        nameMr: 'ऊस + कांदा / बटाटा / भाजीपाला',
        mainCrop: 'ऊस (Sugarcane)',
        interCrop: 'कांदा किंवा बटाटा (Onion / Potato)',
        rowRatio: '१:२ (उसाच्या पट्ट्यात २ ओळी कांदा)',
        rowVisual: '🎋  🧅 🧅  🎋  🧅 🧅  🎋',
        season: 'ऑक्टोबर-नोव्हेंबर सुरू / पूर्वहंगामी ऊस',
        potentialGainText: 'एकरी ₹३५,००० ते ₹५०,००० आंतरपीक उत्पन्न (उसाचा उत्पादन खर्च शून्य होतो)',
        extraIncomePerAcre: 42000.0,
        spacingGuideline: 'उसाची ४.५ ते ५ फूट पट्टा पद्धत वापरून मधल्या जागेत कांद्याची पुनर्लागवड किंवा बटाटा लागवड करावी.',
        scientificRationale: '१. ऊस सुरुवातीच्या ३-४ महिन्यांत संपूर्ण जमीन व्यापत नाही, या मोकळ्या जागेचा व खत-पाण्याचा कांद्यासाठी पूर्ण उपयोग होतो.\n२. कांद्याला दिलेली खते व पाणी उसालाही मिळते, ज्यामुळे उसाचे फुटवे (tillering) जोमदार होतात.\n३. कांदा १०० दिवसांत निघून उसाचा वर्षभराचा मजुरी व खतांचा खर्च कांद्याच्या नफ्यातूनच निघून येतो.',
        managementTip: 'कांदा काढणीनंतर उसाला मोठी बाळबांधणी (Earthing up) करून मुख्य खताचा डोस द्यावा.',
        isTopRecommended: true,
      ),
      IntercropPlan(
        id: 'maize-chana-rotation',
        name: 'Maize + Gram (Chana) Rotation',
        nameMr: 'मका ➔ हरभरा (शास्त्रोक्त फेरपालट)',
        mainCrop: 'मका (Maize)',
        interCrop: 'हरभरा (Gram / Chana)',
        rowRatio: 'हंगामी फेरपालट (खरीप मका ➔ रब्बी हरभरा)',
        rowVisual: '🌽 (खरीप)  ➔  🌰 (रब्बी)',
        season: 'खरीप ते रब्बी वार्षिक चक्र',
        potentialGainText: 'जमिनीची सुपीकता पुनर्स्थापित होऊन खताचा खर्च ३०% वाचतो',
        extraIncomePerAcre: 18500.0,
        spacingGuideline: 'खरीप मका निघाल्यावर शून्य मशागत (Zero Till) पद्धतीने थेट ओलाव्यावर हरभरा पेरावा.',
        scientificRationale: 'मका हे अन्नद्रव्ये मोठ्या प्रमाणात शोषणारे तृणधान्य पीक आहे; त्यानंतर हरभऱ्यासारखे द्विदल पीक घेतल्यास जमिनीत सेंद्रिय नत्राचा साठा पूर्ववत होतो आणि रब्बीतील अवशिष्ट ओलाव्याचा १००% उपयोग होतो.',
        managementTip: 'हरभऱ्याला रायझोबियम व पीएसबी जिवाणू संवर्धकाची बीजप्रक्रिया करूनच पेरणी करावी.',
      ),
    ];
  }
}

class CropRotationRule {
  final String seasonSequence;
  final String rationale;
  final String benefitSummary;

  const CropRotationRule({
    required this.seasonSequence,
    required this.rationale,
    required this.benefitSummary,
  });

  static List<CropRotationRule> getRotationRules() {
    return const [
      CropRotationRule(
        seasonSequence: 'खरीप द्विदल (सोयाबीन/मूग) ➔ रब्बी तृणधान्य (गहू/ज्वारी)',
        rationale: 'द्विदल पिकांनंतर तृणधान्य घेतल्यास जमिनीत स्थिर झालेल्या नत्राचा गव्हाला पूर्ण फायदा होतो. कीड व बुरशीची साखळी तुटते.',
        benefitSummary: 'गव्हाच्या उत्पादनात २०% वाढ व युरियाची १ पोती बचत.',
      ),
      CropRotationRule(
        seasonSequence: 'कापूस ➔ उन्हाळी तीळ / मूग ➔ पुढील खरीप सोयाबीन',
        rationale: 'कापसानंतर सलग कापूस न घेता कडधान्य किंवा गळीतधान्य घेतल्यास गुलाबी बोंडअळीचा (Pink Bollworm) प्रादुर्भाव ९०% रोखला जातो.',
        benefitSummary: 'बोंडअळीपासून कायमचे संरक्षण व कीटकनाशक खर्चात मोठी घट.',
      ),
    ];
  }
}
