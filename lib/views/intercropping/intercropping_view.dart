import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../viewmodels/intercropping_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';

class IntercroppingView extends StatelessWidget {
  const IntercroppingView({super.key});

  @override
  Widget build(BuildContext context) {
    final intercropVm = context.watch<IntercroppingViewModel>();
    final authVm = context.watch<AuthViewModel>();

    final isEn = authVm.isEn;

    final crops = [
      {'id': 'all', 'label': isEn ? 'All Intercrops' : 'सर्व आंतरपिके (All)'},
      {'id': 'सोयाबीन', 'label': isEn ? '🌱 Soybean' : '🌱 सोयाबीन'},
      {'id': 'कापूस', 'label': isEn ? '☁️ Cotton' : '☁️ कापूस'},
      {'id': 'ऊस', 'label': isEn ? '🎋 Sugarcane' : '🎋 ऊस'},
      {'id': 'मका', 'label': isEn ? '🌽 Maize' : '🌽 मका'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEn ? 'Intercropping & Crop Rotation Planner' : 'आंतरपीक व फेरपालट मार्गदर्शक',
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
                        isEn ? 'Guaranteed Profit & Fertilizer Savings' : 'दुहेरी नफा व खत बचत हमी',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isEn
                        ? 'Intercropping enriches soil nitrogen, saves 30% fertilizer expense, and yields ₹18,000 to ₹40,000 extra profit per acre.'
                        : 'आंतरपिकामुळे जमिनीतील नत्र वाढते, खताचा खर्च ३०% वाचतो आणि एकरी ₹१८,००० ते ₹४०,००० अतिरिक्त नफा मिळतो.',
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEn ? 'Select Farm Acreage:' : 'तुमचे शेतक्षेत्र निवडा:',
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
                                  '${ac.toStringAsFixed(0)} ${isEn ? "Acres" : "एकर"}',
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
              authVm.isMr ? 'सर्वोत्कृष्ट शास्त्रोक्त आंतरपीक पद्धती:' : 'Proven Intercrop Patterns:',
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
                            isEn ? plan.name : plan.nameMr,
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
                              isEn ? '⭐ Recommended' : '⭐ शिफारस',
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
                            isEn ? 'Field Row Pattern:' : 'ओळींचे प्रत्यक्ष प्रमाण (Field Row Pattern):',
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
                                isEn ? 'Potential Extra Profit for ${intercropVm.farmAcreage.toStringAsFixed(0)} Acres:' : '${intercropVm.farmAcreage.toStringAsFixed(0)} एकरासाठी संभाव्य अतिरिक्त नफा:',
                                style: const TextStyle(fontSize: 10, color: Colors.green),
                              ),
                              Text(
                                '+₹${extraTotal.toStringAsFixed(0)} ${isEn ? "Extra Income" : "अतिरिक्त उत्पन्न"}',
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
                    Text(isEn ? 'Scientific Soil & Agronomic Benefits:' : 'शास्त्रोक्त फायदे (Scientific Benefits):', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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
              authVm.isMr ? 'शास्त्रोक्त पीक फेरपालट नियम (Crop Rotation Cycles):' : 'Crop Rotation Rules:',
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
