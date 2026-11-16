class HourlySlot {
  final String hour;
  final double temp;
  final double rainAmount;
  final double rainProb;
  final double windSpeed;
  final double? mosRainAmount;
  final double? mosRainProb;
  final bool isConvectiveRisk;
  final bool isSafeToSpray;

  HourlySlot({
    required this.hour,
    required this.temp,
    required this.rainAmount,
    required this.rainProb,
    required this.windSpeed,
    this.mosRainAmount,
    this.mosRainProb,
    required this.isConvectiveRisk,
    required this.isSafeToSpray,
  });

  factory HourlySlot.fromJson(Map<String, dynamic> json) {
    return HourlySlot(
      hour: json['hour']?.toString() ?? '',
      temp: (json['temp'] ?? 25.0).toDouble(),
      rainAmount: (json['rain_amount'] ?? json['rainAmount'] ?? 0.0).toDouble(),
      rainProb: (json['rain_prob'] ?? json['rainProb'] ?? 0.0).toDouble(),
      windSpeed: (json['wind_speed'] ?? json['windSpeed'] ?? 0.0).toDouble(),
      mosRainAmount: json['mos_rain_amount'] != null
          ? (json['mos_rain_amount']).toDouble()
          : (json['mosRainAmount'] != null ? (json['mosRainAmount']).toDouble() : null),
      mosRainProb: json['mos_rain_prob'] != null
          ? (json['mos_rain_prob']).toDouble()
          : (json['mosRainProb'] != null ? (json['mosRainProb']).toDouble() : null),
      isConvectiveRisk: json['is_convective_risk'] == true || json['isConvectiveRisk'] == true,
      isSafeToSpray: json['is_safe_to_spray'] == true || json['isSafeToSpray'] == true,
    );
  }
}

class DailyForecast {
  final String date;
  final String day;
  final double maxTemp;
  final double minTemp;
  final double rainSum;
  final String condition;
  final String advisory;
  final bool safeToSpray;

  DailyForecast({
    required this.date,
    required this.day,
    required this.maxTemp,
    required this.minTemp,
    required this.rainSum,
    required this.condition,
    required this.advisory,
    required this.safeToSpray,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: json['date']?.toString() ?? '',
      day: json['day']?.toString() ?? '',
      maxTemp: (json['maxTemp'] ?? json['max_temp'] ?? 30.0).toDouble(),
      minTemp: (json['minTemp'] ?? json['min_temp'] ?? 20.0).toDouble(),
      rainSum: (json['rainSum'] ?? json['rain_sum'] ?? 0.0).toDouble(),
      condition: json['condition']?.toString() ?? 'Clear Sky',
      advisory: json['advisory']?.toString() ?? '',
      safeToSpray: json['safeToSpray'] == true || json['safe_to_spray'] == true,
    );
  }
}

class WeatherReport {
  final bool safeToSprayNow;
  final bool rainHazard;
  final bool windDriftHazard;
  final bool heatHazard;
  final String actionAdvisory;
  final List<String> safeWindowHours;
  final List<HourlySlot> hourlySlots;
  final List<DailyForecast> dailyForecast;
  final bool mosDownscalingActive;
  final bool convectiveStormAlert;

  WeatherReport({
    required this.safeToSprayNow,
    required this.rainHazard,
    required this.windDriftHazard,
    required this.heatHazard,
    required this.actionAdvisory,
    required this.safeWindowHours,
    required this.hourlySlots,
    required this.dailyForecast,
    this.mosDownscalingActive = true,
    this.convectiveStormAlert = false,
  });

  factory WeatherReport.fromJson(Map<String, dynamic> json) {
    var rawHourly = (json['hourly_slots'] ?? json['hourlySlots'] ?? []) as List;
    var rawDaily = (json['daily_forecast'] ?? json['dailyForecast'] ?? []) as List;
    var rawWindows = (json['safe_window_hours'] ?? json['safeWindowHours'] ?? []) as List;

    return WeatherReport(
      safeToSprayNow: json['safe_to_spray_now'] == true || json['safeToSprayNow'] == true,
      rainHazard: json['rain_hazard'] == true || json['rainHazard'] == true,
      windDriftHazard: json['wind_drift_hazard'] == true || json['windDriftHazard'] == true,
      heatHazard: json['heat_hazard'] == true || json['heatHazard'] == true,
      actionAdvisory: json['action_advisory']?.toString() ?? json['actionAdvisory']?.toString() ?? '',
      safeWindowHours: rawWindows.map((e) => e.toString()).toList(),
      hourlySlots: rawHourly.map((e) => HourlySlot.fromJson(e as Map<String, dynamic>)).toList(),
      dailyForecast: rawDaily.map((e) => DailyForecast.fromJson(e as Map<String, dynamic>)).toList(),
      mosDownscalingActive: json['mos_downscaling_active'] != false,
      convectiveStormAlert: json['convective_storm_alert'] == true,
    );
  }
}
