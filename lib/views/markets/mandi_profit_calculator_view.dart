import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/mandi_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/mandi_viewmodel.dart';

class MandiProfitCalculatorView extends StatefulWidget {
  final String? initialCommodity;

  const MandiProfitCalculatorView({super.key, this.initialCommodity});

  @override
  State<MandiProfitCalculatorView> createState() => _MandiProfitCalculatorViewState();
}

class _MandiProfitCalculatorViewState extends State<MandiProfitCalculatorView> {
  final TextEditingController _weightController = TextEditingController();

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
  void initState() {
    super.initState();
    final mandiVm = context.read<MandiViewModel>();
    if (widget.initialCommodity != null) {
      mandiVm.setCommodity(widget.initialCommodity!);
    }
    _weightController.text = mandiVm.weightQuintals.toStringAsFixed(0);
    _autoSelectVehicle(mandiVm.weightQuintals, mandiVm);
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  // Automatic Vehicle Selection based on Produce Quantity
  String _autoSelectVehicle(double q, MandiViewModel mandiVm) {
    String autoVehicleId;
    if (q <= 10) {
      autoVehicleId = 'three_wheeler';
    } else if (q <= 25) {
      autoVehicleId = 'tata_ace';
    } else if (q <= 60) {
      autoVehicleId = 'pickup_407';
    } else {
      autoVehicleId = 'tractor';
    }
    mandiVm.setVehicle(autoVehicleId);
    return autoVehicleId;
  }

  void _onWeightChanged(double newWeight, MandiViewModel mandiVm) {
    mandiVm.setWeight(newWeight);
    _weightController.text = newWeight.toStringAsFixed(0);
    _autoSelectVehicle(newWeight, mandiVm);
  }

  void _showMandiDetailSheet(BuildContext context, MandiEvaluation eval, MandiViewModel mandiVm, bool isEn) {
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
                        '${eval.distanceKm} km ${isEn ? "distance" : "अंतर"} • ${eval.district ?? "APMC Yard"}',
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
              isEn ? 'Net Realization & Expense Breakdown' : 'खर्च व निव्वळ नफा तपशील (Breakdown)',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            _buildSheetRow(isEn ? 'Produce Weight' : 'एकूण माल (Produce Weight)', '${mandiVm.weightQuintals.toStringAsFixed(0)} ${isEn ? "Quintals" : "क्विंटल"}'),
            _buildSheetRow(isEn ? 'Gross Revenue' : 'बाजार भाव एकूण रक्कम (Gross Revenue)', '₹${eval.grossRevenue.toStringAsFixed(0)}'),
            _buildSheetRow(isEn ? '⛽ Fuel Expense (Roundtrip)' : '⛽ डिझेल खर्च (Roundtrip Fuel)', '-₹${eval.fuelCost.toStringAsFixed(0)}', isDeduction: true),
            _buildSheetRow(isEn ? '👷 Loading & Labor Fee' : '👷 हमाली व तोलाई (Loading Fee)', '-₹${eval.handlingFee.toStringAsFixed(0)}', isDeduction: true),
            _buildSheetRow(isEn ? '🏛️ APMC Market Cess (1.05%)' : '🏛️ कृषी उत्पन्न बाजार सेस (APMC Cess 1.05%)', '-₹${eval.cessFee.toStringAsFixed(0)}', isDeduction: true),
            _buildSheetRow(isEn ? 'Total Logistics Overhead' : 'एकूण वाहतूक व बाजार खर्च', '-₹${eval.logisticsOverhead.toStringAsFixed(0)}', isDeduction: true),
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
                        isEn ? 'True In-Hand Net Cash' : 'हातात पडणारा निव्वळ नफा',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      Text(
                        isEn ? 'Effective Rate: ₹${eval.effectiveNetRate.toStringAsFixed(0)}/Qtl' : 'निव्वळ दर: ₹${eval.effectiveNetRate.toStringAsFixed(0)}/क्विंटल',
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
              fontSize: 11,
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
    final isEn = authVm.isEn;

    final vehicles = [
      {'id': 'three_wheeler', 'label': isEn ? '🛺 Auto (18 km/L)' : '🛺 थ्री-व्हीलर (१८ किमी/लि)', 'range': '< 10 Qtl'},
      {'id': 'tata_ace', 'label': isEn ? '🚚 Tata Ace (11 km/L)' : '🚚 टाटा एस (११ किमी/लि)', 'range': '10-25 Qtl'},
      {'id': 'pickup_407', 'label': isEn ? '🚛 Pickup/407 (8.5 km/L)' : '🚛 पिकअप/४०७ (८.५ किमी/लि)', 'range': '25-60 Qtl'},
      {'id': 'tractor', 'label': isEn ? '🚜 Tractor (5 km/L)' : '🚜 ट्रॅक्टर (५ किमी/लि)', 'range': '> 60 Qtl'},
    ];

    final activeVehicle = vehicles.firstWhere(
      (v) => v['id'] == mandiVm.selectedVehicle,
      orElse: () => vehicles[1],
    );

    final bestNetMandi = mandiVm.bestMandi;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          isEn ? 'Mandi Profit & Transport Calculator' : 'बाजार नफा व गाडी खर्च गणक',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STEP 1: CROP SELECTOR
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.grass, color: AppColors.primary, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        isEn ? 'Step 1: Select Your Crop' : 'पायरी १: पीक निवडा (Select Crop)',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                              side: BorderSide(color: isSelected ? AppColors.primary : AppColors.cardBorder),
                            ),
                            onSelected: (selected) {
                              if (selected) mandiVm.setCommodity(comm);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // STEP 2: QUANTITY FIRST & AUTO-VEHICLE SELECTION
            Container(
              padding: const EdgeInsets.all(16),
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
                      Row(
                        children: [
                          const Icon(Icons.scale, color: AppColors.primary, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            isEn ? 'Step 2: Enter Harvest Quantity' : 'पायरी २: माल वजन टाका (Quantity First)',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${mandiVm.weightQuintals.toStringAsFixed(0)} ${isEn ? "Qtl" : "क्विंटल"}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Quick Quantity Chips
                  Row(
                    children: [10, 25, 50, 100, 200].map((q) {
                      final isSel = mandiVm.weightQuintals == q.toDouble();
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: InkWell(
                            onTap: () => _onWeightChanged(q.toDouble(), mandiVm),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isSel ? AppColors.primary : AppColors.background,
                                borderRadius: BorderRadius.circular(10),
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

                  // Custom Weight Text Field
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: isEn ? 'Enter custom quintals' : 'इतर वजन टाका',
                            suffixText: isEn ? 'Quintals (Qtl)' : 'क्विंटल (Qtl)',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onSubmitted: (val) {
                            final w = double.tryParse(val.trim());
                            if (w != null && w > 0) _onWeightChanged(w, mandiVm);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final w = double.tryParse(_weightController.text.trim());
                          if (w != null && w > 0) _onWeightChanged(w, mandiVm);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        child: Text(isEn ? 'Update' : 'बदला', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // STEP 3: AUTOMATIC VEHICLE SELECTION BANNER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF165B33).withValues(alpha: 0.1),
                          const Color(0xFF10B981).withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: Colors.amber, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              isEn ? 'Auto-Selected Transport Vehicle:' : 'वजनानुसार आपोआप निवडलेले वाहन:',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${activeVehicle["label"]} (${activeVehicle["range"]})',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isEn
                              ? 'Automatically selected based on ${mandiVm.weightQuintals.toStringAsFixed(0)} Qtl capacity to minimize fuel cost.'
                              : '${mandiVm.weightQuintals.toStringAsFixed(0)} क्विंटल मालाच्या क्षमतेनुसार व इंधन बचतीसाठी हे वाहन स्वयंचलित निवडले आहे.',
                          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Vehicle Selector Chips (to manually override)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: vehicles.map((v) {
                        final isSel = mandiVm.selectedVehicle == v['id'];
                        return Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: InkWell(
                            onTap: () => mandiVm.setVehicle(v['id']!),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSel ? AppColors.primaryLight : AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: isSel ? AppColors.primary : AppColors.cardBorder),
                              ),
                              child: Text(
                                v['label']!,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isSel ? AppColors.primary : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // STEP 4: HIGHEST PROFIT WINNER MANDI (BEST REALIZATION)
            if (bestNetMandi != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF165B33), Color(0xFF10B981)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Color(0x20165B33), blurRadius: 10, offset: Offset(0, 4)),
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
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.emoji_events, size: 14, color: Colors.black),
                              const SizedBox(width: 4),
                              Text(
                                isEn ? '🏆 HIGHEST NET IN-HAND PROFIT' : '🏆 सर्वाधिक निव्वळ नफा देणारी बाजारपेठ',
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${bestNetMandi.distanceKm} km',
                          style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bestNetMandi.mandiName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                    Text(
                      '${bestNetMandi.district ?? "APMC"} • ${mandiVm.weightQuintals.toStringAsFixed(0)} ${isEn ? "Quintals Load" : "क्विंटल माल"}',
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                    const Divider(color: Colors.white24, height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEn ? 'True In-Hand Net Cash:' : 'हातात उरणारा निव्वळ नफा:',
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                            Text(
                              '₹${bestNetMandi.netEarnings.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _showMandiDetailSheet(context, bestNetMandi, mandiVm, isEn),
                          icon: const Icon(Icons.receipt_long, size: 14, color: AppColors.primary),
                          label: Text(
                            isEn ? 'View Bill' : 'तपशील बिल',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ALL CANDIDATE MANDIS RANKING
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEn ? 'All Mandis Ranked by True Profit:' : 'सर्व बाजारपेठांचा निव्वळ नफा क्रमवारी:',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                ),
                Text(
                  '${mandiVm.rankings.length} ${isEn ? "Mandis" : "बाजारपेठा"}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ...mandiVm.rankings.asMap().entries.map((entry) {
              final idx = entry.key;
              final eval = entry.value;
              final isWinner = idx == 0;

              return InkWell(
                onTap: () => _showMandiDetailSheet(context, eval, mandiVm, isEn),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isWinner ? AppColors.primary : AppColors.cardBorder,
                      width: isWinner ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isWinner ? AppColors.primary : AppColors.background,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '#${idx + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isWinner ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eval.mandiName,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            Text(
                              '${eval.distanceKm} km • ${isEn ? "Gross" : "दर"}: ₹${eval.quotedGrossRate.toStringAsFixed(0)}/Qtl',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: isWinner ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            isEn ? 'Net in Hand' : 'हातात नफा',
                            style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
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
      ),
    );
  }
}
