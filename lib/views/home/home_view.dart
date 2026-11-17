import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/supported_languages.dart';
import '../../models/mandi_model.dart';
import '../../services/mandi_directory_service.dart';
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
import '../forecast/ai_price_forecast_view.dart';

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

  @override
  void dispose() {
    _customStockController.dispose();
    super.dispose();
  }

  void _showEditCropTrackerDialog(BuildContext context, SoilViewModel soilVm, String loc) {
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
              Expanded(
                child: Text(
                  AppStrings.tr(
                    loc,
                    en: 'Update Standing Crop & Stock',
                    mr: 'उभे पीक व शिल्लक साठा नोंदवा',
                    hi: 'खेत की फसल व स्टॉक दर्ज करें',
                    te: 'పంట మరియు నిల్వ వివరాలు నమోదు చేయండి',
                    kn: 'ಬೆಳೆ ಮತ್ತು ದಾಸ್ತಾನು ವಿವರ ದಾಖಲಿಸಿ',
                    gu: 'પાક અને સંગ્રહ વિગતો નોંધો',
                  ),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.tr(
                  loc,
                  en: 'Currently Growing Crop in Field:',
                  mr: 'सध्या शेतात उभे असलेले पीक:',
                  hi: 'वर्तमान में खेत में खड़ी फसल:',
                  te: 'ప్రస్తుతం పొలంలో ఉన్న పంట:',
                  kn: 'ಪ್ರಸ್ತುತ ಹೊಲದಲ್ಲಿರುವ ಬೆಳೆ:',
                  gu: 'હાલમાં ખેતરમાં ઉભો પાક:',
                ),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _commodities.contains(currentCrop)
                    ? currentCrop
                    : (currentCrop.contains('Cotton') || currentCrop.contains('कापूस') || currentCrop.contains('कपास')
                        ? 'Cotton'
                        : (currentCrop.contains('Onion') || currentCrop.contains('कांदा') || currentCrop.contains('प्याज')
                            ? 'Onion'
                            : (currentCrop.contains('Tomato') || currentCrop.contains('टोमॅटो') || currentCrop.contains('टमाटर')
                                ? 'Tomato'
                                : (currentCrop.contains('Tur') || currentCrop.contains('तूर') || currentCrop.contains('अरहर')
                                    ? 'Tur'
                                    : 'Soybean')))),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                items: _commodities.map((c) {
                  final cropMatch = MandiDirectoryService.crops.firstWhere(
                    (item) => item.id.toLowerCase() == c.toLowerCase(),
                    orElse: () => MandiDirectoryService.crops.first,
                  );
                  return DropdownMenuItem(
                    value: c,
                    child: Text(cropMatch.getName(loc)),
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
                AppStrings.tr(
                  loc,
                  en: 'Stored Farm Stock (Quintals):',
                  mr: 'घरी / गोदामात शिल्लक साठा (क्विंटल):',
                  hi: 'घर / गोदाम में बचा स्टॉक (क्विंटल):',
                  te: 'నిల్వ ఉన్న స్టాక్ (క్వింటాళ్ళు):',
                  kn: 'ದಾಸ್ತಾನು ಪ್ರಮಾಣ (ಕ್ವಿಂಟಾಲ್):',
                  gu: 'ગોડાઉનમાં બાકી સ્ટોક (ક્વિન્ટલ):',
                ),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _customStockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixText: AppStrings.tr(loc, en: 'Qtl', mr: 'क्विंटल', hi: 'क्विंटल', te: 'క్వింటాళ్ళు', kn: 'ಕ್ವಿಂಟಾಲ್', gu: 'ક્વિન્ટલ'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppStrings.tr(loc, en: 'Cancel', mr: 'रद्द करा', hi: 'रद्द करें', te: 'రద్దు చేయి', kn: 'ರದ್ದುಮಾಡಿ', gu: 'રદ કરો')),
            ),
            ElevatedButton(
              onPressed: () {
                final qty = double.tryParse(_customStockController.text.trim()) ?? 35.0;
                soilVm.updateCropTracker(
                  growingCrop: currentCrop,
                  storedStockQuintals: qty,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppStrings.tr(
                        loc,
                        en: '✓ Crop details & AI forecast updated!',
                        mr: '✓ पिकांची माहिती व AI अंदाज अपडेट केला!',
                        hi: '✓ फसल विवरण एवं AI पूर्वानुमान अपडेट हुआ!',
                        te: '✓ పంట వివరాలు మరియు AI అంచనా అప్‌డేట్ చేయబడ్డాయి!',
                        kn: '✓ ಬೆಳೆ ವಿವರಗಳು ಮತ್ತು AI ಮುನ್ಸೂಚನೆ ನವೀಕರಿಸಲಾಗಿದೆ!',
                        gu: '✓ પાકની વિગતો અને AI અનુમાન અપડેટ થયું!',
                      ),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text(AppStrings.tr(loc, en: 'Save', mr: 'सेव्ह करा', hi: 'सहेजें', te: 'సేవ్ చేయి', kn: 'ಉಳಿಸಿ', gu: 'સાચવો')),
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            tooltip: AppStrings.tr(loc, en: 'Menu', mr: 'मेनू', hi: 'मेनू', te: 'మెనూ', kn: 'ಮೆನು', gu: 'મેનૂ'),
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
            tooltip: AppStrings.get('logout', locale: loc),
            onPressed: () async {
              await authVm.signOut();
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: _buildDrawer(context, authVm, loc),
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
              _buildFarmerHeaderCard(context, authVm, loc),
              const SizedBox(height: 14),

              // 2. CORE FEATURE 1: Nearby Mandis & Dedicated Calculator Launcher
              _buildMandiCalculatorSection(context, mandiVm, loc),
              const SizedBox(height: 14),

              // 3. CORE FEATURE 2: GPS Location Soil Type & Recommended Suitable Crops
              _buildSoilDetectionSection(context, soilVm, authVm, loc),
              const SizedBox(height: 14),

              // 4. CORE FEATURE 3: My Crops & AI Future Price Predictor (Hold vs Sell)
              _buildMyCropsForecastSection(context, soilVm, loc),
              const SizedBox(height: 14),

              // 5. Hyperlocal Weather Spray Window Banner
              _buildWeatherSprayBanner(context, weatherVm, loc),
              const SizedBox(height: 14),

              // 6. Quick Agronomic Tools Navigation Grid
              Text(
                AppStrings.get('agriToolsTitle', locale: loc),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              _buildQuickActionsGrid(context, authVm, loc),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- 1. FARMER HEADER CARD ---
  Widget _buildFarmerHeaderCard(BuildContext context, AuthViewModel authVm, String loc) {
    final user = authVm.currentUser;
    String rawName = (user?.fullName != null && user!.fullName.isNotEmpty)
        ? user.fullName
        : AppStrings.tr(loc, en: 'Ramesh Patil', mr: 'रमेश पाटील', hi: 'रमेश पाटिल', te: 'రమేష్ పాటిల్', kn: 'ರಮೇಶ್ ಪಾಟೀಲ್', gu: 'રમેશ પાટીલ');
    rawName = rawName.replaceAll('(शेतकरी)', '').replaceAll('(Farmer)', '').replaceAll('(किसान)', '').trim();
    final name = rawName.isNotEmpty ? rawName : 'Ramesh Patil';

    final village = (user?.village != null && user!.village!.isNotEmpty)
        ? user.village!
        : AppStrings.tr(loc, en: 'Shirol', mr: 'शिरोळ', hi: 'शिरोल', te: 'శిరోల్', kn: 'ಶಿರೋಳ', gu: 'શિરોળ');
    final district = (user?.district != null && user!.district!.isNotEmpty)
        ? user.district!
        : AppStrings.tr(loc, en: 'Kolhapur', mr: 'कोल्हापूर', hi: 'कोल्हापुर', te: 'కొల్హాపూర్', kn: 'ಕೊಲ್ಹಾಪುರ', gu: 'કોલ્હાપુર');
    final acreage = user?.landSizeAcres ?? 4.5;
    final crops = user?.preferredCrops ?? ['Soybean', 'Cotton'];

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                              AppStrings.get('activeFarmer', locale: loc),
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '📍 $village, $district • $acreage ${AppStrings.get("acresFarmland", locale: loc)}',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
            if (crops.isNotEmpty) ...[
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: crops.map((cropId) {
                    final cropMatch = MandiDirectoryService.crops.firstWhere(
                      (c) => c.id.toLowerCase() == cropId.toLowerCase() || c.nameEn.toLowerCase() == cropId.toLowerCase(),
                      orElse: () => CropItem(
                        id: cropId,
                        nameEn: cropId,
                        nameMr: cropId,
                        nameHi: cropId,
                        nameTe: cropId,
                        nameKn: cropId,
                        nameGu: cropId,
                        icon: '🌱',
                        categoryId: 'grains',
                        benchmarkPrice: 4500,
                      ),
                    );
                    return Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Text(
                        cropMatch.getName(loc),
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // --- 2. MANDI NET ARBITRAGE SECTION ---
  Widget _buildMandiCalculatorSection(
    BuildContext context,
    MandiViewModel mandiVm,
    String loc,
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
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.storefront_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        AppStrings.get('nearbyMandisTitle', locale: loc),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '📍 ${mandiVm.selectedCity.getName(loc)}',
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.get('nearbyMandisSub', locale: loc),
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),

          // Crop Selection Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _commodities.map((comm) {
                final isSelected = mandiVm.selectedCommodity.toLowerCase() == comm.toLowerCase();
                final cropMatch = MandiDirectoryService.crops.firstWhere(
                  (c) => c.id.toLowerCase() == comm.toLowerCase(),
                  orElse: () => MandiDirectoryService.crops.first,
                );
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(
                      cropMatch.getName(loc),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDE68A)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE68A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.trending_up_rounded, color: Color(0xFFB45309), size: 18),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${AppStrings.tr(loc, en: "Highest Price Mandi:", mr: "सर्वोच्च भाव बाजारपेठ:", hi: "सर्वोच्च भाव मंडी:", te: "అత్యధిక ధర మార్కెట్:", kn: "ಅತ್ಯಧಿಕ ದರ ಮಾರುಕಟ್ಟೆ:", gu: "સર્વોચ્ચ ભાવ બજાર:")} ${highestMandi.mandiName}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF92400E)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹${highestMandi.quotedGrossRate.toStringAsFixed(0)} / Qtl • ${highestMandi.distanceKm} km',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF78350F)),
                        ),
                      ],
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
                          AppStrings.get('calcTransportBtn', locale: loc),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppStrings.get('calcTransportSub', locale: loc),
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
                AppStrings.tr(
                  loc,
                  en: 'Top Mandis Overview:',
                  mr: 'प्रमुख बाजारपेठा (थेट दर):',
                  hi: 'प्रमुख मंडियां (लाइव भाव):',
                  te: 'ప్రధాన మార్కెట్లు (ప్రత్యక్ష ధరలు):',
                  kn: 'ಪ್ರಮುಖ ಮಾರುಕಟ್ಟೆಗಳು (ನೇರ ದರ):',
                  gu: 'મુખ્ય બજારો (લાઈવ ભાવ):',
                ),
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
                  AppStrings.tr(
                    loc,
                    en: 'Open Full Calculator ➔',
                    mr: 'संपूर्ण कॅल्क्युलेटर उघडा ➔',
                    hi: 'पूरा कैलकुलेटर खोलें ➔',
                    te: 'పూర్తి కాలిక్యులేటర్ తెరవండి ➔',
                    kn: 'ಪೂರ್ಣ ಕ್ಯಾಲ್ಕುಲೇಟರ್ ತೆರೆಯಿರಿ ➔',
                    gu: 'સંપૂર્ણ કેલ્ક્યુલેટર ખોલો ➔',
                  ),
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
                              Expanded(
                                child: Text(
                                  eval.mandiName,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isWinner) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    AppStrings.tr(
                                      loc,
                                      en: '🏆 Top Profit',
                                      mr: '🏆 सर्वाधिक नफा',
                                      hi: '🏆 सर्वाधिक लाभ',
                                      te: '🏆 గరిష్ట లాభం',
                                      kn: '🏆 ಗರಿಷ್ಠ ಲಾಭ',
                                      gu: '🏆 મહત્તમ નફો',
                                    ),
                                    style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${eval.distanceKm} km • ${AppStrings.tr(loc, en: "Quoted Rate:", mr: "बाजार भाव:", hi: "मंडी भाव:", te: "మార్కెట్ రేటు:", kn: "ಮಾರುಕಟ್ಟೆ ದರ:", gu: "બજાર ભાવ:")} ₹${eval.quotedGrossRate.toStringAsFixed(0)}/Qtl',
                            style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
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
                          AppStrings.tr(loc, en: 'per Qtl', mr: 'प्रति क्विंटल', hi: 'प्रति क्विंटल', te: 'క్వింటాల్‌కు', kn: 'ಪ್ರತಿ ಕ್ವಿಂಟಾಲ್‌ಗೆ', gu: 'પ્રતિ ક્વિન્ટલ'),
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
    String loc,
  ) {
    final soil = soilVm.detectedSoil;
    final isMr = loc == 'mr';

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
                    AppStrings.get('localSoilTitle', locale: loc),
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
            '${AppStrings.tr(loc, en: "Location:", mr: "स्थान:", hi: "स्थान:", te: "ప్రాంతం:", kn: "ಸ್ಥಳ:", gu: "સ્થળ:")} ${soil.getLocation(!isMr)}',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
                        soil.getSoilName(!isMr),
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
                  '${AppStrings.tr(loc, en: "Organic Carbon:", mr: "सेंद्रिय कर्ब:", hi: "जैविक कार्बन:", te: "సేంద్రీయ కార్బన్:", kn: "ಸಾವಯವ ಇಂಗಾಲ:", gu: "જૈવિક કાર્બન:")} ${soil.getOrganicCarbon(!isMr)} • ${AppStrings.tr(loc, en: "Moisture Retention:", mr: "ओलावा धारणा:", hi: "नमी धारण:", te: "తేమ నిలుపుదల:", kn: "ತೇವಾಂಶ ಧಾರಣೆ:", gu: "ભೇજ સંગ્રહ:")} ${soil.getWaterRetention(!isMr)}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Recommended Suitable Crops
          Text(
            AppStrings.tr(
              loc,
              en: 'Recommended Suitable Crops for this Soil:',
              mr: 'या जमिनीसाठी सर्वाधिक अनुकूल पिके (Suitable Crops):',
              hi: 'इस मिट्टी के लिए उपयुक्त अनुशंसित फसलें:',
              te: 'ఈ నేలకు సిఫార్సు చేయబడిన అనుకూల పంటలు:',
              kn: 'ಈ ಮಣ್ಣಿಗೆ ಶಿಫಾರಸು ಮಾಡಲಾದ ಸೂಕ್ತ ಬೆಳೆಗಳು:',
              gu: 'આ જમીન માટે ભલામણ કરેલ યોગ્ય પાક:',
            ),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: soil.suitableCrops.map((crop) {
                return Container(
                  width: 165,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              crop.getName(!isMr),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        crop.getYield(!isMr),
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: AppColors.primary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      SizedBox(
                        height: 28,
                        child: Text(
                          crop.getReason(!isMr),
                          style: const TextStyle(fontSize: 9.5, color: AppColors.textMuted, height: 1.25),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                    soil.getTip(!isMr),
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
  Widget _buildMyCropsForecastSection(BuildContext context, SoilViewModel soilVm, String loc) {
    final tracker = soilVm.cropTracker;
    final forecast = soilVm.priceForecast;
    final isMr = loc == 'mr';

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
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.auto_graph_rounded, color: Colors.deepPurple, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        AppStrings.get('myCropsForecastTitle', locale: loc),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _showEditCropTrackerDialog(context, soilVm, loc),
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
                        AppStrings.tr(loc, en: 'Edit', mr: 'बदला', hi: 'बदलें', te: 'సవరించు', kn: 'ಬದಲಾಯಿಸಿ', gu: 'બદલો'),
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
                        AppStrings.get('standingCrop', locale: loc),
                        style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                      ),
                      Text(
                        tracker.getGrowingCrop(!isMr),
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
                        AppStrings.get('storedStock', locale: loc),
                        style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                      ),
                      Text(
                        '${tracker.storedStockQuintals.toStringAsFixed(0)} ${AppStrings.tr(loc, en: "Qtl", mr: "क्विंटल", hi: "क्विंटल", te: "క్వింటాళ్ళు", kn: "ಕ್ವಿಂಟಾಲ್", gu: "ક્વિન્ટલ")}',
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
                    Expanded(
                      child: Text(
                        forecast.getVerdictBadge(!isMr),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          color: forecast.shouldHold ? AppColors.primary : AppColors.danger,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${forecast.confidencePercent}% ${AppStrings.tr(loc, en: "Accuracy", mr: "अचूकता", hi: "सटीकता", te: "ఖచ్చితత్వం", kn: "ನಿಖರತೆ", gu: "ચોકસાઈ")}',
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.get('todayPrice', locale: loc), style: const TextStyle(fontSize: 10, color: AppColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(
                            '₹${forecast.currentPrice.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        forecast.shouldHold ? Icons.trending_up : Icons.trending_down,
                        color: forecast.shouldHold ? Colors.green : Colors.red,
                        size: 26,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${AppStrings.get("projectedPrice", locale: loc)} (${forecast.daysAhead} ${AppStrings.tr(loc, en: "days", mr: "दिवस", hi: "दिन", te: "రోజులు", kn: "ದಿನಗಳು", gu: "દિવસ")})',
                            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                          Text(
                            '₹${forecast.predictedPrice.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: forecast.shouldHold ? AppColors.primary : Colors.red.shade700,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
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
                        AppStrings.tr(
                          loc,
                          en: '💰 Holding Stock Net Gain: +₹${forecast.potentialExtraProfit.toStringAsFixed(0)} Extra',
                          mr: '💰 साठवून ठेवल्यास संभाव्य नफा: +₹${forecast.potentialExtraProfit.toStringAsFixed(0)} अतिरिक्त',
                          hi: '💰 रोककर रखने पर संभावित शुद्ध लाभ: +₹${forecast.potentialExtraProfit.toStringAsFixed(0)} अतिरिक्त',
                          te: '💰 నిల్వ ఉంచితే అదనపు లాభం: +₹${forecast.potentialExtraProfit.toStringAsFixed(0)}',
                          kn: '💰 ದಾಸ್ತಾನು ಇಟ್ಟರೆ ಹೆಚ್ಚುವರಿ ಲಾಭ: +₹${forecast.potentialExtraProfit.toStringAsFixed(0)}',
                          gu: '💰 સ્ટોક રાખવાથી વધારાનો નફો: +₹${forecast.potentialExtraProfit.toStringAsFixed(0)}',
                        ),
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
                  forecast.getAdvisory(!isMr),
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),

                // Button to open dedicated AI Price Forecast Page
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AiPriceForecastView(
                          initialCrop: tracker.growingCrop,
                          initialQuantity: tracker.storedStockQuintals,
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.deepPurple.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.insights_rounded, color: Colors.deepPurple, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          AppStrings.tr(
                            loc,
                            en: 'Open Full AI Price Forecast & Crop Analyzer ➔',
                            mr: 'सविस्तर AI भाव भाकीत कॅल्क्युलेटर उघडा ➔',
                            hi: 'विस्तृत AI मूल्य पूर्वानुमान व विश्लेषण देखें ➔',
                            te: 'పూర్తి AI ధరల అంచనా తెరవండి ➔',
                            kn: 'ಸಂಪೂರ್ಣ AI ಬೆಲೆ ಮುನ್ಸೂಚನೆ ತೆರೆಯಿರಿ ➔',
                            gu: 'સંપૂર્ણ AI ભાવ અનુમાન કેલ્ક્યુલેટર ખોલો ➔',
                          ),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    ? AppStrings.tr(loc, en: 'Safe to spray. Low wind and zero wash-off risk predicted.', mr: 'फवारणीसाठी सुरक्षित हवामान. वारा शांत व पावसाचा धोका नाही.', hi: 'छिड़काव के लिए सुरक्षित मौसम। कम हवा और बारिश का कोई खतरा नहीं।', te: 'స్ప్రే చేయడానికి అనుకూలమైన వాతావరణం.', kn: 'ಸಿಂಪಡಿಸಲು ಸುರಕ್ಷಿತ ವಾತಾವರಣ.', gu: 'છંટકાવ માટે સુરક્ષિત હવામાન.')
                    : AppStrings.tr(loc, en: 'DO NOT SPRAY: Rain wash-off or high wind drift detected.', mr: 'आत्ता फवारणी करू नका: पाऊस किंवा जोरदार वाऱ्याचा धोका आहे.', hi: 'अभी छिड़काव न करें: बारिश या तेज हवा का जोखिम है।', te: 'ఇప్పుడు స్ప్రే చేయవద్దు: వర్షం లేదా గాలి ప్రమాదం ఉంది.', kn: 'ಈಗ ಸಿಂಪಡಿಸಬೇಡಿ: ಮಳೆ ಅಥವಾ ಬಲವಾದ ಗಾಳಿಯ ಅಪಾಯವಿದೆ.', gu: 'હમણાં છંટકાવ ન કરો: વરસાદ અથવા ભારે પવનનું જોખમ છે.')),
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // --- 6. QUICK ACTIONS GRID ---
  Widget _buildQuickActionsGrid(BuildContext context, AuthViewModel authVm, String loc) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.38,
      children: [
        _buildActionTile(
          context,
          icon: Icons.account_balance_rounded,
          color: Colors.purple.shade700,
          title: AppStrings.get('govtSchemes', locale: loc),
          subtitle: AppStrings.tr(loc, en: 'Solar Pump & Drip Subsidy', mr: 'सौर पंप, ठिबक व विमा', hi: 'सोलर पंप एवं ड्रिप सब्सिडी', te: 'సోలార్ పంప్ & డ్రిప్ సబ్సిడీ', kn: 'ಸೌರ ಪಂಪ್ ಮತ್ತು ಹನಿ ನೀರಾವರಿ ಸಬ್ಸಿಡಿ', gu: 'સોલર પંપ અને ટપક સબસિડી'),
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
          title: AppStrings.get('farmKhata', locale: loc),
          subtitle: AppStrings.tr(loc, en: 'Crop Expenses & P&L', mr: 'खर्च, विक्री व ROI', hi: 'खर्च, बिक्री एवं मुनाफा', te: 'ఖర్చులు, అమ్మకాలు & లాభం', kn: 'ವೆಚ್ಚಗಳು, ಮಾರಾಟ ಮತ್ತು ಲಾಭ', gu: 'ખર્ચ, વેચાણ અને નફો'),
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
          title: AppStrings.get('intercropping', locale: loc),
          subtitle: AppStrings.tr(loc, en: 'Row Pattern & Yield', mr: '४:२ प्रमाण व खत बचत', hi: '४:२ पंक्ति अनुपात एवं खाद बचत', te: 'వరుసల విధానం & దిగుబడి', kn: 'ಸಾಲು ಮಾದರಿ ಮತ್ತು ಇಳುವರಿ', gu: 'રો પદ્ધતિ અને ઉપજ'),
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
          title: AppStrings.get('soilAdvisory', locale: loc),
          subtitle: AppStrings.tr(loc, en: 'ICAR Fertilizer Dosage', mr: 'ICAR खत मात्रा', hi: 'ICAR खाद मात्रा', te: 'ICAR ఎరువుల మోతాదు', kn: 'ICAR ರಸಗೊಬ್ಬರ ಪ್ರಮಾಣ', gu: 'ICAR ખાતર માત્રા'),
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
          title: AppStrings.get('agriStore', locale: loc),
          subtitle: AppStrings.tr(loc, en: 'Fertilizers & Direct Seeds', mr: 'खते, बियाणे, औषधे', hi: 'खाद, बीज एवं कीटनाशक', te: 'ఎరువులు, విత్తనాలు & మందులు', kn: 'ಗೊಬ್ಬರ, ಬೀಜಗಳು ಮತ್ತು ಔಷಧಗಳು', gu: 'ખાતર, બિયારણ અને દવાઓ'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StoreView()),
            );
          },
        ),
        _buildActionTile(
          context,
          icon: Icons.auto_graph_rounded,
          color: Colors.deepPurple,
          title: AppStrings.tr(
            loc,
            en: 'AI Price Forecast',
            mr: 'AI भाव अंदाज',
            hi: 'AI मूल्य पूर्वानुमान',
            te: 'AI ధరల అంచనా',
            kn: 'AI ಬೆಲೆ ಮುನ್ಸೂಚನೆ',
            gu: 'AI ભાવ અનુમાન',
          ),
          subtitle: AppStrings.tr(
            loc,
            en: 'Hold vs. Sell Advisor',
            mr: 'साठवून ठेवा की विका?',
            hi: 'रोकें या बेचें? सटीक सलाह',
            te: 'నిల్వ ఉంచాలా లేదా అమ్మాలా?',
            kn: 'ಶೇಖರಿಸಿಡಬೇಕೇ ಅಥವಾ ಮಾರಬೇಕೇ?',
            gu: 'રાખો કે વેચો? સલાહકાર',
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AiPriceForecastView()),
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

  // --- 7. NAVIGATION DRAWER ---
  Widget _buildDrawer(BuildContext context, AuthViewModel authVm, String loc) {
    final user = authVm.currentUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF165B33), Color(0xFF10B981)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              user?.fullName ?? 'AgriPulse Farmer',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(
              '${user?.village ?? "Village"}, ${user?.district ?? "District"} • ${user?.landSizeAcres ?? 4.5} Acres',
              style: const TextStyle(fontSize: 12),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.agriculture_rounded, color: AppColors.primary, size: 36),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_rounded, color: AppColors.primary),
            title: Text(AppStrings.get('navProfile', locale: loc)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate_rounded, color: AppColors.primary),
            title: Text(AppStrings.get('calcTransportBtn', locale: loc)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MandiProfitCalculatorView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.auto_graph_rounded, color: Colors.deepPurple),
            title: Text(
              AppStrings.tr(
                loc,
                en: 'AI Price Forecast (Hold vs. Sell)',
                mr: 'AI भाव अंदाज (साठवून ठेवा की विका)',
                hi: 'AI मूल्य पूर्वानुमान (रोकें या बेचें)',
                te: 'AI ధరల అంచనా (నిల్వ లేదా అమ్మకం)',
                kn: 'AI ಬೆಲೆ ಮುನ್ಸೂಚನೆ (ಶೇಖರಿಸಿ ಅಥವಾ ಮಾರಿ)',
                gu: 'AI ભાવ અનુમાન (રાખો કે વેચો)',
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AiPriceForecastView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_rounded, color: Colors.purple),
            title: Text(AppStrings.get('govtSchemes', locale: loc)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SchemesView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF165B33)),
            title: Text(AppStrings.get('farmKhata', locale: loc)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FarmKhataView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.grass_rounded, color: Colors.amber),
            title: Text(AppStrings.get('intercropping', locale: loc)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const IntercroppingView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.science_outlined, color: Colors.teal),
            title: Text(AppStrings.get('soilAdvisory', locale: loc)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SoilAdvisoryView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined, color: Colors.indigo),
            title: Text(AppStrings.get('agriStore', locale: loc)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const StoreView()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language_rounded, color: Colors.blueGrey),
            title: Text(AppStrings.get('language', locale: loc)),
            trailing: Text(
              SupportedLanguages.findByCode(loc).nativeName,
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageSelectionView(isFirstTime: false)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.red),
            title: Text(AppStrings.get('logout', locale: loc), style: const TextStyle(color: Colors.red)),
            onTap: () async {
              Navigator.pop(context);
              await authVm.signOut();
            },
          ),
        ],
      ),
    );
  }
}
