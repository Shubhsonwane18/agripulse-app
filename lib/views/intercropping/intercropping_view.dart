import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../viewmodels/intercropping_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';

class IntercroppingView extends StatelessWidget {
  const IntercroppingView({super.key});

  @override
  Widget build(BuildContext context) {
    final intercropVm = context.watch<IntercroppingViewModel>();
    final authVm = context.watch<AuthViewModel>();
    final loc = authVm.locale;
    final isMr = loc == 'mr';

    final crops = [
      {'id': 'all', 'label': AppStrings.tr(loc, en: 'All Intercrops', mr: 'सर्व आंतरपिके', hi: 'सभी अंतर्फसलें', te: 'అన్ని అంతరపంటలు', kn: 'ಎಲ್ಲಾ ಮಿಶ್ರಬೆಳೆಗಳು', gu: 'તમામ આંતરપાક')},
      {'id': 'सोयाबीन', 'label': AppStrings.tr(loc, en: '🌱 Soybean', mr: '🌱 सोयाबीन', hi: '🌱 सोयाबीन', te: '🌱 సోయాబీన్', kn: '🌱 ಸೋಯಾಬೀನ್', gu: '🌱 સોયાબીન')},
      {'id': 'कापूस', 'label': AppStrings.tr(loc, en: '☁️ Cotton', mr: '☁️ कापूस', hi: '☁️ कपास', te: '☁️ పత్తి', kn: '☁️ ಹತ್ತಿ', gu: '☁️ કપાસ')},
      {'id': 'ऊस', 'label': AppStrings.tr(loc, en: '🎋 Sugarcane', mr: '🎋 ऊस', hi: '🎋 गन्ना', te: '🎋 చెరకు', kn: '🎋 ಕಬ್ಬು', gu: '🎋 શેરડી')},
      {'id': 'मका', 'label': AppStrings.tr(loc, en: '🌽 Maize', mr: '🌽 मका', hi: '🌽 मक्का', te: '🌽 మొక్కజొన్న', kn: '🌽 ಜೋಳ', gu: '🌽 મકાઈ')},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.get('intercropping', locale: loc),
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Acreage Multiplier Selector Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF165B33), Color(0xFF10B981)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(color: Color(0x15000000), blurRadius: 8, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.workspace_premium, color: Colors.amber, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        AppStrings.tr(
                          loc,
                          en: 'Guaranteed Profit & Fertilizer Savings',
                          mr: 'दुहेरी नफा व खत बचत हमी',
                          hi: 'दोहरा मुनाफा एवं खाद बचत गारंटी',
                          te: 'రెట్టింపు లాభం & ఎరువుల ఆదా హామీ',
                          kn: 'ದ್ವಿಗುಣ ಲಾಭ ಮತ್ತು ಗೊಬ್ಬರ ಉಳಿತಾಯ ಖಾತರಿ',
                          gu: 'બમણો નફો અને ખાતર બચત ગેરંટી',
                        ),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppStrings.tr(
                      loc,
                      en: 'Intercropping enriches soil nitrogen, saves 30% fertilizer expense, and yields extra profit per acre.',
                      mr: 'आंतरपिकामुळे जमिनीतील नत्र वाढते, खताचा खर्च ३०% वाचतो आणि एकरी अतिरिक्त नफा मिळतो.',
                      hi: 'अंतर्फसल से भूमि की उर्वरता बढ़ती है, खाद का खर्च ३०% बचता है और प्रति एकड़ अतिरिक्त लाभ होता है।',
                      te: 'అంతర పంటల వల్ల నేలలో నత్రజని పెరుగుతుంది, ఎరువుల ఖర్చు 30% ఆదా అవుతుంది.',
                      kn: 'ಮಿಶ್ರಬೆಳೆಗಳಿಂದ ಮಣ್ಣಿನ ಸಾರಜನಕ ಹೆಚ್ಚುತ್ತದೆ, ಗೊಬ್ಬರದ ವೆಚ್ಚ 30% ಉಳಿತಾಯವಾಗುತ್ತದೆ.',
                      gu: 'આંતરપાકથી જમીનની ફળદ્રુપતા વધે છે, ખાતરનો ખર્ચ ૩૦% બચે છે.',
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.tr(loc, en: 'Select Farm Acreage:', mr: 'तुमचे शेतक्षेत्र निवडा:', hi: 'कृषि रकबा चुनें:', te: 'భూమి విస్తీర్ణం ఎంచుకోండి:', kn: 'ಕೃಷಿ ವಿಸ್ತೀರ್ಣ ಆಯ್ಕೆಮಾಡಿ:', gu: 'ખેતીનો વિસ્તાર પસંદ કરો:'),
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [1.0, 2.0, 3.0, 5.0].map((ac) {
                          final isSel = intercropVm.farmAcreage == ac;
                          return Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: InkWell(
                              onTap: () => intercropVm.setAcreage(ac),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSel ? Colors.white : Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${ac.toStringAsFixed(0)} ${AppStrings.tr(loc, en: "Acres", mr: "एकर", hi: "एकड़", te: "ఎకరాలు", kn: "ಎಕರೆ", gu: "એકર")}',
                                  style: TextStyle(
                                    color: isSel ? AppColors.primary : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Crop Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: crops.map((c) {
                  final isSel = intercropVm.selectedMainCrop == c['id'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(
                        c['label']!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSel ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      selected: isSel,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: isSel ? AppColors.primary : AppColors.cardBorder),
                      ),
                      onSelected: (_) => intercropVm.setMainCrop(c['id']!),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // Intercrop Plans List
            Text(
              AppStrings.tr(
                loc,
                en: 'Proven Scientific Intercrop Patterns:',
                mr: 'सर्वोत्कृष्ट शास्त्रोक्त आंतरपीक पद्धती:',
                hi: 'सर्वोत्तम वैज्ञानिक अंतर्फसल पद्धतियां:',
                te: 'శాస్త్రీయ అంతరపంటల పద్ధతులు:',
                kn: 'ಉತ್ತಮ ವೈಜ್ಞಾನಿಕ ಮಿಶ್ರಬೆಳೆ ಮಾದರಿಗಳು:',
                gu: 'શ્રેષ્ઠ વૈજ્ઞાનિક આંતરપાક પદ્ધતિઓ:',
              ),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),

            ...intercropVm.filteredPlans.map((plan) {
              final extraTotal = intercropVm.calculateProjectedExtraIncome(plan);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: plan.isTopRecommended ? AppColors.primary.withValues(alpha: 0.5) : AppColors.cardBorder,
                    width: plan.isTopRecommended ? 1.5 : 1.0,
                  ),
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
                          child: Text(
                            isMr ? plan.nameMr : plan.name,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                          ),
                        ),
                        if (plan.isTopRecommended)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              AppStrings.tr(loc, en: '⭐ Recommended', mr: '⭐ शिफारस', hi: '⭐ अनुशंसित', te: '⭐ సిఫార్సు', kn: '⭐ ಶಿಫಾರಸು', gu: '⭐ ભલામણ'),
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Visual Row Pattern Representation
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.tr(loc, en: 'Field Row Pattern:', mr: 'ओळींचे प्रत्यक्ष प्रमाण (Field Row Pattern):', hi: 'पंक्ति अनुपात (Row Pattern):', te: 'వరుసల విధానం:', kn: 'ಸಾಲು ಮಾದರಿ:', gu: 'હરોળ પદ્ધતિ:'),
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            plan.rowVisual,
                            style: const TextStyle(fontSize: 16, letterSpacing: 2),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            plan.rowRatio,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Extra Income Badge
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${intercropVm.farmAcreage.toStringAsFixed(0)} ${AppStrings.tr(loc, en: "Acres Extra Projected Profit:", mr: "एकरासाठी संभाव्य अतिरिक्त नफा:", hi: "एकड़ के लिए अतिरिक्त अनुमानित लाभ:", te: "ఎకరాల అదనపు అంచనా లాభం:", kn: "ಎಕರೆಗೆ ಹೆಚ್ಚುವರಿ ಅಂದಾಜು ಲಾಭ:", gu: "એકર માટે અંદાજિત વધારાનો નફો:")}',
                                style: const TextStyle(fontSize: 10, color: Colors.green),
                              ),
                              Text(
                                '+₹${extraTotal.toStringAsFixed(0)} ${AppStrings.tr(loc, en: "Extra Income", mr: "अतिरिक्त उत्पन्न", hi: "अतिरिक्त आय", te: "అదనపు ఆదాయం", kn: "ಹೆಚ್ಚುವರಿ ಆದಾಯ", gu: "વધારાની આવક")}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.trending_up, color: Colors.green, size: 24),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Scientific rationale
                    Text(
                      AppStrings.tr(loc, en: 'Scientific Soil & Agronomic Benefits:', mr: 'शास्त्रोक्त फायदे (Scientific Benefits):', hi: 'वैज्ञानिक एवं कृषि लाभ:', te: 'శాస్త్రీయ నేల ప్రయోజనాలు:', kn: 'ವೈಜ್ಞಾನಿಕ ಕೃಷಿ ಪ್ರಯೋಜನಗಳು:', gu: 'વૈજ્ઞાનિક જમીન લાભો:'),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plan.scientificRationale,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: 8),

                    // Spacing and management tip
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.straighten, size: 14, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              plan.spacingGuideline,
                              style: const TextStyle(fontSize: 10, color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 14),

            // Scientific Crop Rotation Guide Section
            Text(
              AppStrings.tr(
                loc,
                en: 'Scientific Crop Rotation Cycles:',
                mr: 'शास्त्रोक्त पीक फेरपालट नियम (Crop Rotation Cycles):',
                hi: 'वैज्ञानिक फसल चक्र नियम (Crop Rotation):',
                te: 'శాస్త్రీయ పంటల మార్పిడి నియమాలు:',
                kn: 'ವೈಜ್ಞಾನಿಕ ಬೆಳೆ ಪರಿವರ್ತನೆ ಚಕ್ರ:',
                gu: 'વૈજ્ઞાનિક પાક ફેરબદલી ચક્ર:',
              ),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),

            ...intercropVm.rotationRules.map((rule) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.autorenew_rounded, color: Colors.blue, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            rule.seasonSequence,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rule.rationale,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '✓ ${rule.benefitSummary}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
