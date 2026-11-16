class VillageRecord {
  final int? villageCode;
  final String villageName;
  final String subDistrictName;
  final String districtName;
  final String stateName;
  final double? latitude;
  final double? longitude;

  VillageRecord({
    this.villageCode,
    required this.villageName,
    required this.subDistrictName,
    required this.districtName,
    required this.stateName,
    this.latitude,
    this.longitude,
  });

  factory VillageRecord.fromJson(Map<String, dynamic> json) {
    return VillageRecord(
      villageCode: json['village_code'] ?? json['villageCode'],
      villageName: json['village_name']?.toString() ?? json['villageName']?.toString() ?? '',
      subDistrictName: json['subdistrict_name']?.toString() ?? json['subDistrictName']?.toString() ?? '',
      districtName: json['district_name']?.toString() ?? json['districtName']?.toString() ?? '',
      stateName: json['state_name']?.toString() ?? json['stateName']?.toString() ?? 'Maharashtra',
      latitude: json['latitude'] != null ? (json['latitude']).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude']).toDouble() : null,
    );
  }
}
