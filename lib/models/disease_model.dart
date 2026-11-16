class ChemicalPrescription {
  final String chemicalName;
  final String? tradeNames;
  final String dosagePerAcre;
  final String waterVolumeLiters;
  final int waitingPeriodDays;

  ChemicalPrescription({
    required this.chemicalName,
    this.tradeNames,
    required this.dosagePerAcre,
    required this.waterVolumeLiters,
    required this.waitingPeriodDays,
  });

  factory ChemicalPrescription.fromJson(Map<String, dynamic> json) {
    return ChemicalPrescription(
      chemicalName: json['chemical_name']?.toString() ?? json['chemicalName']?.toString() ?? '',
      tradeNames: json['trade_names']?.toString() ?? json['tradeNames']?.toString(),
      dosagePerAcre: json['dosage_per_acre']?.toString() ?? json['dosagePerAcre']?.toString() ?? '',
      waterVolumeLiters: json['water_volume_liters']?.toString() ?? json['waterVolumeLiters']?.toString() ?? '200 L',
      waitingPeriodDays: (json['waiting_period_days'] ?? json['waitingPeriodDays'] ?? 7).toInt(),
    );
  }
}

class CropPathologyResult {
  final String cropName;
  final String diseaseName;
  final double confidence;
  final String severity; // Mild, Moderate, Severe
  final List<String> symptoms;
  final List<ChemicalPrescription> chemicalPrescriptions;
  final List<String> biologicalAlternatives;
  final bool safeToSpray;
  final String? sprayLockoutReason;

  CropPathologyResult({
    required this.cropName,
    required this.diseaseName,
    required this.confidence,
    required this.severity,
    required this.symptoms,
    required this.chemicalPrescriptions,
    required this.biologicalAlternatives,
    required this.safeToSpray,
    this.sprayLockoutReason,
  });

  factory CropPathologyResult.fromJson(Map<String, dynamic> json) {
    var rawPrescriptions = (json['chemical_prescriptions'] ?? json['chemicalPrescriptions'] ?? []) as List;
    var rawSymptoms = (json['symptoms'] ?? []) as List;
    var rawBio = (json['biological_alternatives'] ?? json['biologicalAlternatives'] ?? []) as List;

    return CropPathologyResult(
      cropName: json['crop_name']?.toString() ?? json['cropName']?.toString() ?? 'Crop Leaf',
      diseaseName: json['disease_name']?.toString() ?? json['diseaseName']?.toString() ?? 'Healthy Leaf',
      confidence: (json['confidence'] ?? 0.95).toDouble(),
      severity: json['severity']?.toString() ?? 'Moderate',
      symptoms: rawSymptoms.map((e) => e.toString()).toList(),
      chemicalPrescriptions: rawPrescriptions
          .map((e) => ChemicalPrescription.fromJson(e as Map<String, dynamic>))
          .toList(),
      biologicalAlternatives: rawBio.map((e) => e.toString()).toList(),
      safeToSpray: json['safe_to_spray'] == true || json['safeToSpray'] == true,
      sprayLockoutReason: json['spray_lockout_reason']?.toString(),
    );
  }
}
