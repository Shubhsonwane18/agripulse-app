class AppLanguage {
  final String code;
  final String nativeName;
  final String englishName;
  final String region;
  final String greeting;
  final String icon;

  const AppLanguage({
    required this.code,
    required this.nativeName,
    required this.englishName,
    required this.region,
    required this.greeting,
    required this.icon,
  });
}

class SupportedLanguages {
  static const List<AppLanguage> all = [
    AppLanguage(
      code: 'mr',
      nativeName: 'मराठी',
      englishName: 'Marathi',
      region: 'महाराष्ट्र (Maharashtra)',
      greeting: 'नमस्कार शेतकरी मित्र',
      icon: '🚩',
    ),
    AppLanguage(
      code: 'hi',
      nativeName: 'हिन्दी',
      englishName: 'Hindi',
      region: 'उत्तर व मध्य भारत (UP, MP, Bihar, Raj.)',
      greeting: 'नमस्ते किसान भाई',
      icon: '🇮🇳',
    ),
    AppLanguage(
      code: 'te',
      nativeName: 'తెలుగు',
      englishName: 'Telugu',
      region: 'ఆంధ్రప్రదేశ్ & తెలంగాణ (AP & Telangana)',
      greeting: 'నమస్కారం రైతు సోదరులారా',
      icon: '🌱',
    ),
    AppLanguage(
      code: 'kn',
      nativeName: 'ಕನ್ನಡ',
      englishName: 'Kannada',
      region: 'ಕರ್ನಾಟಕ (Karnataka)',
      greeting: 'ನಮಸ್ಕಾರ ರೈತ ಬಾಂಧವರೇ',
      icon: '🌿',
    ),
    AppLanguage(
      code: 'ta',
      nativeName: 'தமிழ்',
      englishName: 'Tamil',
      region: 'தமிழ்நாடு (Tamil Nadu)',
      greeting: 'வணக்கம் விவசாய பெருமக்களே',
      icon: '🌾',
    ),
    AppLanguage(
      code: 'gu',
      nativeName: 'ગુજરાતી',
      englishName: 'Gujarati',
      region: 'ગુજરાત (Gujarat)',
      greeting: 'નમસ્તે ખેડૂત મિત્રો',
      icon: '🌻',
    ),
    AppLanguage(
      code: 'pa',
      nativeName: 'ਪੰਜਾਬੀ',
      englishName: 'Punjabi',
      region: 'ਪੰਜਾਬ ও ਹਰਿਆਣਾ (Punjab & Haryana)',
      greeting: 'ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ ਕਿਸਾਨ ਵੀਰੋ',
      icon: '🌾',
    ),
    AppLanguage(
      code: 'bn',
      nativeName: 'বাংলা',
      englishName: 'Bengali',
      region: 'পশ্চিমবঙ্গ (West Bengal)',
      greeting: 'নমস্কার কৃষক ভাই ও বোনেরা',
      icon: '🌾',
    ),
    AppLanguage(
      code: 'or',
      nativeName: 'ଓଡ଼ିଆ',
      englishName: 'Odia',
      region: 'ଓଡ଼ିଶା (Odisha)',
      greeting: 'ନମସ୍କାର କୃଷକ ଭାଇମାନେ',
      icon: '🌱',
    ),
    AppLanguage(
      code: 'ml',
      nativeName: 'മലയാളം',
      englishName: 'Malayalam',
      region: 'കേരളം (Kerala)',
      greeting: 'നമസ്കാരം കർഷക സുഹൃത്തുക്കളെ',
      icon: '🌴',
    ),
    AppLanguage(
      code: 'en',
      nativeName: 'English',
      englishName: 'English',
      region: 'All India (National)',
      greeting: 'Welcome Farmer Friends',
      icon: '🇮🇳',
    ),
  ];

  static AppLanguage findByCode(String code) {
    return all.firstWhere((l) => l.code == code, orElse: () => all.first);
  }
}
