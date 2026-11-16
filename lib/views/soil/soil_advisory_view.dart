import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/soil_viewmodel.dart';

class SoilAdvisoryView extends StatelessWidget {
  const SoilAdvisoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final soilVm = context.watch<SoilViewModel>();
    final loc = authVm.locale;
    final res = soilVm.result;
    final input = soilVm.currentInput;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          AppStrings.get('soilTitle', locale: loc),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Suitability Card
            if (res != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          res.soilHealthStatus,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'ICAR Standard',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      res.getSuitability(authVm.isEn),
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const Divider(height: 20),

                    // Fertilizer Bags Breakdown
                    Text(
                      authVm.isEn ? 'Recommended Fertilizer Dosage (Bags Needed):' : 'शिफारस केलेली खतांची मात्रा (Bags Needed):',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFertilizerPill(
                          authVm.isEn ? 'Urea' : 'युरिया (Urea)',
                          '${res.ureaBags.toStringAsFixed(1)} ${authVm.isEn ? "Bags" : "गोण्या"}',
                          Colors.green,
                        ),
                        _buildFertilizerPill(
                          authVm.isEn ? 'DAP' : 'डीएपी (DAP)',
                          '${res.dapBags.toStringAsFixed(1)} ${authVm.isEn ? "Bags" : "गोण्या"}',
                          Colors.blue,
                        ),
                        _buildFertilizerPill(
                          authVm.isEn ? 'MOP (Potash)' : 'एमओपी (MOP)',
                          '${res.mopBags.toStringAsFixed(1)} ${authVm.isEn ? "Bags" : "गोण्या"}',
                          Colors.purple,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Input Sliders Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authVm.isEn ? 'Soil Lab Test Values (NPK & pH)' : 'माती तपासणी आकडेवारी (Soil Test Values)',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),

                  _buildSlider(
                    label: authVm.isEn ? 'Nitrogen / N (kg/ha)' : 'नत्र / Nitrogen (kg/ha)',
                    value: input.nitrogen,
                    min: 100,
                    max: 500,
                    onChanged: (v) => soilVm.updateInputs(nitrogen: v),
                  ),
                  _buildSlider(
                    label: authVm.isEn ? 'Phosphorus / P (kg/ha)' : 'स्फुरद / Phosphorus (kg/ha)',
                    value: input.phosphorus,
                    min: 5,
                    max: 60,
                    onChanged: (v) => soilVm.updateInputs(phosphorus: v),
                  ),
                  _buildSlider(
                    label: authVm.isEn ? 'Potassium / K (kg/ha)' : 'पालाश / Potassium (kg/ha)',
                    value: input.potassium,
                    min: 80,
                    max: 600,
                    onChanged: (v) => soilVm.updateInputs(potassium: v),
                  ),
                  _buildSlider(
                    label: authVm.isEn ? 'Soil pH Level' : 'सामू / pH Level',
                    value: input.ph,
                    min: 5.0,
                    max: 9.0,
                    onChanged: (v) => soilVm.updateInputs(ph: v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFertilizerPill(String name, String bags, MaterialColor color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.shade200),
          ),
          child: Text(
            bags,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color.shade900),
          ),
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.primary,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
