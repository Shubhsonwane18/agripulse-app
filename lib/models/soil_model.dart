class SoilTestInput {
  final double nitrogen; // kg/ha
  final double phosphorus; // kg/ha
  final double potassium; // kg/ha
  final double ph;
  final double electricalConductivity; // dS/m
  final double organicCarbon; // %
  final String targetCrop;
  final double acreage;

  SoilTestInput({
    this.nitrogen = 240.0,
    this.phosphorus = 18.0,
    this.potassium = 280.0,
    this.ph = 7.2,
    this.electricalConductivity = 0.45,
    this.organicCarbon = 0.65,
    this.targetCrop = 'Soybean',
    this.acreage = 2.0,
  });
}

class SoilAdvisoryResult {
  final String soilHealthStatus;
  final String cropSuitability;
  final double ureaBags;
  final double dapBags;
  final double mopBags;
  final String advisoryText;
  final List<String> warnings;

  SoilAdvisoryResult({
    required this.soilHealthStatus,
    required this.cropSuitability,
    required this.ureaBags,
    required this.dapBags,
    required this.mopBags,
    required this.advisoryText,
    required this.warnings,
  });

  factory SoilAdvisoryResult.calculate(SoilTestInput input) {
    double urea = 0.0;
    double dap = 0.0;
    double mop = 0.0;
    List<String> notes = [];

    if (input.nitrogen < 280) {
      urea = (280 - input.nitrogen) * 0.15 * input.acreage;
      notes.add('Low Soil Nitrogen: Apply split doses of Urea at vegetative stages.');
    }

    if (input.phosphorus < 23) {
      dap = (23 - input.phosphorus) * 0.35 * input.acreage;
      notes.add('Phosphorus deficit: Apply DAP at sowing time as basal dose.');
    }

    if (input.potassium < 200) {
      mop = (200 - input.potassium) * 0.20 * input.acreage;
      notes.add('Potassium replenishment needed for grain filling stage.');
    }

    String healthStatus = 'Medium Fertility';
    if (input.nitrogen >= 280 && input.phosphorus >= 23 && input.potassium >= 250) {
      healthStatus = 'Optimal Healthy Soil';
    } else if (input.nitrogen < 200 || input.phosphorus < 15) {
      healthStatus = 'Nutrient Deficient';
    }

    return SoilAdvisoryResult(
      soilHealthStatus: healthStatus,
      cropSuitability: 'सोयाबीन, कडधान्ये व तेलबिया पिकांसाठी उच्च सुपीकता (High suitability for Soybean, Pulses & Oilseeds)',
      ureaBags: (urea / 50.0).clamp(0.5, 10.0),
      dapBags: (dap / 50.0).clamp(0.5, 8.0),
      mopBags: (mop / 50.0).clamp(0.25, 6.0),
      advisoryText: 'Recommended basal and top-dressing dosage per ICAR & Dr. PDKV university norms.',
      warnings: notes,
    );
  }
}

class SuitableCropItem {
  final String cropName;
  final String icon;
  final String season;
  final String yieldPotential;
  final String reason;

  const SuitableCropItem({
    required this.cropName,
    required this.icon,
    required this.season,
    required this.yieldPotential,
    required this.reason,
  });
}

class GeoSoilProfile {
  final String soilTypeName;
  final String soilTypeEnglish;
  final String locationTag;
  final double ph;
  final String organicCarbon;
  final String waterRetention;
  final String texture;
  final String drainage;
  final List<SuitableCropItem> suitableCrops;
  final String managementTip;
  final String fertilizerPrescription;

  const GeoSoilProfile({
    required this.soilTypeName,
    required this.soilTypeEnglish,
    required this.locationTag,
    required this.ph,
    required this.organicCarbon,
    required this.waterRetention,
    required this.texture,
    required this.drainage,
    required this.suitableCrops,
    required this.managementTip,
    required this.fertilizerPrescription,
  });

