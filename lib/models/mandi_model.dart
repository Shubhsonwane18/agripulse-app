class MandiCandidate {
  final String id;
  final String name;
  final double distanceKm;
  final double modalPricePerQtl;
  final String? district;
  final String? state;
  final String? yardTier; // APMC Main, Sub-yard, Private

  MandiCandidate({
    required this.id,
    required this.name,
    required this.distanceKm,
    required this.modalPricePerQtl,
    this.district,
    this.state,
    this.yardTier = 'APMC Yard',
  });

  factory MandiCandidate.fromJson(Map<String, dynamic> json) {
    return MandiCandidate(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      distanceKm: (json['distance_km'] ?? json['distanceKm'] ?? 0.0).toDouble(),
      modalPricePerQtl: (json['modal_price_per_qtl'] ?? json['modalPricePerQtl'] ?? 0.0).toDouble(),
      district: json['district']?.toString(),
      state: json['state']?.toString(),
      yardTier: json['yard_tier']?.toString() ?? json['yardTier']?.toString() ?? 'APMC Yard',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'distance_km': distanceKm,
      'modal_price_per_qtl': modalPricePerQtl,
      'district': district,
      'state': state,
      'yard_tier': yardTier,
    };
  }
}

class MandiEvaluation {
  final String mandiId;
  final String mandiName;
  final double distanceKm;
  final double quotedGrossRate;
  final double grossRevenue;
  final double logisticsOverhead;
  final double fuelCost;
  final double handlingFee;
  final double cessFee;
  final double netEarnings;
  final double effectiveNetRate;
  final String? district;
  final String? yardTier;

  MandiEvaluation({
    required this.mandiId,
    required this.mandiName,
    required this.distanceKm,
    required this.quotedGrossRate,
    required this.grossRevenue,
    required this.logisticsOverhead,
    this.fuelCost = 0.0,
    this.handlingFee = 0.0,
    this.cessFee = 0.0,
    required this.netEarnings,
    required this.effectiveNetRate,
    this.district,
    this.yardTier,
  });

  factory MandiEvaluation.fromJson(Map<String, dynamic> json) {
    return MandiEvaluation(
      mandiId: json['mandi_id']?.toString() ?? json['mandiId']?.toString() ?? '',
      mandiName: json['mandi_name']?.toString() ?? json['mandiName']?.toString() ?? '',
      distanceKm: (json['distance_km'] ?? json['distanceKm'] ?? 0.0).toDouble(),
      quotedGrossRate: (json['quoted_gross_rate'] ?? json['quotedGrossRate'] ?? 0.0).toDouble(),
      grossRevenue: (json['gross_revenue'] ?? json['grossRevenue'] ?? 0.0).toDouble(),
      logisticsOverhead: (json['logistics_overhead'] ?? json['logisticsOverhead'] ?? 0.0).toDouble(),
      fuelCost: (json['fuel_cost'] ?? json['fuelCost'] ?? 0.0).toDouble(),
      handlingFee: (json['handling_fee'] ?? json['handlingFee'] ?? 0.0).toDouble(),
      cessFee: (json['cess_fee'] ?? json['cessFee'] ?? 0.0).toDouble(),
      netEarnings: (json['net_earnings'] ?? json['netEarnings'] ?? 0.0).toDouble(),
      effectiveNetRate: (json['effective_net_rate'] ?? json['effectiveNetRate'] ?? 0.0).toDouble(),
      district: json['district']?.toString(),
      yardTier: json['yard_tier']?.toString() ?? json['yardTier']?.toString(),
    );
  }
}

class VehicleOption {
  final String id;
  final String name;
  final String localizedName;
  final double mileageKmPerL;
  final double maxQuintals;

  const VehicleOption({
    required this.id,
    required this.name,
    required this.localizedName,
    required this.mileageKmPerL,
    required this.maxQuintals,
  });

  static const List<VehicleOption> options = [
    VehicleOption(
      id: 'tata_ace',
      name: 'Tata Ace (Chhota Hathi)',
      localizedName: 'टाटा एस (छोटा हाथी)',
      mileageKmPerL: 11.0,
      maxQuintals: 15.0,
    ),
    VehicleOption(
      id: 'pickup_407',
      name: 'Pickup / 407 (Medium)',
      localizedName: 'पिकअप / ४०७',
      mileageKmPerL: 8.5,
      maxQuintals: 30.0,
    ),
    VehicleOption(
      id: 'tractor',
      name: 'Tractor Trolley',
      localizedName: 'ट्रॅक्टर ट्रॉली',
      mileageKmPerL: 5.0,
      maxQuintals: 50.0,
    ),
    VehicleOption(
      id: 'three_wheeler',
      name: 'Three Wheeler / Ape',
      localizedName: 'थ्री-व्हीलर ऑटो टेम्पो',
      mileageKmPerL: 18.0,
      maxQuintals: 8.0,
    ),
  ];
}
