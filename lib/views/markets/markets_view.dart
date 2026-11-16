import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/mandi_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/mandi_viewmodel.dart';

class MarketsView extends StatelessWidget {
  const MarketsView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final mandiVm = context.watch<MandiViewModel>();
    final loc = authVm.locale;

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
              AppStrings.get('arbitrageTitle', locale: loc),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
            ),
            Text(
              AppStrings.get('arbitrageSubtitle', locale: loc),
              style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 10),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Inputs Card (Crop, Weight, Vehicle)
            _buildCalculatorControls(context, mandiVm, loc),
            const SizedBox(height: 16),

            // 2. Rankings Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  authVm.isMr ? 'बाजारपेठ निव्वळ नफा क्रमवारी' : 'Mandi Net Profit Rankings',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${mandiVm.weightQuintals.toStringAsFixed(0)} Qtl • ₹${mandiVm.dieselPrice}/L डिझेल',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 3. Ranked Mandi Cards
            if (mandiVm.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else
              ...mandiVm.rankings.asMap().entries.map((entry) {
                final idx = entry.key;
                final eval = entry.value;
                return _buildMandiRankCard(context, eval, idx, mandiVm, loc);
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorControls(BuildContext context, MandiViewModel mandiVm, String loc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Crop Selector
          const Text(
            'शेतमाल निवडा (Select Crop)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Row(
            children: ['Soybean', 'Onion', 'Tomato'].map((crop) {
              final isSel = mandiVm.selectedCommodity == crop;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(crop),
                  selected: isSel,
                  selectedColor: AppColors.accentLight,
                  labelStyle: TextStyle(
                    color: isSel ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  onSelected: (_) => mandiVm.setCommodity(crop),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Weight Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.get('produceWeight', locale: loc),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${mandiVm.weightQuintals.toStringAsFixed(0)} क्विंटल',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.primary),
                ),
              ),
            ],
          ),
          Slider(
            value: mandiVm.weightQuintals,
            min: 5,
            max: 100,
            divisions: 19,
            activeColor: AppColors.primary,
            onChanged: (val) => mandiVm.setWeight(val),
          ),

          // Vehicle Selector
          Text(
            AppStrings.get('vehicleType', locale: loc),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            children: VehicleOption.options.map((v) {
              final isSel = mandiVm.selectedVehicle == v.id;
              return ChoiceChip(
                label: Text('${v.localizedName} (${v.mileageKmPerL} km/L)'),
                selected: isSel,
                selectedColor: AppColors.accentLight,
                labelStyle: TextStyle(
                  color: isSel ? AppColors.primary : AppColors.textPrimary,
                  fontSize: 11,
                  fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (_) => mandiVm.setVehicle(v.id),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMandiRankCard(
    BuildContext context,
    MandiEvaluation eval,
    int index,
    MandiViewModel mandiVm,
    String loc,
  ) {
    final isRank1 = index == 0;
    final borderColor = isRank1 ? AppColors.accent : AppColors.cardBorder;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isRank1 ? const Color(0xFFF0FDF4) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: isRank1 ? 1.5 : 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: isRank1 ? AppColors.primary : Colors.grey.shade300,
                    child: Text(
                      '#${index + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isRank1 ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    eval.mandiName,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              if (isRank1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '★ सर्वोत्कृष्ट नफा',
                    style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${eval.distanceKm} km अंतर • ${eval.district ?? "जिल्हा"} • ${eval.yardTier ?? "APMC Yard"}',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const Divider(height: 16),

          // Rates & Overhead Breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('बाजार भाव (Gross)', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  Text(
                    '₹${eval.quotedGrossRate.toStringAsFixed(0)}/Qtl',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('वाहतूक व सेस खर्च', style: TextStyle(fontSize: 10, color: AppColors.danger)),
                  Text(
                    '-₹${eval.logisticsOverhead.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.danger),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('हातात उरणारा निव्वळ भाव', style: TextStyle(fontSize: 10, color: AppColors.primary)),
                  Text(
                    '₹${eval.effectiveNetRate.toStringAsFixed(0)}/Qtl',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // In-hand total cash
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('एकूण हातात येणारी रक्कम (Net Cash):', style: TextStyle(fontSize: 11)),
                Text(
                  '₹${eval.netEarnings.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
