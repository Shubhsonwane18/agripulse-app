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
    final isMr = loc == 'mr';
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
                      res.getSuitability(!isMr),
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const Divider(height: 20),

                    // Fertilizer Bags Breakdown
                    Text(
                      AppStrings.tr(
                        loc,
                        en: 'Recommended Fertilizer Dosage (Bags Needed):',
                        mr: 'शिफारस केलेली खतांची मात्रा (Bags Needed):',
                        hi: 'अनुशंसित खाद की मात्रा (आवश्यक बोरियां):',
                        te: 'సిఫార్సు చేసిన ఎరువుల మోతాదు (బస్తాలు):',
                        kn: 'ಶಿಫಾರಸು ಮಾಡಿದ ರಸಗೊಬ್ಬರ ಪ್ರಮಾಣ (ಚೀಲಗಳು):',
                        gu: 'ભલામણ કરેલ ખાતરની માત્રા (થેલી):',
                      ),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildFertilizerPill(
                          AppStrings.tr(loc, en: 'Urea', mr: 'युरिया (Urea)', hi: 'यूरिया', te: 'యూరియా', kn: 'ಯೂರಿಯಾ', gu: 'યુરિયા'),
                          '${res.ureaBags.toStringAsFixed(1)} ${AppStrings.tr(loc, en: "Bags", mr: "गोण्या", hi: "बोरी", te: "బస్తాలు", kn: "ಚೀಲಗಳು", gu: "થેલી")}',
                          Colors.green,
                        ),
                        _buildFertilizerPill(
                          AppStrings.tr(loc, en: 'DAP', mr: 'डीएपी (DAP)', hi: 'डीएपी', te: 'డిఎపి', kn: 'ಡಿಎಪಿ', gu: 'ડીએપી'),
                          '${res.dapBags.toStringAsFixed(1)} ${AppStrings.tr(loc, en: "Bags", mr: "गोण्या", hi: "बोरी", te: "బస్తాలు", kn: "ಚೀಲಗಳು", gu: "થેલી")}',
                          Colors.blue,
                        ),
                        _buildFertilizerPill(
                          AppStrings.tr(loc, en: 'MOP (Potash)', mr: 'एमओपी (Potash)', hi: 'पोटाश (MOP)', te: 'పొటాష్ (MOP)', kn: 'ಪೊಟ್ಯಾಷ್ (MOP)', gu: 'પોટાશ (MOP)'),
                          '${res.mopBags.toStringAsFixed(1)} ${AppStrings.tr(loc, en: "Bags", mr: "गोण्या", hi: "बोरी", te: "బస్తాలు", kn: "ಚೀಲಗಳು", gu: "થેલી")}',
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
                    AppStrings.tr(
                      loc,
                      en: 'Soil Lab Test Values (NPK & pH)',
                      mr: 'माती तपासणी आकडेवारी (Soil Test Values)',
                      hi: 'मिट्टी परीक्षण मान (NPK एवं pH)',
                      te: 'నేల పరీక్ష విలువలు (NPK & pH)',
                      kn: 'ಮಣ್ಣು ಪರೀಕ್ಷಾ ಮೌಲ್ಯಗಳು (NPK & pH)',
                      gu: 'માટી પરીક્ષણ મૂલ્યો (NPK અને pH)',
                    ),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),

                  _buildSlider(
                    label: AppStrings.tr(loc, en: 'Nitrogen / N (kg/ha)', mr: 'नत्र / Nitrogen (kg/ha)', hi: 'नाइट्रोजन / N (kg/ha)', te: 'నత్రజని / N (kg/ha)', kn: 'ಸಾರಜನಕ / N (kg/ha)', gu: 'નાઇટ્રોજન / N (kg/ha)'),
                    value: input.nitrogen,
                    min: 100,
                    max: 500,
                    onChanged: (v) => soilVm.updateInputs(nitrogen: v),
                  ),
                  _buildSlider(
                    label: AppStrings.tr(loc, en: 'Phosphorus / P (kg/ha)', mr: 'स्फुरद / Phosphorus (kg/ha)', hi: 'फास्फोरस / P (kg/ha)', te: 'భాస్వరం / P (kg/ha)', kn: 'ರಂಜಕ / P (kg/ha)', gu: 'ફોસ્ફરસ / P (kg/ha)'),
                    value: input.phosphorus,
                    min: 5,
                    max: 60,
                    onChanged: (v) => soilVm.updateInputs(phosphorus: v),
                  ),
                  _buildSlider(
                    label: AppStrings.tr(loc, en: 'Potassium / K (kg/ha)', mr: 'पालाश / Potassium (kg/ha)', hi: 'पोटेशियम / K (kg/ha)', te: 'పొటాషియం / K (kg/ha)', kn: 'ಪೊಟ್ಯಾಶಿಯಂ / K (kg/ha)', gu: 'પોટેશિયમ / K (kg/ha)'),
                    value: input.potassium,
                    min: 80,
                    max: 600,
                    onChanged: (v) => soilVm.updateInputs(potassium: v),
                  ),
                  _buildSlider(
                    label: AppStrings.tr(loc, en: 'Soil pH Level', mr: 'सामू / pH Level', hi: 'मिट्टी का pH स्तर', te: 'నేల pH స్థాయి', kn: 'ಮಣ್ಣಿನ pH ಮಟ್ಟ', gu: 'જમીનનું pH સ્તર'),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.shade200),
      ),
      child: Column(
        children: [
          Text(name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color.shade800)),
          const SizedBox(height: 2),
          Text(bags, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color.shade900)),
        ],
      ),
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
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.primaryLight,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
