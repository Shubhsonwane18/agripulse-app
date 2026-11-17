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
  final String cropSuitabilityEn;
  final double ureaBags;
  final double dapBags;
  final double mopBags;
  final String advisoryText;
  final List<String> warnings;

  SoilAdvisoryResult({
    required this.soilHealthStatus,
    required this.cropSuitability,
    this.cropSuitabilityEn = '',
    required this.ureaBags,
    required this.dapBags,
    required this.mopBags,
    required this.advisoryText,
    required this.warnings,
  });

  String getSuitability(bool isEn) => isEn ? (cropSuitabilityEn.isNotEmpty ? cropSuitabilityEn : cropSuitability) : cropSuitability;

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
      cropSuitability: 'सोयाबीन, कडधान्ये व तेलबिया पिकांसाठी उच्च सुपीकता',
      cropSuitabilityEn: 'High fertility for Soybean, Pulses & Oilseeds crops',
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
  final String cropNameEn;
  final String icon;
  final String season;
  final String seasonEn;
  final String yieldPotential;
  final String yieldPotentialEn;
  final String reason;
  final String reasonEn;

  const SuitableCropItem({
    required this.cropName,
    this.cropNameEn = '',
    required this.icon,
    required this.season,
    this.seasonEn = '',
    required this.yieldPotential,
    this.yieldPotentialEn = '',
    required this.reason,
    this.reasonEn = '',
  });

  String getName(bool isEn) => isEn && cropNameEn.isNotEmpty ? cropNameEn : cropName;
  String getSeason(bool isEn) => isEn && seasonEn.isNotEmpty ? seasonEn : season;
  String getYield(bool isEn) => isEn && yieldPotentialEn.isNotEmpty ? yieldPotentialEn : yieldPotential;
  String getReason(bool isEn) => isEn && reasonEn.isNotEmpty ? reasonEn : reason;
}

class GeoSoilProfile {
  final String soilTypeName;
  final String soilTypeEnglish;
  final String locationTag;
  final String locationTagEn;
  final double ph;
  final String organicCarbon;
  final String organicCarbonEn;
  final String waterRetention;
  final String waterRetentionEn;
  final String texture;
  final String textureEn;
  final String drainage;
  final String drainageEn;
  final List<SuitableCropItem> suitableCrops;
  final String managementTip;
  final String managementTipEn;
  final String fertilizerPrescription;
  final String fertilizerPrescriptionEn;

  const GeoSoilProfile({
    required this.soilTypeName,
    required this.soilTypeEnglish,
    required this.locationTag,
    this.locationTagEn = '',
    required this.ph,
    required this.organicCarbon,
    this.organicCarbonEn = '',
    required this.waterRetention,
    this.waterRetentionEn = '',
    required this.texture,
    this.textureEn = '',
    required this.drainage,
    this.drainageEn = '',
    required this.suitableCrops,
    required this.managementTip,
    this.managementTipEn = '',
    required this.fertilizerPrescription,
    this.fertilizerPrescriptionEn = '',
  });

