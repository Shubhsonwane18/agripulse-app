class UserProfile {
  final String id;
  final String fullName;
  final String? phone;
  final String? email;
  final String language; // 'en' | 'mr' | 'hi' | 'te' | 'kn' | 'gu'
  final String? state;
  final String? district;
  final String? village;
  final double landSizeAcres;
  final double latitude;
  final double longitude;
  final bool isDemo;
  final List<String> preferredCrops;
  final bool hasCompletedOnboarding;

  UserProfile({
    required this.id,
    required this.fullName,
    this.phone,
    this.email,
    this.language = 'mr',
    this.state,
    this.district,
    this.village,
    this.landSizeAcres = 4.5,
    this.latitude = 16.7050,
    this.longitude = 74.2433,
    this.isDemo = false,
    this.preferredCrops = const ['Soybean', 'Cotton'],
    this.hasCompletedOnboarding = false,
  });

  // Default Demo Farmer Profile
  factory UserProfile.defaultDemo() {
    return UserProfile(
      id: 'demo-farmer-id-789',
      fullName: 'Ramesh Patil (शेतकरी)',
      phone: '+91 98220 12345',
      email: 'ramesh.patil@agripulse.demo',
      language: 'mr',
      state: 'Maharashtra',
      district: 'Kolhapur',
      village: 'Shirol',
      landSizeAcres: 4.5,
      latitude: 16.7050,
      longitude: 74.2433,
      isDemo: true,
      preferredCrops: const ['Soybean', 'Cotton', 'Sugarcane'],
      hasCompletedOnboarding: false,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    List<String> crops = const ['Soybean', 'Cotton'];
    if (json['preferred_crops'] is List) {
      crops = (json['preferred_crops'] as List).map((e) => e.toString()).toList();
    } else if (json['preferredCrops'] is List) {
      crops = (json['preferredCrops'] as List).map((e) => e.toString()).toList();
    }

    return UserProfile(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? json['fullName']?.toString() ?? '',
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      language: json['language']?.toString() ?? 'mr',
      state: json['state']?.toString(),
      district: json['district']?.toString(),
      village: json['village']?.toString(),
      landSizeAcres: (json['land_size_acres'] ?? json['landSizeAcres'] ?? 4.5).toDouble(),
      latitude: (json['latitude'] ?? 16.7050).toDouble(),
      longitude: (json['longitude'] ?? 74.2433).toDouble(),
      isDemo: json['is_demo'] == true || json['isDemo'] == true,
      preferredCrops: crops,
      hasCompletedOnboarding: json['has_completed_onboarding'] == true || json['hasCompletedOnboarding'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'language': language,
      'state': state,
      'district': district,
      'village': village,
      'land_size_acres': landSizeAcres,
      'latitude': latitude,
      'longitude': longitude,
      'is_demo': isDemo,
      'preferred_crops': preferredCrops,
      'has_completed_onboarding': hasCompletedOnboarding,
    };
  }

  UserProfile copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? language,
    String? state,
    String? district,
    String? village,
    double? landSizeAcres,
    double? latitude,
    double? longitude,
    bool? isDemo,
    List<String>? preferredCrops,
    bool? hasCompletedOnboarding,
  }) {
    return UserProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      language: language ?? this.language,
      state: state ?? this.state,
      district: district ?? this.district,
      village: village ?? this.village,
      landSizeAcres: landSizeAcres ?? this.landSizeAcres,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDemo: isDemo ?? this.isDemo,
      preferredCrops: preferredCrops ?? this.preferredCrops,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}
