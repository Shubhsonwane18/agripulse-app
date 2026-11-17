import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/mandi_model.dart';
import '../../services/mandi_directory_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/mandi_viewmodel.dart';
import '../forecast/ai_price_forecast_view.dart';

class MandiProfitCalculatorView extends StatefulWidget {
  final String? initialCommodity;

  const MandiProfitCalculatorView({super.key, this.initialCommodity});

  @override
  State<MandiProfitCalculatorView> createState() => _MandiProfitCalculatorViewState();
}

class _MandiProfitCalculatorViewState extends State<MandiProfitCalculatorView> {
  final TextEditingController _weightController = TextEditingController();
  String _selectedCategoryId = 'grains';

  @override
  void initState() {
    super.initState();
    final mandiVm = context.read<MandiViewModel>();
    final authVm = context.read<AuthViewModel>();

    // Pre-fill user's district from profile if available
    final user = authVm.currentUser;
    if (user != null && user.district != null && user.district!.isNotEmpty) {
      mandiVm.setCityByName(user.district!);
    }

    if (widget.initialCommodity != null) {
      mandiVm.setCommodity(widget.initialCommodity!);
      // Find category of initial commodity
      final match = MandiDirectoryService.crops.firstWhere(
        (c) => c.id.toLowerCase() == widget.initialCommodity!.toLowerCase(),
        orElse: () => MandiDirectoryService.crops.first,
      );
      _selectedCategoryId = match.categoryId;
    }

    _weightController.text = mandiVm.weightQuintals.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _onWeightChanged(double newWeight, MandiViewModel mandiVm) {
    mandiVm.setWeight(newWeight);
    _weightController.text = newWeight.toStringAsFixed(0);
  }

  void _showMandiDetailSheet(BuildContext context, MandiEvaluation eval, MandiViewModel mandiVm, String loc) {
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
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                      Text(
                        '${eval.distanceKm} km • ${eval.district ?? "APMC Yard"}',
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
            Text(
              {
                'mr': 'खर्च व निव्वळ नफा तपशील (Bill Breakdown)',
                'hi': 'खर्च एवं शुद्ध मुनाफा विवरण (Bill Breakdown)',
                'te': 'ఖర్చులు & నికర లాభం వివరాలు (Breakdown)',
                'kn': 'ವೆಚ್ಚ ಮತ್ತು ನಿವ್ವಳ ಲಾಭದ ವಿವರ (Breakdown)',
                'gu': 'ખર્ચ અને ચોખ્ખો નફો વિગત (Breakdown)',
              }[loc] ?? 'Net Realization & Expense Breakdown',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            _buildSheetRow(
              {
                'mr': 'एकूण माल (Produce Weight)',
                'hi': 'कुल माल (Produce Weight)',
                'te': 'మొత్తం దిగుబడి (Weight)',
                'kn': 'ಒಟ್ಟು ಬೆಳೆ ತೂಕ (Weight)',
                'gu': 'કુલ માલ (Weight)',
              }[loc] ?? 'Produce Weight',
              '${mandiVm.weightQuintals.toStringAsFixed(0)} Qtl',
            ),
            _buildSheetRow(
              {
                'mr': 'बाजार भाव एकूण रक्कम (Gross Revenue)',
                'hi': 'मंडी भाव कुल राशि (Gross Revenue)',
                'te': 'మొత్తం ఆదాయం (Gross Revenue)',
                'kn': 'ಒಟ್ಟು ಆದಾಯ (Gross Revenue)',
                'gu': 'કુલ રકમ (Gross Revenue)',
              }[loc] ?? 'Gross Revenue',
              '₹${eval.grossRevenue.toStringAsFixed(0)}',
            ),
            _buildSheetRow(
              {
                'mr': '⛽ डिझेल खर्च (Roundtrip Fuel)',
                'hi': '⛽ डीजल खर्च (Roundtrip Fuel)',
                'te': '⛽ డీజిల్ రవాణా ఖర్చు',
                'kn': '⛽ ಡೀಸೆಲ್ ಸಾರಿಗೆ ವೆಚ್ಚ',
                'gu': '⛽ ડીઝલ પરિવહન ખર્ચ',
              }[loc] ?? '⛽ Roundtrip Diesel Fuel',
              '-₹${eval.fuelCost.toStringAsFixed(0)}',
              isDeduction: true,
            ),
            _buildSheetRow(
              {
                'mr': '👷 हमाली व तोलाई (Loading Fee ₹25/Qtl)',
                'hi': '👷 हमाली एवं तुलाई (Loading Fee)',
                'te': '👷 కూలీ & బరువు ఖర్చు',
                'kn': '👷 ಕೂಲಿ ಮತ್ತು ತೂಕ ವೆಚ್ಚ',
                'gu': '👷 હમાલી અને તોલાઈ ખર્ચ',
              }[loc] ?? '👷 Loading & Labor Fee (₹25/Qtl)',
              '-₹${eval.handlingFee.toStringAsFixed(0)}',
              isDeduction: true,
            ),
            _buildSheetRow(
              {
                'mr': '🏛️ कृषी उत्पन्न बाजार सेस (APMC Cess 1.05%)',
                'hi': '🏛️ कृषि उपज मंडी सेस (APMC Cess 1.05%)',
                'te': '🏛️ మార్కెట్ సెస్ (APMC Cess 1.05%)',
                'kn': '🏛️ ಮಾರುಕಟ್ಟೆ ಸೆಸ್ (APMC Cess 1.05%)',
                'gu': '🏛️ બજાર સેસ (APMC Cess 1.05%)',
              }[loc] ?? '🏛️ APMC Market Cess (1.05%)',
              '-₹${eval.cessFee.toStringAsFixed(0)}',
              isDeduction: true,
            ),
            _buildSheetRow(
              {
                'mr': 'एकूण वाहतूक व बाजार खर्च',
                'hi': 'कुल परिवहन व मंडी खर्च',
                'te': 'మొత్తం రవాణా ఖర్చులు',
                'kn': 'ಒಟ್ಟು ಸಾರಿಗೆ ವೆಚ್ಚ',
                'gu': 'કુલ પરિવહન ખર્ચ',
              }[loc] ?? 'Total Logistics Overhead',
              '-₹${eval.logisticsOverhead.toStringAsFixed(0)}',
              isDeduction: true,
            ),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        {
                          'mr': 'हातात पडणारा निव्वळ नफा',
                          'hi': 'हाथ में आने वाला शुद्ध लाभ',
                          'te': 'చేతికి అందే నికర లాభం',
                          'kn': 'ಕೈಗೆ ಸಿಗುವ ನಿವ್ವಳ ಲಾಭ',
                          'gu': 'હાથમાં આવતો ચોખ્ખો નફો',
                        }[loc] ?? 'True In-Hand Net Cash',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      Text(
                        '₹${eval.effectiveNetRate.toStringAsFixed(0)} / Qtl net rate',
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  Text(
                    '₹${eval.netEarnings.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary),
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
                label: Text(
                  {
                    'mr': 'समजले (Close)',
                    'hi': 'ठीक है (Close)',
                    'te': 'ముగించు (Close)',
                    'kn': 'ಸರಿ (Close)',
                    'gu': 'સમજાઈ ગયું (Close)',
                  }[loc] ?? 'Close',
                ),
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
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
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

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final mandiVm = context.watch<MandiViewModel>();
    final loc = authVm.locale;

    final vehicles = [
      {'id': 'three_wheeler', 'label': '🛺 Auto (18 km/L)', 'range': '< 10 Qtl'},
      {'id': 'tata_ace', 'label': '🚚 Tata Ace (11 km/L)', 'range': '10-25 Qtl'},
      {'id': 'pickup_407', 'label': '🚛 Pickup/407 (8.5 km/L)', 'range': '25-60 Qtl'},
      {'id': 'tractor', 'label': '🚜 Tractor (5 km/L)', 'range': '> 60 Qtl'},
    ];

    final activeVehicle = vehicles.firstWhere(
      (v) => v['id'] == mandiVm.selectedVehicle,
      orElse: () => vehicles[1],
    );

    final winner = mandiVm.bestMandi;
    final filteredCrops = MandiDirectoryService.crops.where((c) => c.categoryId == _selectedCategoryId).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          {
            'mr': 'वाहतूक खर्च व निव्वळ नफा कॅल्क्युलेटर',
            'hi': 'परिवहन खर्च एवं मंडी शुद्ध लाभ कैलकुलेटर',
            'te': 'రవాణా ఖర్చు & నికర లాభ లెక్కింపు',
            'kn': 'ಸಾರಿಗೆ ವೆಚ್ಚ ಮತ್ತು ನಿವ್ವಳ ಲಾಭ ಲೆಕ್ಕಾಚಾರ',
            'gu': 'પરિવહન ખર્ચ અને બજાર ચોખ્ખો નફો કેલ્ક્યુલેટર',
          }[loc] ?? 'Mandi Profit & Transport Calculator',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // STEP 1: SELECT FARMER'S STATE
            // ==========================================
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: const [
                  BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
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
                            const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 20),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                AppStrings.tr(
                                  loc,
                                  en: 'Step 1: Select Your State',
                                  mr: 'पायरी १: आपले राज्य निवडा (State)',
                                  hi: 'चरण १: अपना राज्य चुनें (State)',
                                  te: 'దశ 1: మీ రాష్ట్రాన్ని ఎంచుకోండి (State)',
                                  kn: 'ಹಂತ 1: ನಿಮ್ಮ ರಾಜ್ಯವನ್ನು ಆಯ್ಕೆಮಾಡಿ (State)',
                                  gu: 'પગલું 1: તમારું રાજ્ય પસંદ કરો (State)',
                                ),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
                          mandiVm.selectedState.getName(loc),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppStrings.tr(
                      loc,
                      en: 'Choose your state to see local districts & nearby APMCs:',
                      mr: 'जिल्हे व बाजारपेठा पाहण्यासाठी आपले राज्य निवडा:',
                      hi: 'जिले और नजदीकी मंडियां देखने के लिए अपना राज्य चुनें:',
                      te: 'స్థానిక జిల్లాలు & మార్కెట్లను చూడటానికి మీ రాష్ట్రాన్ని ఎంచుకోండి:',
                      kn: 'ಸ್ಥಳೀಯ ಜಿಲ್ಲೆಗಳು ಮತ್ತು ಮಾರುಕಟ್ಟೆಗಳನ್ನು ನೋಡಲು ನಿಮ್ಮ ರಾಜ್ಯವನ್ನು ಆಯ್ಕೆಮಾಡಿ:',
                      gu: 'જિલ્લાઓ અને નજીકના બજારો જોવા માટે તમારું રાજ્ય પસંદ કરો:',
                    ),
                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<StateLocation>(
                    key: ValueKey('state_${mandiVm.selectedState.id}'),
                    initialValue: mandiVm.selectedState,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.map_rounded, color: AppColors.primary, size: 20),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: mandiVm.states.map((st) {
                      return DropdownMenuItem(
                        value: st,
                        child: Text(st.getName(loc)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        mandiVm.setStateLocation(val);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ==========================================
            // STEP 2: SELECT FARMER'S PRIMARY CITY
            // ==========================================
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: const [
                  BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
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
                            const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 20),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                AppStrings.tr(
                                  loc,
                                  en: 'Step 2: Select City / District',
                                  mr: 'पायरी २: आपले शहर / जिल्हा निवडा (City)',
                                  hi: 'चरण २: अपना शहर / जिला चुनें (City)',
                                  te: 'దశ 2: మీ నగరం / జిల్లాను ఎంచుకోండి (City)',
                                  kn: 'ಹಂತ 2: ನಿಮ್ಮ ನಗರ / ಜಿಲ್ಲೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ (City)',
                                  gu: 'પગલું 2: તમારું શહેર / જિલ્લો પસંદ કરો (City)',
                                ),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
                          mandiVm.selectedCity.getName(loc),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppStrings.tr(
                      loc,
                      en: 'Accurate road distances to wholesale APMCs are calculated from here:',
                      mr: 'या शहरापासून सर्व बाजारपेठांचे अचूक रोड अंतर (km) मोजले जाईल:',
                      hi: 'इस शहर से सभी मंडियों की सटीक सड़क दूरी (km) मापी जाएगी:',
                      te: 'ఈ నగరం ఆధారంగా ఖచ్చితమైన రహదారి దూరం (km) లెಕ್ಕించబడుతుంది:',
                      kn: 'ಈ ನಗರದಿಂದ ಎಲ್ಲಾ ಮಾರುಕಟ್ಟೆಗಳ ನಿಖರ ರಸ್ತೆ ದೂರವನ್ನು (km) ಲೆಕ್ಕಿಸಲಾಗುತ್ತದೆ:',
                      gu: 'આ શહેરથી બધી બજારોનું સચોટ અંતર (km) ગણવામાં આવશે:',
                    ),
                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<CityLocation>(
                    key: ValueKey('city_${mandiVm.selectedState.id}_${mandiVm.selectedCity.id}'),
                    initialValue: mandiVm.selectedCity,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_city_rounded, color: AppColors.primary, size: 20),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: mandiVm.citiesForSelectedState.map((city) {
                      return DropdownMenuItem(
                        value: city,
                        child: Text(city.getName(loc)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        mandiVm.setCity(val);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ==========================================
            // STEP 3: CATEGORY & CROP SELECTOR
            // ==========================================
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                      const Icon(Icons.category_rounded, color: AppColors.primary, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        AppStrings.tr(
                          loc,
                          en: 'Step 3: Select Crop Category & Crop',
                          mr: 'पायरी ३: पिकाचा वर्ग व पीक निवडा (Select Crop)',
                          hi: 'चरण ३: फसल की श्रेणी व फसल चुनें (Select Crop)',
                          te: 'దశ 3: పంట వర్గం మరియు పంటను ఎంచుకోండి',
                          kn: 'ಹಂತ 3: ಬೆಳೆ ವರ್ಗ ಮತ್ತು ಬೆಳೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ',
                          gu: 'પગલું 3: પાકની શ્રેણી અને પાક પસંદ કરો',
                        ),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Category Selection Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: MandiDirectoryService.categories.map((cat) {
                        final isSel = _selectedCategoryId == cat.id;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(cat.getName(loc)),
                            selected: isSel,
                            selectedColor: AppColors.primary,
                            backgroundColor: AppColors.background,
                            showCheckmark: false,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            labelStyle: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSel ? Colors.white : AppColors.textPrimary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(
                                color: isSel ? AppColors.primary : AppColors.cardBorder,
                              ),
                            ),
                            onSelected: (val) {
                              if (val) {
                                setState(() {
                                  _selectedCategoryId = cat.id;
                                  final newCrops = MandiDirectoryService.crops.where((c) => c.categoryId == cat.id);
                                  if (newCrops.isNotEmpty) {
                                    mandiVm.setCommodity(newCrops.first.id);
                                  }
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Crops in this category
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: filteredCrops.map((crop) {
                      final isSelected = mandiVm.selectedCommodity.toLowerCase() == crop.id.toLowerCase();
                      return ChoiceChip(
                        label: Text(crop.getName(loc)),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.background,
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        labelStyle: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.cardBorder,
                          ),
                        ),
                        onSelected: (val) {
                          if (val) mandiVm.setCommodity(crop.id);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ==========================================
            // STEP 4: QUANTITY & AUTO VEHICLE SELECTION
            // ==========================================
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: const [
                  BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
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
                            const Icon(Icons.scale_rounded, color: AppColors.primary, size: 20),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                AppStrings.tr(
                                  loc,
                                  en: 'Step 4: Enter Harvest Quantity (Quintals)',
                                  mr: 'पायरी ४: शेतमालाचे वजन (Quantity)',
                                  hi: 'चरण ४: उपज की मात्रा (Quantity)',
                                  te: 'దశ 4: దిగుబడి పరిమాణం (క్వింటాళ్ళు)',
                                  kn: 'ಹಂತ 4: ಬೆಳೆ ತೂಕ (ಕ್ವಿಂಟಾಲ್)',
                                  gu: 'પગલું 4: ઉપજનું વજન (ક્વિન્ટલ)',
                                ),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
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
                          '${mandiVm.weightQuintals.toStringAsFixed(0)} Qtl',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Quick Quantity Chips
                  Row(
                    children: [10, 25, 50, 100, 200].map((q) {
                      final isSel = mandiVm.weightQuintals == q.toDouble();
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: InkWell(
                            onTap: () => _onWeightChanged(q.toDouble(), mandiVm),
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
                                  '$q Q',
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

                  // Custom Weight Input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            suffixText: 'Quintals (Qtl)',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final val = double.tryParse(_weightController.text.trim());
                          if (val != null && val > 0) {
                            _onWeightChanged(val, mandiVm);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          {
                            'mr': 'अपडेट',
                            'hi': 'अपडेट',
                            'te': 'అప్‌డేట్',
                            'kn': 'ಅಪ್‌ಡೇಟ್',
                            'gu': 'અપડેટ',
                          }[loc] ?? 'Update',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Auto-selected vehicle highlight banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: Colors.amber, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              {
                                'mr': 'वजनानुसार आपोआप निवडलेले वाहन:',
                                'hi': 'मात्रा के अनुसार स्वतः चयनित वाहन:',
                                'te': 'బరువు ఆధారంగా స్వయంచాలక ఎంపిక చేసిన వాహనం:',
                                'kn': 'ತೂಕದ ಆಧಾರದ ಮೇಲೆ ಸ್ವಯಂ ಆಯ್ಕೆಯಾದ ವಾಹನ:',
                                'gu': 'વજન મુજબ આપમેળે પસંદ થયેલ વાહન:',
                              }[loc] ?? 'Auto-Selected Transport Vehicle:',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${activeVehicle['label']} (${activeVehicle['range']})',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                        ),
                        Text(
                          {
                            'mr': '${mandiVm.weightQuintals.toStringAsFixed(0)} क्विंटल मालासाठी सर्वात फायदेशीर वाहन निवडले आहे.',
                            'hi': '${mandiVm.weightQuintals.toStringAsFixed(0)} क्विंटल उपज के लिए सबसे किफायती वाहन चुना गया है।',
                            'te': '${mandiVm.weightQuintals.toStringAsFixed(0)} క్వింటాళ్ళ కోసం అత్యంత పొదుపైన రవాణా ఎంపిక చేయబడింది.',
                            'kn': '${mandiVm.weightQuintals.toStringAsFixed(0)} ಕ್ವಿಂಟಾಲ್ ಬೆಳೆಗೆ ಕಡಿಮೆ ವೆಚ್ಚದ ಸಾರಿಗೆ ಆಯ್ಕೆಮಾಡಲಾಗಿದೆ.',
                            'gu': '${mandiVm.weightQuintals.toStringAsFixed(0)} ક્વિન્ટલ માલ માટે સૌથી કિફાયતી વાહન પસંદ થયેલ છે.',
                          }[loc] ?? 'Optimally selected based on ${mandiVm.weightQuintals.toStringAsFixed(0)} Qtl capacity to minimize fuel cost.',
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Manual Vehicle Override Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: vehicles.map((v) {
                        final isSel = mandiVm.selectedVehicle == v['id'];
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: ChoiceChip(
                            label: Text(v['label']!),
                            selected: isSel,
                            selectedColor: AppColors.primary,
                            backgroundColor: Colors.white,
                            showCheckmark: false,
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            labelStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSel ? Colors.white : AppColors.textPrimary,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: isSel ? AppColors.primary : AppColors.cardBorder),
                            ),
                            onSelected: (_) => mandiVm.setVehicle(v['id']!),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ==========================================
            // STEP 5: OUTPUT REALIZATION & WINNER MANDI (ANSWER)
            // ==========================================
            Row(
              children: [
                const Icon(Icons.stars_rounded, color: Colors.amber, size: 22),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    AppStrings.tr(
                      loc,
                      en: 'Step 5: Highest In-Hand Profit Mandi (Answer)',
                      mr: 'पायरी ५: सर्वाधिक हातात उरणारा निव्वळ नफा (निकाल)',
                      hi: 'चरण ५: सर्वाधिक शुद्ध लाभ देने वाली मंडी (उत्तर)',
                      te: 'దశ 5: అత్యధిక నికర లాభం కలిగిన మార్కెట్ (సమాధానం)',
                      kn: 'ಹಂತ 5: ಅತಿ ಹೆಚ್ಚು ನಿವ್ವಳ ಲಾಭದ ಮಾರುಕಟ್ಟೆ (ಉತ್ತರ)',
                      gu: 'પગલું 5: સૌથી વધુ ચોખ્ખો નફો આપતી બજાર (જવાબ)',
                    ),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (winner != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF165B33), Color(0xFF10B981)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            {
                              'mr': '🏆 सर्वाधिक हातात पडणारा निव्वळ नफा',
                              'hi': '🏆 सर्वाधिक हाथ में आने वाला शुद्ध लाभ',
                              'te': '🏆 అత్యధిక చేతికి వచ్చే నికర లాభం',
                              'kn': '🏆 ಅತಿ ಹೆಚ್ಚು ಕೈಗೆ ಸಿಗುವ ನಿವ್ವಳ ಲಾಭ',
                              'gu': '🏆 સૌથી વધુ હાથમાં આવતો ચોખ્ખો નફો',
                            }[loc] ?? '🏆 HIGHEST NET IN-HAND PROFIT',
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 10, color: Colors.black87),
                          ),
                        ),
                        Text(
                          '${winner.distanceKm} km',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      winner.mandiName,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      '${winner.district ?? mandiVm.selectedCity.nameEn} • ${mandiVm.weightQuintals.toStringAsFixed(0)} Qtl Load',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              {
                                'mr': 'खर्च वजा जाता हातात पडणारा खरा नफा:',
                                'hi': 'खर्च घटाकर हाथ में आने वाली शुद्ध रकम:',
                                'te': 'చేతికి వచ్చే నికర నగదు:',
                                'kn': 'ಕೈಗೆ ಸಿಗುವ ನೈಜ ಲಾಭ:',
                                'gu': 'ખર્ચ બાદ કરતાં હાથમાં આવતી ચોખ્ખી રકમ:',
                              }[loc] ?? 'True In-Hand Net Cash:',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 10),
                            ),
                            Text(
                              '₹${winner.netEarnings.toStringAsFixed(0)}',
                              style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showMandiDetailSheet(context, winner, mandiVm, loc),
                          icon: const Icon(Icons.receipt_long, size: 16),
                          label: Text(
                            {
                              'mr': 'पावती / हिशोब',
                              'hi': 'रसीद / हिसाब',
                              'te': 'బిల్లు చూడండి',
                              'kn': 'ಬಿಲ್ ನೋಡಿ',
                              'gu': 'હિસાબ જુઓ',
                            }[loc] ?? 'View Bill',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // AI Price Forecast Hold vs Sell Shortcut Banner
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AiPriceForecastView(
                        initialCrop: mandiVm.selectedCommodity,
                        initialQuantity: mandiVm.weightQuintals,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.deepPurple.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_graph_rounded, color: Colors.deepPurple, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.tr(
                                loc,
                                en: 'AI Price Forecast: Hold vs. Sell?',
                                mr: 'AI भाव अंदाज: साठवून ठेवावे की विकावे?',
                                hi: 'AI मूल्य पूर्वानुमान: रखें या बेचें?',
                                te: 'AI ధర అంచనా: నిల్వ చేయాలా లేదా అమ్మాలా?',
                                kn: 'AI ಬೆಲೆ ಮುನ್ಸೂಚನೆ: ಶೇಖರಿಸಿಡಬೇಕೇ ಅಥವಾ ಮಾರಬೇಕೇ?',
                                gu: 'AI ભાવ અનુમાન: રાખો કે વેચો?',
                              ),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                            ),
                            Text(
                              AppStrings.tr(
                                loc,
                                en: 'Check if ${mandiVm.selectedCommodity} price will rise or drop in 15-30 days ➔',
                                mr: 'पुढील १५-३० दिवसांत या पिकाचा भाव वाढेल की घसरेल? अंदाज पहा ➔',
                                hi: 'जानें क्या अगले 15-30 दिनों में भाव बढ़ेगा या गिरेगा ➔',
                                te: 'రాబోయే 15-30 రోజుల్లో ధర పెరుగుతుందా లేదా తగ్గుతుందా చూడండి ➔',
                                kn: 'ಮುಂದಿನ 15-30 ದಿನಗಳಲ್ಲಿ ಬೆಲೆ ಹೆಚ್ಚಾಗುವುದೇ ಅಥವಾ ಕುಸಿಯುವುದೇ ನೋಡಿ ➔',
                                gu: 'આગામી 15-30 દિવસમાં ભાવ વધશે કે ઘટશે તે જુઓ ➔',
                              ),
                              style: TextStyle(fontSize: 10, color: Colors.deepPurple.shade700),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.deepPurple),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Ranked Mandis List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  {
                    'mr': 'सर्व बाजारपेठा (खऱ्या नफ्यानुसार क्रमवारी):',
                    'hi': 'सभी मंडियां (शुद्ध मुनाफे के अनुसार रैंक):',
                    'te': 'అన్ని మార్కెట్లు (నికర లాభం ర్యాంకింగ్):',
                    'kn': 'ಎಲ್ಲಾ ಮಾರುಕಟ್ಟೆಗಳು (ನಿವ್ವಳ ಲಾಭದ ರ್ಯಾಂಕಿಂಗ್):',
                    'gu': 'બધી બજારો (ચોખ્ખા નફા અનુસાર રેન્ક):',
                  }[loc] ?? 'All Mandis Ranked by True Profit:',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text(
                  '${mandiVm.rankings.length} Mandis',
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Ranked List
            ...mandiVm.rankings.asMap().entries.map((entry) {
              final idx = entry.key;
              final eval = entry.value;
              final isWinner = idx == 0;

              return InkWell(
                onTap: () => _showMandiDetailSheet(context, eval, mandiVm, loc),
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eval.mandiName,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${eval.distanceKm} km • Quoted: ₹${eval.quotedGrossRate.toStringAsFixed(0)}/Qtl',
                              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ),
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
                            {
                              'mr': 'हातात पडणारा नफा',
                              'hi': 'हाथ में शुद्ध लाभ',
                              'te': 'నికర లాభం',
                              'kn': 'ನಿವ್ವಳ ಲಾಭ',
                              'gu': 'ચોખ્ખો નફો',
                            }[loc] ?? 'Net in Hand',
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
