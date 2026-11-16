import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../../viewmodels/mandi_viewmodel.dart';
import '../soil/soil_advisory_view.dart';
import '../store/store_view.dart';
import '../../constants/supported_languages.dart';
import '../language/language_selection_view.dart';

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
                'à¤•à¤¿à¤¸à¤¾à¤¨à¤®à¤¿à¤¤à¥à¤°',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LanguageSelectionView(isFirstTime: false),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.language_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    SupportedLanguages.findByCode(loc).nativeName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
                ],
              ),
            ),
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
                authVm.isMr ? 'à¤¶à¥‡à¤¤à¥€ à¤¨à¤¿à¤°à¥à¤£à¤¯ à¤¸à¤¾à¤§à¤¨à¥‡' : (authVm.isHi ? 'à¤•à¥ƒà¤·à¤¿ à¤¨à¤¿à¤°à¥à¤£à¤¯ à¤‰à¤ªà¤•à¤°à¤£' : 'Agronomic Tools'),
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
    final name = user?.fullName ?? 'Ramesh Patil (à¤¶à¥‡à¤¤à¤•à¤°à¥€)';
    final location = '${user?.village ?? "à¤¶à¤¿à¤°à¥‹à¤³"}, ${user?.district ?? "à¤•à¥‹à¤²à¥à¤¹à¤¾à¤ªà¥‚à¤°"}';
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
                          authVm.isMr ? 'à¤¡à¥‡à¤®à¥‹' : 'DEMO',
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
                  'ðŸ“ $location â€¢ $acreage à¤à¤•à¤° à¤¶à¥‡à¤¤',
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
    final borderColor = isSafe ? AppColors.accentLight : AppColors.danger;
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
                'ðŸŒ¾ ${mandiVm.selectedCommodity} â€” ' + AppStrings.get('bestMandi', locale: loc),
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
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.accent),
                  ),
                  child: Text(
                    '+â‚¹${delta.toStringAsFixed(0)} à¤¨à¤«à¤¾',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
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
                      '${best.distanceKm} km à¤…à¤‚à¤¤à¤° â€¢ ${best.yardTier ?? "APMC Yard"}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'â‚¹${best.effectiveNetRate.toStringAsFixed(0)} / Qtl',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    const Text(
                      'à¤¹à¤¾à¤¤à¤¾à¤¤ à¤ªà¤¡à¤£à¤¾à¤°à¤¾ à¤¨à¤¿à¤µà¥à¤µà¤³ à¤¦à¤°',
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
          title: authVm.isMr ? 'à¤®à¤¾à¤¤à¥€ à¤ªà¤°à¥€à¤•à¥à¤·à¤£ à¤¸à¤²à¥à¤²à¤¾' : 'Soil Health & NPK',
          subtitle: authVm.isMr ? 'ICAR à¤–à¤¤ à¤®à¤¾à¤¤à¥à¤°à¤¾' : 'Fertilizer Dosage',
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
          title: authVm.isMr ? 'à¤•à¥ƒà¤·à¥€ à¤‡à¤¨à¤ªà¥à¤Ÿ à¤¸à¥à¤Ÿà¥‹à¤°' : 'Agri Store',
          subtitle: authVm.isMr ? 'à¤–à¤¤à¥‡, à¤¬à¤¿à¤¯à¤¾à¤£à¥‡, à¤”à¤·à¤§à¥‡' : 'Direct Seeds & DAP',
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
              'ðŸ“Š à¤†à¤œà¤šà¥‡ à¤ªà¥à¤°à¤®à¥à¤– à¤¬à¤¾à¤œà¤¾à¤°à¤­à¤¾à¤µ (APMC Live)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('à¤¸à¤°à¥à¤µ à¤ªà¤¹à¤¾ â†’', style: TextStyle(fontSize: 12, color: AppColors.primary)),
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
                        '${eval.distanceKm} km â€¢ à¤–à¤°à¥à¤š: -â‚¹${eval.logisticsOverhead.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  Text(
                    'â‚¹${eval.quotedGrossRate.toStringAsFixed(0)}',
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

