class ApiConstants {
  // FastAPI Backend Configuration
  // Default to localhost, Android emulator 10.0.2.2, or live tunnel
  static const String localAndroidBaseUrl = 'http://10.0.2.2:8000';
  static const String localDeviceBaseUrl = 'http://localhost:8000';
  static const String liveCloudflareTunnel = 'https://update-bestsellers-reynolds-clay.trycloudflare.com';

  // Active base URL (defaults to live backend tunnel / local)
  static String activeBaseUrl = liveCloudflareTunnel;

  // Supabase Configuration (Synced with Web Next.js App)
  static const String supabaseUrl = 'https://dpkjhgnhagjzuloxjlqo.supabase.co';
  static const String supabaseAnonKey =
      'sb_publishable_dqTh_YtBYhdYyQmDF3gilQ_can4Buw-';

  // API Endpoints
  static const String endpointArbitrage = '/api/v1/market/arbitrage';
  static const String endpointUniversalArbitrage = '/api/v1/market/arbitrage/universal';
  static const String endpointRegistry = '/api/v1/market/registry';
  static const String endpointSprayWindow = '/api/v1/agronomy/spray-window';
  static const String endpointWeatherForecast = '/api/v1/agronomy/weather-forecast';
  static const String endpointCropDiagnose = '/api/v1/agronomy/diagnose';
  static const String endpointSpatialResolve = '/api/v1/spatial/resolve';
  static const String endpointMandis = '/api/mandis';
  static const String endpointChat = '/chat';
  static const String endpointSTT = '/stt';
  static const String endpointTTS = '/tts';
  static const String endpointProducts = '/api/products';
  static const String endpointFertilizerPlans = '/api/fertilizer-plans';
  static const String endpointVillageSearch = '/api/lgd/search';
  static const String endpointVillageReverse = '/api/lgd/reverse';

  // Request timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
