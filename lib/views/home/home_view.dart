import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/supported_languages.dart';
import '../../models/mandi_model.dart';
import '../../models/soil_model.dart';
import '../../models/crop_tracker_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';
import '../../viewmodels/mandi_viewmodel.dart';
import '../../viewmodels/soil_viewmodel.dart';
import '../soil/soil_advisory_view.dart';
import '../store/store_view.dart';
import '../language/language_selection_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _customWeightController = TextEditingController();
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

  @override
  void dispose() {
    _customWeightController.dispose();
    _customStockController.dispose();
    super.dispose();
  }

  void _showMandiDetailSheet(BuildContext context, MandiEvaluation eval, MandiViewModel mandiVm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        eval.mandiName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      Text(
                        '${eval.distanceKm} km अंतर • ${eval.district ?? "APMC Yard"}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '₹${eval.quotedGrossRate.toStringAsFixed(0)} / Qtl',
                    style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary, fontSize: 14),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'खर्च व नफा तपशील (Expense & Realization Breakdown)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            _buildSheetRow('एकूण माल (Produce Weight)', '${mandiVm.weightQuintals.toStringAsFixed(0)} क्विंटल'),
            _buildSheetRow('बाजार भाव एकूण रक्कम (Gross Revenue)', '₹${eval.grossRevenue.toStringAsFixed(0)}'),
            _buildSheetRow('⛽ डिझेल खर्च (Roundtrip Fuel)', '-₹${eval.fuelCost.toStringAsFixed(0)}', isDeduction: true),
            _buildSheetRow('👷 हमाली व तोलाई (Loading Fee)', '-₹${eval.handlingFee.toStringAsFixed(0)}', isDeduction: true),
            _buildSheetRow('🏛️ कृषी उत्पन्न बाजार सेस (APMC Cess 1.05%)', '-₹${eval.cessFee.toStringAsFixed(0)}', isDeduction: true),
            _buildSheetRow('एकूण वाहतूक व बाजार खर्च', '-₹${eval.logisticsOverhead.toStringAsFixed(0)}', isDeduction: true),
            const Divider(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'हातात पडणारा निव्वळ नफा',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      Text(
                        'True In-Hand Net Cash',
                        style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${eval.netEarnings.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                      Text(
                        '₹${eval.effectiveNetRate.toStringAsFixed(0)} / क्विंटल निव्वळ',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.check, size: 18),
                label: const Text('समजले (Close)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSheetRow(String label, String value, {bool isDeduction = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDeduction ? Colors.red.shade700 : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditCropTrackerDialog(BuildContext context, SoilViewModel soilVm) {
    String currentCrop = soilVm.cropTracker.growingCrop;
    double currentStock = soilVm.cropTracker.storedStockQuintals;
    _customStockController.text = currentStock.toStringAsFixed(0);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.edit_note_rounded, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'पिके व साठा नोंदवा',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('सध्या शेतात उभे असलेले पीक:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
                  return DropdownMenuItem(
                    value: c,
                    child: Text(_commodityLabelsMr[c] ?? c),
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
              const Text('घरी / गोदामात शिल्लक साठा (क्विंटल):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              TextField(
                controller: _customStockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixText: 'क्विंटल',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('रद्द करा'),
            ),
            ElevatedButton(
              onPressed: () {
                final qty = double.tryParse(_customStockController.text.trim()) ?? 35.0;
                soilVm.updateCropTracker(
                  growingCrop: _commodityLabelsMr[currentCrop] ?? currentCrop,
                  storedStockQuintals: qty,
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✓ पिकांची माहिती व AI अंदाज अपडेट केला!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('सेव्ह करा'),
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
          const SizedBox(width: 8),
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
              _buildFarmerHeaderCard(context, authVm),
              const SizedBox(height: 14),

              // 2. CORE FEATURE 1: Nearby Mandis, Crop Selector & Quantity-First Net Profit Ranker
              _buildMandiCalculatorSection(context, mandiVm, loc),
              const SizedBox(height: 14),

              // 3. CORE FEATURE 2: GPS Location Soil Type & Recommended Suitable Crops
              _buildSoilDetectionSection(context, soilVm, authVm),
              const SizedBox(height: 14),

              // 4. CORE FEATURE 3: My Crops & AI Future Price Predictor (Hold vs Sell)
              _buildMyCropsForecastSection(context, soilVm),
              const SizedBox(height: 14),

              // 5. Hyperlocal Weather Spray Window Banner
              _buildWeatherSprayBanner(context, weatherVm, loc),
              const SizedBox(height: 14),

              // 6. Quick Agronomic Tools Navigation Grid
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- 1. FARMER HEADER CARD ---
  Widget _buildFarmerHeaderCard(BuildContext context, AuthViewModel authVm) {
    final user = authVm.currentUser;
    final name = user?.fullName ?? 'रमेश पाटील (शेतकरी)';
    final location = '${user?.village ?? "शिरोळ"}, ${user?.district ?? "कोल्हापूर"}';
    final acreage = user?.landSizeAcres ?? 4.5;

    return Container(
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
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primaryLight,
            child: const Icon(Icons.person, color: AppColors.primary, size: 26),
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
                      child: const Text(
                        '✓ सक्रिय शेतकरी',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '📍 $location • $acreage एकर शेतजमीन',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
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

    final bestNetMandi = mandiVm.bestMandi;

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
              const Row(
                children: [
                  Icon(Icons.storefront_rounded, color: AppColors.primary, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'नजीकच्या बाजारपेठा व नफा तुलना',
                    style: TextStyle(
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
          const Text(
            '१. पीक निवडा ➔ २. वजन टाका ➔ सर्व बाजारपेठांचा हातात पडणारा खरा नफा पाहा',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),

          // Step 1: Crop Selection Chips
          const Text(
            'पायरी १: पीक निवडा (Select Crop)',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _commodities.map((comm) {
                final isSelected = mandiVm.selectedCommodity == comm;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(
                      _commodityLabelsMr[comm] ?? comm,
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

          // Highlight Highest Quoted Rate Mandi
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
                          const TextSpan(text: 'या पिकासाठी सर्वोच्च भाव: '),
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

          // Step 2: Quantity First (वजन प्रथम टाका)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'पायरी २: शेतमालाचे वजन (Quantity)',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              Text(
                'सध्या: ${mandiVm.weightQuintals.toStringAsFixed(0)} क्विंटल',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [10, 25, 50, 100].map((q) {
              final isSel = mandiVm.weightQuintals == q.toDouble();
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: InkWell(
                    onTap: () => mandiVm.setWeight(q.toDouble()),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSel ? AppColors.primary : AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSel ? AppColors.primary : AppColors.cardBorder),
                      ),
                      child: Center(
                        child: Text(
                          '$q Qtl',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSel ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // Step 3: Transport Vehicle Selector
          const Text(
            'पायरी ३: वाहतूक वाहन (Transport Vehicle)',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: VehicleOption.options.map((v) {
                final isSelected = mandiVm.selectedVehicle == v.id;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: InkWell(
                    onTap: () => mandiVm.setVehicle(v.id),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryLight : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isSelected ? AppColors.primary : AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            v.id == 'tractor' ? Icons.agriculture : Icons.local_shipping_outlined,
                            size: 14,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            v.localizedName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          // Ranked Mandis List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'सर्व बाजारपेठा (खर्च वजा जाता खरा नफा):',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              if (mandiVm.isLoading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 8),

          ...mandiVm.rankings.asMap().entries.map((entry) {
            final idx = entry.key;
            final eval = entry.value;
            final isWinner = idx == 0;

            return InkWell(
              onTap: () => _showMandiDetailSheet(context, eval, mandiVm),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isWinner ? AppColors.successBg.withValues(alpha: 0.6) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isWinner ? AppColors.primary : AppColors.cardBorder,
                    width: isWinner ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    // Rank badge
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isWinner ? AppColors.primary : AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '#${idx + 1}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isWinner ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Mandi Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  eval.mandiName,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
                                  child: const Text(
                                    '🏆 सर्वाधिक नफा',
                                    style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${eval.distanceKm} km • बाजार भाव: ₹${eval.quotedGrossRate.toStringAsFixed(0)} • खर्च: -₹${eval.logisticsOverhead.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),

                    // Net In Hand Cash
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${eval.netEarnings.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: isWinner ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'हातात पडणारा नफा',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: isWinner ? AppColors.primary : AppColors.textMuted,
                          ),
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
              const Row(
                children: [
                  Icon(Icons.landscape_rounded, color: Colors.brown, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'स्थानिक माती प्रकार व योग्य पिके',
                    style: TextStyle(
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
            'स्थान: ${soil.locationTag}',
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
                        soil.soilTypeName,
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
                  'सेंद्रिय कर्ब: ${soil.organicCarbon} • ओलावा धारणा: ${soil.waterRetention}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Recommended Suitable Crops
          const Text(
            'या जमिनीसाठी सर्वाधिक अनुकूल पिके (Suitable Crops):',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
                              crop.cropName.split(' ').first,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        crop.yieldPotential,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.primary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        crop.reason,
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
                    soil.managementTip,
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
  Widget _buildMyCropsForecastSection(BuildContext context, SoilViewModel soilVm) {
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
              const Row(
                children: [
                  Icon(Icons.auto_graph_rounded, color: Colors.deepPurple, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'माझी पिके व AI बाजारभाव अंदाज',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _showEditCropTrackerDialog(context, soilVm),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.deepPurple.shade200),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.edit, size: 10, color: Colors.deepPurple),
                      SizedBox(width: 2),
                      Text(
                        'बदला',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.deepPurple),
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
                      const Text('सध्याचे पीक:', style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
                      Text(
                        tracker.growingCrop,
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
                      const Text('शिल्लक साठा (Stock):', style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
                      Text(
                        '${tracker.storedStockQuintals.toStringAsFixed(0)} क्विंटल',
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
                      forecast.verdictBadge,
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
                        '${forecast.confidencePercent}% अचूकता',
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
                        const Text('आजचा भाव', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
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
                        Text('भाकीत भाव (${forecast.daysAhead} दिवस)', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
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
                        '💰 साठवून ठेवल्यास संभाव्य नफा: +₹${forecast.potentialExtraProfit.toStringAsFixed(0)} अतिरिक्त',
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
                  forecast.advisoryText,
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
          title: authVm.isMr ? 'कृषी इनपुट स्टोअर' : 'Agri Store',
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
}
