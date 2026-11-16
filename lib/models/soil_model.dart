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
  final String soilHealthStatus; // Optimal, Deficient, Alkaline, Acidic
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
    // Standard ICAR agronomic formulation
    double urea = 0.0;
    double dap = 0.0;
    double mop = 0.0;
    List<String> notes = [];

    // N deficiency check (<280 kg/ha is low)
    if (input.nitrogen < 280) {
      urea = (280 - input.nitrogen) * 0.15 * input.acreage;
      notes.add('Low Soil Nitrogen: Apply split doses of Urea at vegetative stages.');
    }

    // P deficiency check (<23 kg/ha is medium/low)
    if (input.phosphorus < 23) {
      dap = (23 - input.phosphorus) * 0.35 * input.acreage;
      notes.add('Phosphorus deficit: Apply DAP at sowing time as basal dose.');
    }

    // K deficiency check (<140 kg/ha is low)
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
      cropSuitability: 'High suitability for ${input.targetCrop}, Pulses, and Oilseeds',
      ureaBags: (urea / 50.0).clamp(0.5, 10.0),
      dapBags: (dap / 50.0).clamp(0.5, 8.0),
      mopBags: (mop / 50.0).clamp(0.25, 6.0),
      advisoryText: 'Recommended basal and top-dressing dosage per ICAR & Dr. PDKV university norms.',
      warnings: notes,
    );
  }
}
