import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../../viewmodels/mandi_viewmodel.dart';
import '../soil/soil_advisory_view.dart';
import '../store/store_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final weatherVm = context.watch<WeatherViewModel>();
    final mandiVm = context.watch<MandiViewModel>();
    final loc = authVm.locale;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            const Text(
              'AgriPulse',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 19),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'किसानमित्र',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ),
          ],
        ),
        actions: [
          // Language switcher
          PopupMenuButton<String>(
            initialValue: authVm.locale,
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    authVm.isMr ? 'मराठी' : (authVm.isHi ? 'हिंदी' : 'EN'),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ],
              ),
            ),
            onSelected: (l) => authVm.setLocale(l),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'mr', child: Text('मराठी (Marathi)')),
              PopupMenuItem(value: 'hi', child: Text('हिंदी (Hindi)')),
              PopupMenuItem(value: 'en', child: Text('English')),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await weatherVm.fetchWeather();
          await mandiVm.calculateArbitrage();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Farmer Greeting & Farm Microclimate Card
              _buildFarmerHeaderCard(context, authVm),
              const SizedBox(height: 14),

              // 2. Hyperlocal MOS Spray Window Status Banner
              _buildWeatherSprayBanner(context, weatherVm, loc),
              const SizedBox(height: 14),

              // 3. Mandi Net Arbitrage Winner Widget
              _buildMandiArbitrageCard(context, mandiVm, loc),
              const SizedBox(height: 14),

              // 4. Quick Action Grid
              Text(
                authVm.isMr ? 'शेती निर्णय साधने' : (authVm.isHi ? 'कृषि निर्णय उपकरण' : 'Agronomic Tools'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              _buildQuickActionsGrid(context, authVm),
              const SizedBox(height: 16),

              // 5. Live APMC Price Ticker Preview
              _buildLivePricesPreview(context, mandiVm, loc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFarmerHeaderCard(BuildContext context, AuthViewModel authVm) {
    final user = authVm.currentUser;
    final name = user?.fullName ?? 'Ramesh Patil (शेतकरी)';
    final location = '${user?.village ?? "शिरोळ"}, ${user?.district ?? "कोल्हापूर"}';
    final acreage = user?.landSizeAcres ?? 4.5;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryLight,
            child: const Icon(Icons.person, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (user?.isDemo == true) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          authVm.isMr ? 'डेमो' : 'DEMO',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '📍 $location • $acreage एकर शेत',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherSprayBanner(
    BuildContext context,
    WeatherViewModel weatherVm,
    String loc,
  ) {
    final isSafe = weatherVm.isSafeToSpray;
    final bgColor = isSafe ? AppColors.successBg : AppColors.dangerBg;
    final borderColor = isSafe ? Colors.emerald.shade200 : Colors.rose.shade200;
    final textColor = isSafe ? AppColors.success : AppColors.danger;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isSafe ? Icons.check_circle : Icons.warning_amber_rounded,
                    color: textColor,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isSafe
                        ? AppStrings.get('safeToSpray', locale: loc)
                        : AppStrings.get('lockoutActive', locale: loc),
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor),
                ),
                child: const Text(
                  'MOS 2km AI',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            weatherVm.weatherReport?.actionAdvisory ??
                (isSafe
                    ? 'Safe to spray. Low wind and zero wash-off risk predicted.'
                    : 'DO NOT SPRAY: Rain wash-off or high wind drift detected.'),
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildMandiArbitrageCard(
    BuildContext context,
    MandiViewModel mandiVm,
    String loc,
  ) {
    final best = mandiVm.bestMandi;
    final nearest = mandiVm.nearestMandi;
    final delta = mandiVm.netProfitDelta;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🌾 ${mandiVm.selectedCommodity} — ' + AppStrings.get('bestMandi', locale: loc),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              if (delta > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.emerald.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.emerald.shade200),
                  ),
                  child: Text(
                    '+₹${delta.toStringAsFixed(0)} नफा',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.emerald.shade800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (best != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      best.mandiName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${best.distanceKm} km अंतर • ${best.yardTier ?? "APMC Yard"}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${best.effectiveNetRate.toStringAsFixed(0)} / Qtl',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    const Text(
                      'हातात पडणारा निव्वळ दर',
                      style: TextStyle(fontSize: 9, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context, AuthViewModel authVm) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.6,
      children: [
        _buildActionTile(
          context,
          icon: Icons.science_outlined,
          color: Colors.teal,
          title: authVm.isMr ? 'माती परीक्षण सल्ला' : 'Soil Health & NPK',
          subtitle: authVm.isMr ? 'ICAR खत मात्रा' : 'Fertilizer Dosage',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SoilAdvisoryView()),
            );
          },
        ),
        _buildActionTile(
          context,
          icon: Icons.shopping_bag_outlined,
          color: Colors.indigo,
          title: authVm.isMr ? 'कृषी इनपुट स्टोर' : 'Agri Store',
          subtitle: authVm.isMr ? 'खते, बियाणे, औषधे' : 'Direct Seeds & DAP',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StoreView()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLivePricesPreview(
    BuildContext context,
    MandiViewModel mandiVm,
    String loc,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '📊 आजचे प्रमुख बाजारभाव (APMC Live)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('सर्व पहा →', style: TextStyle(fontSize: 12, color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ...mandiVm.rankings.take(3).map((eval) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eval.mandiName,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${eval.distanceKm} km • खर्च: -₹${eval.logisticsOverhead.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  Text(
                    '₹${eval.quotedGrossRate.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