  factory GeoSoilProfile.detectFromLocation({
    double? lat,
    double? lon,
    String? district,
    String? village,
  }) {
    final dist = (district ?? '').toLowerCase();
    final vill = (village ?? 'Shirol');

    // 1. Konkan / Western Ghats -> Red Laterite Soil
    if (dist.contains('ratnagiri') || dist.contains('sindhudurg') || dist.contains('raigad')) {
      return GeoSoilProfile(
        soilTypeName: 'जांभ्या तांबडी माती (Red Laterite Soil)',
        soilTypeEnglish: 'Lateritic Sandy Clay Soil',
        locationTag: '$vill, $dist (कोकण / पश्चिम घाट)',
        ph: 6.2,
        organicCarbon: '0.85% (उच्च)',
        waterRetention: 'मध्यम (द्रुत निचरा)',
        texture: 'तांबडी रेतीयुक्त चिकनमाती',
        drainage: 'अतिशय जलद निचरा',
        suitableCrops: const [
          SuitableCropItem(cropName: 'काजू (Cashew)', icon: '🥜', season: 'बारमाही', yieldPotential: 'उत्कृष्ट (High)', reason: 'जांभ्या खडकातील निचरा काजूसाठी अत्यंत योग्य.'),
          SuitableCropItem(cropName: 'भात (Paddy)', icon: '🌾', season: 'खरीप', yieldPotential: 'उत्तम', reason: 'भरपूर पाऊस व आम्लधर्मी मातीत चांगले पोषण.'),
          SuitableCropItem(cropName: 'आंबा (Hapus Mango)', icon: '🥭', season: 'बारमाही', yieldPotential: 'अति-उत्कृष्ट', reason: 'कोकणातील प्रसिद्ध हापूस आंब्यासाठी आदर्श.'),
          SuitableCropItem(cropName: 'सुपारी व नारळ (Coconut)', icon: '🌴', season: 'बारमाही', yieldPotential: 'उत्तम', reason: 'मुबलक सेंद्रिय कर्ब व दमट हवामान.'),
        ],
        managementTip: 'माती आम्लधर्मी असल्याने दर ३ वर्षांनी एकरी २५० किलो कृषी चुना (Agricultural Lime) वापरावा.',
        fertilizerPrescription: 'फॉस्फरस व पोटॅशयुक्त खतांचा वापर वाढवावा (DAP + MOP + सेंद्रिय खते).',
      );
    }

    // 2. Marathwada / Latur / Nanded / Beed -> Medium to Deep Black Calcareous
    if (dist.contains('latur') || dist.contains('nanded') || dist.contains('beed') || dist.contains('jalna') || dist.contains('parbhani')) {
      return GeoSoilProfile(
        soilTypeName: 'मध्यम काळी कसदार माती (Medium Black Soil)',
        soilTypeEnglish: 'Medium Black Vertisol',
        locationTag: '$vill, $dist (मराठवाडा विभाग)',
        ph: 7.9,
        organicCarbon: '0.55% (मध्यम)',
        waterRetention: 'उत्कृष्ट (ओलावा टिकवणारी)',
        texture: 'काळी कसदार चिकनमाती',
        drainage: 'मध्यम',
        suitableCrops: const [
          SuitableCropItem(cropName: 'सोयाबीन (Soybean)', icon: '🌱', season: 'खरीप', yieldPotential: 'उत्कृष्ट (१०-१२ क्विंटल/एकर)', reason: 'काळी माती ओलावा धरून ठेवते, मुळांची गाठ निर्मिती उत्तम होते.'),
          SuitableCropItem(cropName: 'तूर (Pigeon Pea / Arhar)', icon: '🌾', season: 'खरीप/वार्षिक', yieldPotential: 'उत्कृष्ट (८-१० क्विंटल)', reason: 'खोल मुळे काळ्या मातीतील खोल ओलावा शोषून घेतात.'),
          SuitableCropItem(cropName: 'हरभरा (Gram / Chana)', icon: '🌰', season: 'रब्बी', yieldPotential: 'अति-उत्कृष्ट', reason: 'रब्बीतील थंडी व अवशिष्ट ओलाव्यावर भारी उत्पादन.'),
          SuitableCropItem(cropName: 'कापूस (Cotton)', icon: '☁️', season: 'खरीप', yieldPotential: 'उत्तम', reason: 'काळ्या जमिनीत बोंडांचे वजन व धाग्याची गुणवत्ता वाढते.'),
        ],
        managementTip: 'मातीतील ओलावा टिकवण्यासाठी सेंद्रिय आच्छादन (Mulching) करा व शेणखताचा नियमित वापर करा.',
        fertilizerPrescription: 'युरिया: २ पोती, DAP: १.५ पोते, सल्फर: १० किलो प्रति एकर शिफारस.',
      );
    }

    // 3. Western Maharashtra / Krishna Valley (Kolhapur, Sangli, Satara, Pune, Shirol) -> Deep Black Cotton Soil (Regur)
    return GeoSoilProfile(
      soilTypeName: 'काळी कसदार रेगूर माती (Deep Black Cotton Soil)',
      soilTypeEnglish: 'Deep Krishna River Basin Vertisol',
      locationTag: '$vill, ${dist.isNotEmpty ? dist : "कोल्हापूर"} (कृष्णा खोरे)',
      ph: 7.8,
      organicCarbon: '0.72% (उत्कृष्ट)',
      waterRetention: 'अति-उत्कृष्ट (७५% क्षमता)',
      texture: 'सुपीक काळी पोयटा चिकनमाती',
      drainage: 'मध्यम ते मंद',
      suitableCrops: const [
        SuitableCropItem(cropName: 'सोयाबीन (Soybean)', icon: '🌱', season: 'खरीप', yieldPotential: '१२-१५ क्विंटल/एकर', reason: 'कृष्णा खोऱ्यातील सुपीक काळ्या जमिनीत दाणे भरण्याची क्षमता सर्वोच्च.'),
        SuitableCropItem(cropName: 'ऊस (Sugarcane)', icon: '🎋', season: 'अडसाली/सुरू', yieldPotential: '८०-१०० टन/एकर', reason: 'ओलावा व खते टिकवून ठेवण्याची सर्वोच्च क्षमता, भरपूर साखर उतारा.'),
        SuitableCropItem(cropName: 'हळद व आले (Turmeric)', icon: '🥔', season: 'खरीप-वार्षिक', yieldPotential: '२५-३० क्विंटल (सुकी हळद)', reason: 'सांगली-कोल्हापूर पट्ट्यातील काळी कसदार माती हळदीसाठी जगप्रसिद्ध.'),
        SuitableCropItem(cropName: 'कापूस (Cotton)', icon: '☁️', season: 'खरीप', yieldPotential: '१२-१५ क्विंटल', reason: 'नैसर्गिक रेगूर मातीत कापसाचे पोषण सर्वोत्तम होते.'),
        SuitableCropItem(cropName: 'टोमॅटो व भाजीपाला', icon: '🍅', season: 'सर्व ऋतू', yieldPotential: 'उत्तम', reason: 'मुबलक पोटॅशियम व मॅग्नेशियममुळे फळांना चकाकी.'),
      ],
      managementTip: 'पाण्याचा योग्य निचरा ठेवा. ठिबक सिंचनाने पाणी दिल्यास दलदल न होता पिकांची जोमदार वाढ होते.',
      fertilizerPrescription: 'ऊस: युरिया ४ पोती, DAP २ पोती, MOP २ पोती. सोयाबीन: DAP १.५ पोते + सल्फर १० किलो/एकर.',
    );
  }
}