  String getSoilName(bool isEn) => isEn ? soilTypeEnglish : soilTypeName;
  String getLocation(bool isEn) => isEn && locationTagEn.isNotEmpty ? locationTagEn : locationTag;
  String getOrganicCarbon(bool isEn) => isEn && organicCarbonEn.isNotEmpty ? organicCarbonEn : organicCarbon;
  String getWaterRetention(bool isEn) => isEn && waterRetentionEn.isNotEmpty ? waterRetentionEn : waterRetention;
  String getTexture(bool isEn) => isEn && textureEn.isNotEmpty ? textureEn : texture;
  String getDrainage(bool isEn) => isEn && drainageEn.isNotEmpty ? drainageEn : drainage;
  String getTip(bool isEn) => isEn && managementTipEn.isNotEmpty ? managementTipEn : managementTip;
  String getFertilizer(bool isEn) => isEn && fertilizerPrescriptionEn.isNotEmpty ? fertilizerPrescriptionEn : fertilizerPrescription;

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
        locationTagEn: '$vill, $dist (Konkan / Western Ghats)',
        ph: 6.2,
        organicCarbon: '0.85% (उच्च)',
        organicCarbonEn: '0.85% (High)',
        waterRetention: 'मध्यम (द्रुत निचरा)',
        waterRetentionEn: 'Moderate (Rapid Drainage)',
        texture: 'तांबडी रेतीयुक्त चिकनमाती',
        textureEn: 'Reddish Sandy Clay Loam',
        drainage: 'अतिशय जलद निचरा',
        drainageEn: 'Rapid Drainage',
        suitableCrops: const [
          SuitableCropItem(cropName: 'काजू (Cashew)', cropNameEn: 'Cashew Nut', icon: '🥜', season: 'बारमाही', seasonEn: 'Perennial', yieldPotential: 'उत्कृष्ट (High)', yieldPotentialEn: 'High Yield', reason: 'जांभ्या खडकातील निचरा काजूसाठी अत्यंत योग्य.', reasonEn: 'Lateritic gravel provides ideal aeration and drainage for cashew roots.'),
          SuitableCropItem(cropName: 'भात (Paddy)', cropNameEn: 'Paddy / Rice', icon: '🌾', season: 'खरीप', seasonEn: 'Kharif', yieldPotential: 'उत्तम', yieldPotentialEn: 'Good', reason: 'भरपूर पाऊस व आम्लधर्मी मातीत चांगले पोषण.', reasonEn: 'Thrives in heavy rainfall and slightly acidic laterite soil.'),
          SuitableCropItem(cropName: 'आंबा (Hapus Mango)', cropNameEn: 'Alphonso Mango', icon: '🥭', season: 'बारमाही', seasonEn: 'Perennial', yieldPotential: 'अति-उत्कृष्ट', yieldPotentialEn: 'Outstanding', reason: 'कोकणातील प्रसिद्ध हापूस आंब्यासाठी आदर्श.', reasonEn: 'World-famous Konkan Alphonso climate and soil affinity.'),
          SuitableCropItem(cropName: 'सुपारी व नारळ (Coconut)', cropNameEn: 'Arecanut & Coconut', icon: '🌴', season: 'बारमाही', seasonEn: 'Perennial', yieldPotential: 'उत्तम', yieldPotentialEn: 'Excellent', reason: 'मुबलक सेंद्रिय कर्ब व दमट हवामान.', reasonEn: 'Rich organic carbon and coastal humid climate.'),
        ],
        managementTip: 'माती आम्लधर्मी असल्याने दर ३ वर्षांनी एकरी २५० किलो कृषी चुना (Agricultural Lime) वापरावा.',
        managementTipEn: 'Soil is acidic: Apply 250 kg/acre Agricultural Lime every 3 years to balance pH.',
        fertilizerPrescription: 'फॉस्फरस व पोटॅशयुक्त खतांचा वापर वाढवावा (DAP + MOP + सेंद्रिय खते).',
        fertilizerPrescriptionEn: 'Increase Phosphorus and Potash fertilizers (DAP + MOP + Farmyard Manure).',
      );
    }

    // 2. Marathwada / Latur / Nanded / Beed -> Medium to Deep Black Calcareous
    if (dist.contains('latur') || dist.contains('nanded') || dist.contains('beed') || dist.contains('jalna') || dist.contains('parbhani')) {
      return GeoSoilProfile(
        soilTypeName: 'मध्यम काळी कसदार माती (Medium Black Soil)',
        soilTypeEnglish: 'Medium Black Vertisol',
        locationTag: '$vill, $dist (मराठवाडा विभाग)',
        locationTagEn: '$vill, $dist (Marathwada Division)',
        ph: 7.9,
        organicCarbon: '0.55% (मध्यम)',
        organicCarbonEn: '0.55% (Medium)',
        waterRetention: 'उत्कृष्ट (ओलावा टिकवणारी)',
        waterRetentionEn: 'High Moisture Retention',
        texture: 'काळी कसदार चिकनमाती',
        textureEn: 'Black Clay Loam',
        drainage: 'मध्यम',
        drainageEn: 'Moderate',
        suitableCrops: const [
          SuitableCropItem(cropName: 'सोयाबीन (Soybean)', cropNameEn: 'Soybean', icon: '🌱', season: 'खरीप', seasonEn: 'Kharif', yieldPotential: 'उत्कृष्ट (१०-१२ क्विंटल/एकर)', yieldPotentialEn: '10-12 Qtl/Acre', reason: 'काळी माती ओलावा धरून ठेवते, मुळांची गाठ निर्मिती उत्तम होते.', reasonEn: 'Moisture retention promotes strong rhizobium root nodulation.'),
          SuitableCropItem(cropName: 'तूर (Pigeon Pea / Arhar)', cropNameEn: 'Pigeon Pea (Tur)', icon: '🌾', season: 'खरीप/वार्षिक', seasonEn: 'Kharif', yieldPotential: 'उत्कृष्ट (८-१० क्विंटल)', yieldPotentialEn: '8-10 Qtl/Acre', reason: 'खोल मुळे काळ्या मातीतील खोल ओलावा शोषून घेतात.', reasonEn: 'Deep taproots extract residual soil moisture during dry spells.'),
          SuitableCropItem(cropName: 'हरभरा (Gram / Chana)', cropNameEn: 'Bengal Gram (Chana)', icon: '🌰', season: 'रब्बी', seasonEn: 'Rabi', yieldPotential: 'अति-उत्कृष्ट', yieldPotentialEn: 'High Yield', reason: 'रब्बीतील थंडी व अवशिष्ट ओलाव्यावर भारी उत्पादन.', reasonEn: 'Outstanding performance on winter residual moisture.'),
          SuitableCropItem(cropName: 'कापूस (Cotton)', cropNameEn: 'Cotton', icon: '☁️', season: 'खरीप', seasonEn: 'Kharif', yieldPotential: 'उत्तम', yieldPotentialEn: 'Good', reason: 'काळ्या जमिनीत बोंडांचे वजन व धाग्याची गुणवत्ता वाढते.', reasonEn: 'Enhances boll weight and lint staple length.'),
        ],
        managementTip: 'मातीतील ओलावा टिकवण्यासाठी सेंद्रिय आच्छादन (Mulching) करा व शेणखताचा नियमित वापर करा.',
        managementTipEn: 'Practice organic mulching and apply farmyard manure to preserve soil moisture.',
        fertilizerPrescription: 'युरिया: २ पोती, DAP: १.५ पोते, सल्फर: १० किलो प्रति एकर शिफारस.',
        fertilizerPrescriptionEn: 'Urea: 2 bags, DAP: 1.5 bags, Sulphur: 10 kg/acre recommended.',
      );
    }

    // 3. Western Maharashtra / Krishna Valley (Kolhapur, Sangli, Satara, Pune, Shirol) -> Deep Black Cotton Soil (Regur)
    final isKolhapur = dist.contains('kolhapur') || dist.contains('कोल्हापूर') || dist.isEmpty;
    final villMr = (vill.toLowerCase() == 'shirol' || vill == 'शिरोळ') ? 'शिरोळ' : vill;
    final villEn = (vill.toLowerCase() == 'shirol' || vill == 'शिरोळ') ? 'Shirol' : vill;
    final distMr = isKolhapur ? 'कोल्हापूर' : district ?? 'कोल्हापूर';
    final distEn = isKolhapur ? 'Kolhapur' : district ?? 'Kolhapur';

    return GeoSoilProfile(
      soilTypeName: 'काळी कसदार रेगूर माती (Deep Black Cotton Soil)',
      soilTypeEnglish: 'Deep Krishna Basin Vertisol (Regur Soil)',
      locationTag: '$villMr, $distMr (कृष्णा खोरे)',
      locationTagEn: '$villEn, $distEn (Krishna Valley)',
      ph: 7.8,
      organicCarbon: '0.72% (उत्कृष्ट)',
      organicCarbonEn: '0.72% (Optimal High)',
      waterRetention: 'अति-उत्कृष्ट (७५% क्षमता)',
      waterRetentionEn: 'Exceptional (75% Capacity)',
      texture: 'सुपीक काळी पोयटा चिकनमाती',
      textureEn: 'Fertile Black Clayey Silt Loam',
      drainage: 'मध्यम ते मंद',
      drainageEn: 'Moderate to Slow',
      suitableCrops: const [
        SuitableCropItem(cropName: 'सोयाबीन (Soybean)', cropNameEn: 'Soybean', icon: '🌱', season: 'खरीप', seasonEn: 'Kharif', yieldPotential: '१२-१५ क्विंटल/एकर', yieldPotentialEn: '12-15 Qtl/Acre', reason: 'कृष्णा खोऱ्यातील सुपीक काळ्या जमिनीत दाणे भरण्याची क्षमता सर्वोच्च.', reasonEn: 'Highest pod-filling and grain density in nutrient-rich Vertisols.'),
        SuitableCropItem(cropName: 'ऊस (Sugarcane)', cropNameEn: 'Sugarcane', icon: '🎋', season: 'अडसाली/सुरू', seasonEn: 'Annual / Adsali', yieldPotential: '८०-१०० टन/एकर', yieldPotentialEn: '80-100 Tons/Acre', reason: 'ओलावा व खते टिकवून ठेवण्याची सर्वोच्च क्षमता, भरपूर साखर उतारा.', reasonEn: 'Max water-holding capacity delivers superior cane weight & sugar recovery.'),
        SuitableCropItem(cropName: 'हळद व आले (Turmeric)', cropNameEn: 'Turmeric & Ginger', icon: '🥔', season: 'खरीप-वार्षिक', seasonEn: 'Kharif-Annual', yieldPotential: '२५-३० क्विंटल', yieldPotentialEn: '25-30 Qtl/Acre', reason: 'सांगली-कोल्हापूर पट्ट्यातील काळी कसदार माती हळदीसाठी जगप्रसिद्ध.', reasonEn: 'World-renowned Kolhapur-Sangli turmeric belt with high curcumin yield.'),
        SuitableCropItem(cropName: 'कापूस (Cotton)', cropNameEn: 'Cotton', icon: '☁️', season: 'खरीप', seasonEn: 'Kharif', yieldPotential: '१२-१५ क्विंटल', yieldPotentialEn: '12-15 Qtl/Acre', reason: 'नैसर्गिक रेगूर मातीत कापसाचे पोषण सर्वोत्तम होते.', reasonEn: 'Deep black soil provides sustained nutrition throughout boll formation.'),
        SuitableCropItem(cropName: 'टोमॅटो व भाजीपाला', cropNameEn: 'Tomato & Vegetables', icon: '🍅', season: 'सर्व ऋतू', seasonEn: 'All Seasons', yieldPotential: 'उत्तम', yieldPotentialEn: 'High Yield', reason: 'मुबलक पोटॅशियम व मॅग्नेशियममुळे फळांना चकाकी.', reasonEn: 'Abundant potassium and magnesium promote fruit firmness and luster.'),
      ],
      managementTip: 'पाण्याचा योग्य निचरा ठेवा. ठिबक सिंचनाने पाणी दिल्यास दलदल न होता पिकांची जोमदार वाढ होते.',
      managementTipEn: 'Ensure proper drainage. Use drip irrigation to prevent waterlogging and foster root aeration.',
      fertilizerPrescription: 'ऊस: युरिया ४ पोती, DAP २ पोती, MOP २ पोती. सोयाबीन: DAP १.५ पोते + सल्फर १० किलो/एकर.',
      fertilizerPrescriptionEn: 'Sugarcane: Urea 4 bags, DAP 2 bags, MOP 2 bags. Soybean: DAP 1.5 bags + Sulphur 10 kg/acre.',
    );
  }
}
