import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/supported_languages.dart';
import '../../models/mandi_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../../viewmodels/mandi_viewmodel.dart';
import '../../viewmodels/soil_viewmodel.dart';
import '../markets/mandi_profit_calculator_view.dart';
import '../soil/soil_advisory_view.dart';
import '../store/store_view.dart';
import '../schemes/schemes_view.dart';
import '../khata/farm_khata_view.dart';
import '../intercropping/intercropping_view.dart';
import '../profile/profile_view.dart';
import '../language/language_selection_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _customStockController = TextEditingController();

  final List<String> _commodities = [
    'Soybean',
    'Cotton',
    'Onion',
    'Tomato',
    'Tur',
    'Wheat',
  ];

  final Map<String, String> _commodityLabelsMr = {
    'Soybean': '🌱 सोयाबीन',
    'Cotton': '☁️ कापूस',
    'Onion': '🧅 कांदा',
    'Tomato': '🍅 टोमॅटो',
    'Tur': '🌾 तूर',
    'Wheat': '🌾 गहू',
  };

  final Map<String, String> _commodityLabelsEn = {
    'Soybean': '🌱 Soybean',
    'Cotton': '☁️ Cotton',
    'Onion': '🧅 Onion',
    'Tomato': '🍅 Tomato',
    'Tur': '🌾 Tur / Arhar',
    'Wheat': '🌾 Wheat',
  };

  @override
  void dispose() {
    _customStockController.dispose();
    super.dispose();
  }

  void _showEditCropTrackerDialog(BuildContext context, SoilViewModel soilVm, bool isEn) {
    String currentCrop = soilVm.cropTracker.growingCrop;
    double currentStock = soilVm.cropTracker.storedStockQuintals;
    _customStockController.text = currentStock.toStringAsFixed(0);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: [
              const Icon(Icons.edit_note_rounded, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                isEn ? 'Update Standing Crop & Stock' : 'पिके व साठा नोंदवा',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEn ? 'Currently Growing Crop in Field:' : 'सध्या शेतात उभे असलेले पीक:',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _commodities.contains(currentCrop)
                    ? currentCrop
                    : (currentCrop.contains('कापूस') || currentCrop.contains('Cotton')
                        ? 'Cotton'
                        : (currentCrop.contains('कांदा') || currentCrop.contains('Onion')
                            ? 'Onion'
                            : (currentCrop.contains('तूर') || currentCrop.contains('Tur')
                                ? 'Tur'
                                : (currentCrop.contains('टोमॅटो') || currentCrop.contains('Tomato')
                                    ? 'Tomato'
                                    : 'Soybean')))),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                items: _commodities.map((c) {
                  final label = isEn ? (_commodityLabelsEn[c] ?? c) : (_commodityLabelsMr[c] ?? c);
                  return DropdownMenuItem(
                    value: c,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setDialogState(() {
                      currentCrop = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 14),
              Text(
                isEn ? 'Stored Farm Stock (Quintals):' : 'घरी / गोदामात शिल्लक साठा (क्विंटल):',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _customStockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixText: isEn ? 'Qtl' : 'क्विंटल',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(isEn ? 'Cancel' : 'रद्द करा'),
            ),
            ElevatedButton(
              onPressed: () {
                final qty = double.tryParse(_customStockController.text.trim()) ?? 35.0;
                soilVm.updateCropTracker(
                  growingCrop: isEn ? (_commodityLabelsEn[currentCrop] ?? currentCrop) : (_commodityLabelsMr[currentCrop] ?? currentCrop),
                  storedStockQuintals: qty,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEn ? '✓ Crop details & AI forecast updated!' : '✓ पिकांची माहिती व AI अंदाज अपडेट केला!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text(isEn ? 'Save' : 'सेव्ह करा'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final weatherVm = context.watch<WeatherViewModel>();
    final mandiVm = context.watch<MandiViewModel>();
    final soilVm = context.watch<SoilViewModel>();
    final loc = authVm.locale;
    final isEn = authVm.isEn;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            tooltip: isEn ? 'Menu' : 'मेनू',
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
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
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                AppStrings.get('appHindiName', locale: loc),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
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
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 19),
            tooltip: isEn ? 'Sign Out' : 'Sign Out (लॉगआउट)',
            onPressed: () async {
              await authVm.signOut();
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await weatherVm.fetchWeather();
          await mandiVm.calculateArbitrage();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Farmer Identity & GPS Location Header
              _buildFarmerHeaderCard(context, authVm, isEn),
              const SizedBox(height: 14),

              // 2. CORE FEATURE 1: Nearby Mandis & Dedicated Calculator Launcher
              _buildMandiCalculatorSection(context, mandiVm, isEn),
              const SizedBox(height: 14),

              // 3. CORE FEATURE 2: GPS Location Soil Type & Recommended Suitable Crops
              _buildSoilDetectionSection(context, soilVm, authVm, isEn),
              const SizedBox(height: 14),

              // 4. CORE FEATURE 3: My Crops & AI Future Price Predictor (Hold vs Sell)
              _buildMyCropsForecastSection(context, soilVm, isEn),
              const SizedBox(height: 14),

              // 5. Hyperlocal Weather Spray Window Banner
              _buildWeatherSprayBanner(context, weatherVm, loc),
              const SizedBox(height: 14),

              // 6. Quick Agronomic Tools Navigation Grid
              Text(
                isEn ? 'Agricultural Decision Tools' : (authVm.isHi ? 'कृषि निर्णय उपकरण' : 'शेती निर्णय साधने'),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              _buildQuickActionsGrid(context, authVm, isEn),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- 1. FARMER HEADER CARD ---
  Widget _buildFarmerHeaderCard(BuildContext context, AuthViewModel authVm, bool isEn) {
    final user = authVm.currentUser;
    final name = (user?.fullName != null && user!.fullName.isNotEmpty)
        ? user.fullName
        : (isEn ? 'Ramesh Patil (Farmer)' : 'रमेश पाटील (शेतकरी)');
    final village = (user?.village != null && user!.village!.isNotEmpty)
        ? user.village!
        : (isEn ? 'Shirol' : 'शिरोळ');
    final district = (user?.district != null && user!.district!.isNotEmpty)
        ? user.district!
        : (isEn ? 'Kolhapur' : 'कोल्हापूर');
    final acreage = user?.landSizeAcres ?? 4.5;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileView()),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: const [
            BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primaryLight,
              child: Icon(Icons.person, color: AppColors.primary, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Text(
                          isEn ? '✓ Active Farmer' : '✓ सक्रिय शेतकरी',
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '📍 $village, $district • $acreage ${isEn ? "Acres Farmland" : "एकर शेतजमीन"}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Icon(Icons.edit_outlined, size: 16, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. MANDI NET ARBITRAGE SECTION ---
  Widget _buildMandiCalculatorSection(
    BuildContext context,
    MandiViewModel mandiVm,
    bool isEn,
  ) {
    final highestMandi = mandiVm.rankings.isNotEmpty
        ? (List<MandiEvaluation>.from(mandiVm.rankings)..sort((a, b) => b.quotedGrossRate.compareTo(a.quotedGrossRate))).first
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    isEn ? 'Nearby Mandis & Live Market Rates' : 'नजीकच्या बाजारपेठा व नफा तुलना',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'APMC Live',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            isEn
                ? 'Select crop ➔ View live rates ➔ Calculate transport & true net profit'
                : '१. पीक निवडा ➔ २. थेट दर पाहा ➔ वाहतूक खर्च व निव्वळ नफा कॅल्क्युलेट करा',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),

          // Crop Selection Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _commodities.map((comm) {
                final isSelected = mandiVm.selectedCommodity == comm;
                final label = isEn ? (_commodityLabelsEn[comm] ?? comm) : (_commodityLabelsMr[comm] ?? comm);
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.background,
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.cardBorder,
                      ),
                    ),
                    onSelected: (selected) {
                      if (selected) mandiVm.setCommodity(comm);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // Highlight Highest Quoted Rate Mandi Banner
          if (highestMandi != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.amber, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 11, color: Colors.brown),
                        children: [
                          TextSpan(text: isEn ? 'Highest Price for this crop: ' : 'या पिकासाठी सर्वोच्च भाव: '),
                          TextSpan(
                            text: '${highestMandi.mandiName} ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: '₹${highestMandi.quotedGrossRate.toStringAsFixed(0)} / Qtl',
                            style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.black87),
                          ),
                          TextSpan(text: ' (${highestMandi.distanceKm} km)'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Dedicated Page Launcher Button with Auto-Vehicle Info
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MandiProfitCalculatorView(
                    initialCommodity: mandiVm.selectedCommodity,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF1E4620)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.calculate_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEn
                              ? 'Calculate Transport & True Profit'
                              : 'वाहतूक खर्च व निव्वळ नफा कॅल्क्युलेटर',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEn
                              ? 'Enter quantity ➔ Auto-select vehicle ➔ Compare in-hand cash'
                              : 'वजन टाका ➔ वाहन आपोआप निवडले जाईल ➔ खरा नफा पाहा',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Top Mandis Preview List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isEn ? 'Top Mandis Overview:' : 'प्रमुख बाजारपेठा (थेट दर):',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MandiProfitCalculatorView(
                        initialCommodity: mandiVm.selectedCommodity,
                      ),
                    ),
                  );
                },
                child: Text(
                  isEn ? 'Open Full Calculator ➔' : 'संपूर्ण कॅल्क्युलेटर उघडा ➔',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          ...mandiVm.rankings.take(3).toList().asMap().entries.map((entry) {
            final idx = entry.key;
            final eval = entry.value;
            final isWinner = idx == 0;

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MandiProfitCalculatorView(
                      initialCommodity: mandiVm.selectedCommodity,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isWinner ? AppColors.successBg.withValues(alpha: 0.5) : AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isWinner ? AppColors.primary : AppColors.cardBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isWinner ? AppColors.primary : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '#${idx + 1}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isWinner ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  eval.mandiName,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isWinner) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    isEn ? '🏆 Top Profit' : '🏆 सर्वाधिक नफा',
                                    style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          Text(
                            '${eval.distanceKm} km • ${isEn ? "Quoted Rate:" : "बाजार भाव:"} ₹${eval.quotedGrossRate.toStringAsFixed(0)}/Qtl',
                            style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${eval.quotedGrossRate.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: isWinner ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          isEn ? 'per Quintal' : 'प्रति क्विंटल',
                          style: const TextStyle(fontSize: 8, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // --- 3. GPS SOIL TYPE & SUITABLE CROPS SECTION ---
  Widget _buildSoilDetectionSection(
    BuildContext context,
    SoilViewModel soilVm,
    AuthViewModel authVm,
    bool isEn,
  ) {
    final soil = soilVm.detectedSoil;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.landscape_rounded, color: Colors.brown, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    isEn ? 'Local Soil Type & Suitable Crops' : 'स्थानिक माती प्रकार व योग्य पिके',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.brown.shade200),
                ),
                child: const Text(
                  'GPS Auto-Detect',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.brown),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${isEn ? "Location:" : "स्थान:"} ${soil.getLocation(isEn)}',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),

          // Soil Badge Container
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.brown.shade700, const Color(0xFF3E2723)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        soil.getSoilName(isEn),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'pH ${soil.ph}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${isEn ? "Organic Carbon:" : "सेंद्रिय कर्ब:"} ${soil.getOrganicCarbon(isEn)} • ${isEn ? "Moisture Retention:" : "ओलावा धारणा:"} ${soil.getWaterRetention(isEn)}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Recommended Suitable Crops
          Text(
            isEn ? 'Recommended Suitable Crops for this Soil:' : 'या जमिनीसाठी सर्वाधिक अनुकूल पिके (Suitable Crops):',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: soil.suitableCrops.map((crop) {
                return Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(crop.icon, style: const TextStyle(fontSize: 18)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              crop.getName(isEn).split(' ').first,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        crop.getYield(isEn),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        crop.getReason(isEn),
                        style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // Soil Management Tip
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    soil.getTip(isEn),
                    style: const TextStyle(fontSize: 10, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 4. MY CROPS & FUTURE PRICE PREDICTOR SECTION (HOLD VS SELL) ---
  Widget _buildMyCropsForecastSection(BuildContext context, SoilViewModel soilVm, bool isEn) {
    final tracker = soilVm.cropTracker;
    final forecast = soilVm.priceForecast;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_graph_rounded, color: Colors.deepPurple, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    isEn ? 'My Standing Crops & AI Price Forecast' : 'माझी पिके व AI बाजारभाव अंदाज',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showEditCropTrackerDialog(context, soilVm, isEn),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.deepPurple.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.edit, size: 10, color: Colors.deepPurple),
                      const SizedBox(width: 2),
                      Text(
                        isEn ? 'Edit' : 'बदला',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Current crop & stock badges
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEn ? 'Standing Crop:' : 'सध्याचे पीक:',
                        style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                      ),
                      Text(
                        tracker.getGrowingCrop(isEn),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isEn ? 'Stored Stock:' : 'शिल्लक साठा (Stock):',
                        style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                      ),
                      Text(
                        '${tracker.storedStockQuintals.toStringAsFixed(0)} ${isEn ? "Quintals" : "क्विंटल"}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // AI Advisory Card (Hold vs Sell)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: forecast.shouldHold ? AppColors.successBg : AppColors.dangerBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: forecast.shouldHold ? AppColors.accentLight : AppColors.danger.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      forecast.getVerdictBadge(isEn),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: forecast.shouldHold ? AppColors.primary : AppColors.danger,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${forecast.confidencePercent}% ${isEn ? "Accuracy" : "अचूकता"}',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: forecast.shouldHold ? AppColors.primary : AppColors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Price Projection Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isEn ? "Today's Price" : 'आजचा भाव', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                        Text(
                          '₹${forecast.currentPrice.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    Icon(
                      forecast.shouldHold ? Icons.trending_up : Icons.trending_down,
                      color: forecast.shouldHold ? Colors.green : Colors.red,
                      size: 28,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          isEn ? 'Forecast (${forecast.daysAhead} days)' : 'भाकीत भाव (${forecast.daysAhead} दिवस)',
                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                        ),
                        Text(
                          '₹${forecast.predictedPrice.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: forecast.shouldHold ? AppColors.primary : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (forecast.potentialExtraProfit > 0) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        isEn
                            ? '💰 Holding Stock Net Gain: +₹${forecast.potentialExtraProfit.toStringAsFixed(0)} Extra'
                            : '💰 साठवून ठेवल्यास संभाव्य नफा: +₹${forecast.potentialExtraProfit.toStringAsFixed(0)} अतिरिक्त',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],

                Text(
                  forecast.getAdvisory(isEn),
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 5. WEATHER SPRAY BANNER ---
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

  // --- 6. QUICK ACTIONS GRID ---
  Widget _buildQuickActionsGrid(BuildContext context, AuthViewModel authVm, bool isEn) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.55,
      children: [
        _buildActionTile(
          context,
          icon: Icons.account_balance_rounded,
          color: Colors.purple.shade700,
          title: isEn ? 'Govt Schemes DBT' : 'शासकीय योजना व अनुदान',
          subtitle: isEn ? 'Solar Pump & Drip Subsidy' : 'सौर पंप, ठिबक व विमा',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SchemesView()),
            );
          },
        ),
        _buildActionTile(
          context,
          icon: Icons.account_balance_wallet_rounded,
          color: const Color(0xFF165B33),
          title: isEn ? 'Farm Khata Ledger' : 'शेतकरी नफा-तोटा वही',
          subtitle: isEn ? 'Crop Expenses & P&L' : 'खर्च, विक्री व ROI',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FarmKhataView()),
            );
          },
        ),
        _buildActionTile(
          context,
          icon: Icons.grass_rounded,
          color: Colors.amber.shade900,
          title: isEn ? 'Intercropping Planner' : 'आंतरपीक व फेरपालट',
          subtitle: isEn ? 'Row Pattern & Yield' : '४:२ प्रमाण व खत बचत',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const IntercroppingView()),
            );
          },
        ),
        _buildActionTile(
          context,
          icon: Icons.science_outlined,
          color: Colors.teal,
          title: isEn ? 'Soil Health & NPK' : 'माती परीक्षण सल्ला',
          subtitle: isEn ? 'ICAR Fertilizer Dosage' : 'ICAR खत मात्रा',
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
          title: isEn ? 'Agri Input Store' : 'कृषी इनपुट स्टोअर',
          subtitle: isEn ? 'Fertilizers & Direct Seeds' : 'खते, बियाणे, औषधे',
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
}
