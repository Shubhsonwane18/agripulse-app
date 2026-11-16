import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../../models/weather_model.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final weatherVm = context.watch<WeatherViewModel>();
    final loc = authVm.locale;
    final report = weatherVm.weatherReport;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.get('weatherTitle', locale: loc),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
            ),
            Text(
              weatherVm.currentLocationName,
              style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location, color: Colors.white),
            tooltip: 'GPS Auto-Detect',
            onPressed: () => weatherVm.detectGPSLocation(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => weatherVm.fetchWeather(),
          ),
        ],
      ),
      body: weatherVm.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: () => weatherVm.fetchWeather(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. MOS Downscaling Badge Banner
                    _buildMOSBadge(context, report, loc),
                    const SizedBox(height: 12),

                    // 2. Primary Spraying Window Status Box
                    _buildSprayStatusBox(context, weatherVm, loc),
                    const SizedBox(height: 18),

                    // 3. 24-Hour Timeline Section
                    Text(
                      AppStrings.get('hourlyWindow', locale: loc),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildHourlyTimeline(context, report?.hourlySlots ?? [], loc),
                    const SizedBox(height: 18),

                    // 4. 7-Day Agronomic Forecast
                    Text(
                      authVm.isMr ? '७ दिवसांचा शेती हवामान अंदाज' : '7-Day Agronomic Weather Forecast',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDailyForecastList(context, report?.dailyForecast ?? [], loc),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMOSBadge(BuildContext context, WeatherReport? report, String loc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.hub_outlined, color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              Text(
                AppStrings.get('weatherSubtitle', locale: loc),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.emerald.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.emerald.shade200),
            ),
            child: const Text(
              'IMD Calibrated',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSprayStatusBox(BuildContext context, WeatherViewModel weatherVm, String loc) {
    final isSafe = weatherVm.isSafeToSpray;
    final report = weatherVm.weatherReport;
    final bgColor = isSafe ? AppColors.successBg : AppColors.dangerBg;
    final borderColor = isSafe ? Colors.emerald.shade300 : Colors.rose.shade300;
    final textColor = isSafe ? AppColors.success : AppColors.danger;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSafe ? Icons.check_circle : Icons.dangerous_rounded,
                color: textColor,
                size: 26,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isSafe
                      ? AppStrings.get('safeToSpray', locale: loc)
                      : AppStrings.get('lockoutActive', locale: loc),
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            report?.actionAdvisory ?? 'Safe to proceed with chemical application.',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          if (report?.safeWindowHours.isNotEmpty == true) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: report!.safeWindowHours.map((slot) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    '🕒 $slot',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHourlyTimeline(BuildContext context, List<HourlySlot> slots, String loc) {
    return SizedBox(
      height: 145,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: slots.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, idx) {
          final slot = slots[idx];
          final isSafe = slot.isSafeToSpray;
          final isConvective = slot.isConvectiveRisk;

          Color cardBg = isSafe
              ? Colors.emerald.shade50
              : (isConvective ? Colors.amber.shade50 : Colors.rose.shade50);
          Color borderCol = isSafe
              ? Colors.emerald.shade200
              : (isConvective ? Colors.amber.shade300 : Colors.rose.shade200);

          return Container(
            width: 110,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderCol),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  slot.hour,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                ),
                Text(
                  '${slot.temp}°C',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                ),
                Column(
                  children: [
                    Text(
                      '💧 ${slot.mosRainAmount ?? slot.rainAmount}mm',
                      style: const TextStyle(fontSize: 9, color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '💨 ${slot.windSpeed}km/h',
                      style: const TextStyle(fontSize: 9, color: Colors.black800),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSafe ? AppColors.primary : Colors.rose.shade600,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isSafe ? 'Safe' : 'Risk',
                    style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyForecastList(BuildContext context, List<DailyForecast> days, String loc) {
    return Column(
      children: days.map((day) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${day.day} • ${day.date}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${day.condition} • 💧 ${day.rainSum} mm',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 220,
                    child: Text(
                      day.advisory,
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${day.maxTemp}° / ${day.minTemp}°',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: day.safeToSpray ? AppColors.successBg : AppColors.dangerBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      day.safeToSpray ? '✓ फवारणी' : '⚠ थांबा',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: day.safeToSpray ? AppColors.success : AppColors.danger,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
