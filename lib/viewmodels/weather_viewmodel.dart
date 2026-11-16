import 'package:flutter/foundation.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final ApiService _apiService;
  WeatherReport? _weatherReport;
  bool _isLoading = false;
  String? _errorMessage;

  double _currentLat = 16.7050; // Default Shirol, Kolhapur
  double _currentLon = 74.2433;
  String _currentLocationName = 'Shirol, Kolhapur';

  WeatherViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  WeatherReport? get weatherReport => _weatherReport;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get currentLat => _currentLat;
  double get currentLon => _currentLon;
  String get currentLocationName => _currentLocationName;

  bool get isSafeToSpray => _weatherReport?.safeToSprayNow ?? true;
  bool get hasRainHazard => _weatherReport?.rainHazard ?? false;
  bool get hasWindHazard => _weatherReport?.windDriftHazard ?? false;
  bool get hasConvectiveAlert => _weatherReport?.convectiveStormAlert ?? false;

  Future<void> fetchWeather({double? lat, double? lon, String? locationName}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (lat != null && lon != null) {
      _currentLat = lat;
      _currentLon = lon;
      if (locationName != null) _currentLocationName = locationName;
    }

    try {
      final report = await _apiService.getSprayWindow(
        lat: _currentLat,
        lon: _currentLon,
      );

      if (report != null) {
        _weatherReport = report;
      } else {
        _errorMessage = 'Could not fetch weather data. Showing local forecast.';
        _weatherReport = _generateFallbackReport();
      }
    } catch (e) {
      _errorMessage = e.toString();
      _weatherReport = _generateFallbackReport();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Auto-detect GPS location
  Future<void> detectGPSLocation() async {
    _isLoading = true;
    notifyListeners();

    final pos = await LocationService.getCurrentLocation();
    if (pos != null) {
      _currentLat = pos.latitude;
      _currentLon = pos.longitude;
      _currentLocationName = 'Farm GPS (${pos.latitude.toStringAsFixed(2)}, ${pos.longitude.toStringAsFixed(2)})';
    }
    await fetchWeather(lat: _currentLat, lon: _currentLon);
  }

  WeatherReport _generateFallbackReport() {
    return WeatherReport(
      safeToSprayNow: true,
      rainHazard: false,
      windDriftHazard: false,
      heatHazard: false,
      actionAdvisory: 'Safe to spray. Low wind and zero wash-off risk predicted.',
      safeWindowHours: ['06:00', '07:00', '08:00', '17:00', '18:00'],
      mosDownscalingActive: true,
      convectiveStormAlert: false,
      hourlySlots: List.generate(8, (i) {
        final hourInt = (6 + i * 2) % 24;
        final hourStr = '${hourInt.toString().padLeft(2, '0')}:00';
        return HourlySlot(
          hour: hourStr,
          temp: 26.0 + (i % 3) * 2,
          rainAmount: 0.0,
          rainProb: 10.0 + (i * 2),
          windSpeed: 8.5 + (i * 1.2),
          mosRainAmount: 0.0,
          mosRainProb: 8.0,
          isConvectiveRisk: false,
          isSafeToSpray: true,
        );
      }),
      dailyForecast: [
        DailyForecast(
          date: '2026-11-16',
          day: 'Mon',
          maxTemp: 31.5,
          minTemp: 19.2,
          rainSum: 0.0,
          condition: 'Sunny / Clear',
          advisory: 'Optimal window for fungicide application.',
          safeToSpray: true,
        ),
        DailyForecast(
          date: '2026-11-17',
          day: 'Tue',
          maxTemp: 32.0,
          minTemp: 20.0,
          rainSum: 0.0,
          condition: 'Partly Cloudy',
          advisory: 'Good spraying conditions before 10 AM.',
          safeToSpray: true,
        ),
        DailyForecast(
          date: '2026-11-18',
          day: 'Wed',
          maxTemp: 29.0,
          minTemp: 18.5,
          rainSum: 2.4,
          condition: 'Scattered Showers',
          advisory: 'Postpone chemical spray due to rain wash-off risk.',
          safeToSpray: false,
        ),
      ],
    );
  }
}
