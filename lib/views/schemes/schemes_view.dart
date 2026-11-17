import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/scheme_model.dart';
import '../../viewmodels/scheme_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';

class SchemesView extends StatelessWidget {
  const SchemesView({super.key});

  void _showSchemeDetails(BuildContext context, GovtScheme scheme, String loc) {
    final isMr = loc == 'mr';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListView(
            controller: scrollController,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isMr ? scheme.titleMr : scheme.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                        ),
                        Text(
                          isMr ? scheme.title : scheme.titleMr,
                          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Subsidy highlight badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, color: Colors.green, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scheme.subsidyHighlight,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.primary),
                          ),
                          Text(
                            scheme.subsidyText,
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Eligibility
              Text(
                AppStrings.tr(loc, en: 'Eligibility Criteria:', mr: 'पात्रता निकष (Eligibility Criteria):', hi: 'पात्रता मानदंड:', te: 'అర్హత ప్రమాణాలు:', kn: 'ಅರ್ಹತಾ ಮಾನದಂಡಗಳು:', gu: 'લાયકાત માપદંડ:'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isMr ? scheme.eligibilityMr : scheme.eligibility,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.4),
                ),
              ),
              const SizedBox(height: 16),

              // Required Documents
              Text(
                AppStrings.tr(loc, en: 'Required Documents for Application:', mr: 'आवश्यक कागदपत्रे (Required Documents):', hi: 'आवेदन हेतु आवश्यक दस्तावेज:', te: 'అవసరమైన పత్రాలు:', kn: 'ಅಗತ್ಯ ದಾಖಲೆಗಳು:', gu: 'જરૂરી દસ્તાવેજો:'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              ...scheme.requiredDocuments.map((doc) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(doc, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),

              // Step-by-Step Procedure
              Text(
                AppStrings.tr(loc, en: 'Application Steps & Procedure:', mr: 'अर्ज कसा करावा? (Step-by-Step Application):', hi: 'आवेदन प्रक्रिया:', te: 'దరఖాస్తు విధానం:', kn: 'ಅರ್ಜಿ ಸಲ್ಲಿಕೆ ಪ್ರಕ್ರಿಯೆ:', gu: 'અરજી કરવાની પ્રક્રિયા:'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              ...scheme.applicationSteps.asMap().entries.map((step) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${step.key + 1}',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(step.value, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.3)),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 14),

              // Official Portal Link
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.language, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.tr(loc, en: 'Official Government Portal:', mr: 'अधिकृत शासकीय पोर्टल:', hi: 'आधिकारिक सरकारी पोर्टल:', te: 'అధికారిక ప్రభుత్వ పోర్టల్:', kn: 'ಅಧಿಕೃತ ಸರ್ಕಾರಿ ಪೋರ್ಟಲ್:', gu: 'સત્તાવાર સરકારી પોર્ટલ:'),
                            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                          ),
                          Text(
                            scheme.portalUrl,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Close / Apply action
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.check, size: 18),
                  label: Text(AppStrings.tr(loc, en: 'Close', mr: 'समजले (Close)', hi: 'ठीक है', te: 'సరే', kn: 'ಸರಿ', gu: 'બરાબર')),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schemeVm = context.watch<SchemeViewModel>();
    final authVm = context.watch<AuthViewModel>();
    final loc = authVm.locale;
    final isMr = loc == 'mr';

    final categories = [
      {'id': 'all', 'label': AppStrings.tr(loc, en: 'All Schemes', mr: 'सर्व योजना', hi: 'सभी योजनाएं', te: 'అన్ని పథకాలు', kn: 'ಎಲ್ಲಾ ಯೋಜನೆಗಳು', gu: 'તમામ યોજનાઓ')},
      {'id': 'solar', 'label': AppStrings.tr(loc, en: '☀️ Solar Pumps', mr: '☀️ सौर ऊर्जा', hi: '☀️ सोलर पंप', te: '☀️ సోలార్ పంపులు', kn: '☀️ ಸೌರ ಪಂಪ್‌ಗಳು', gu: '☀️ સોલર પંપ')},
      {'id': 'irrigation', 'label': AppStrings.tr(loc, en: '💧 Drip Irrigation', mr: '💧 ठिबक सिंचन', hi: '💧 ड्रिप सिंचाई', te: '💧 బిందు సేద్యం', kn: '💧 ಹನಿ ನೀರಾವರಿ', gu: '💧 ટપક સિંચાઈ')},
      {'id': 'insurance', 'label': AppStrings.tr(loc, en: '🛡️ ₹1 Crop Insurance', mr: '🛡️ १ रु. पीक विमा', hi: '🛡️ ₹1 फसल बीमा', te: '🛡️ ₹1 పంట బీమా', kn: '🛡️ ₹1 ಬೆಳೆ ವಿಮೆ', gu: '🛡️ ₹1 પાક વીમો')},
      {'id': 'machinery', 'label': AppStrings.tr(loc, en: '🚜 Farm Machinery', mr: '🚜 अवजारे', hi: '🚜 कृषि यंत्र', te: '🚜 వ్యవసాయ యంత్రాలు', kn: '🚜 ಕೃಷಿ ಯಂತ್ರೋಪಕರಣಗಳು', gu: '🚜 કૃષિ સાધનો')},
      {'id': 'direct_benefit', 'label': AppStrings.tr(loc, en: '💰 Direct DBT', mr: '💰 थेट बँक मदत', hi: '💰 प्रत्यक्ष डीबीटी', te: '💰 ప్రత్యక్ష డిబిటి', kn: '💰 ನೇರ ಡಿಬಿಟಿ', gu: '💰 ડાયરેક્ટ ડીબીટી')},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.get('govtSchemes', locale: loc),
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
        ),
      ),
      body: Column(
        children: [
          // Top Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: schemeVm.setSearchQuery,
              decoration: InputDecoration(
                hintText: AppStrings.tr(loc, en: 'Search schemes, solar pumps, drip...', mr: 'योजना किंवा अनुदानाचे नाव शोधा...', hi: 'योजना या सब्सिडी का नाम खोजें...', te: 'పథకాలు లేదా సబ్సిడీలను వెతకండి...', kn: 'ಯೋಜನೆಗಳು ಅಥವಾ ಸಬ್ಸಿಡಿಗಳನ್ನು ಹುಡುಕಿ...', gu: 'યોજનાઓ અથવા સબસિડી શોધો...'),
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
              ),
            ),
          ),

          // Categories horizontal list
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, idx) {
                final c = categories[idx];
                final isSel = schemeVm.selectedCategory == c['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
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
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: isSel ? AppColors.primary : AppColors.cardBorder),
                    ),
                    onSelected: (_) => schemeVm.setCategory(c['id']!),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Scheme cards list
          Expanded(
            child: schemeVm.filteredSchemes.isEmpty
                    ? Center(
                        child: Text(
                          AppStrings.tr(loc, en: 'No schemes found in this category.', mr: 'या वर्गवारीत कोणतीही योजना आढळली नाही.', hi: 'इस श्रेणी में कोई योजना नहीं मिली।', te: 'ఈ విభాగంలో ఎటువంటి పథకాలు కనుగొనబడలేదు.', kn: 'ಈ ವರ್ಗದಲ್ಲಿ ಯಾವುದೇ ಯೋಜನೆಗಳು ಕಂಡುಬಂದಿಲ್ಲ.', gu: 'આ શ્રેણીમાં કોઈ યોજના મળી નથી.'),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        itemCount: schemeVm.filteredSchemes.length,
                        itemBuilder: (context, idx) {
                          final s = schemeVm.filteredSchemes[idx];
                          return InkWell(
                            onTap: () => _showSchemeDetails(context, s, loc),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
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
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryLight,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isMr ? s.categoryLabelMr : s.category.toUpperCase(),
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.green.shade300),
                                        ),
                                        child: Text(
                                          s.subsidyHighlight,
                                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    isMr ? s.titleMr : s.title,
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    s.subsidyText,
                                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Divider(height: 18),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.file_copy_outlined, size: 14, color: AppColors.textMuted),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${s.requiredDocuments.length} ${AppStrings.tr(loc, en: "Documents", mr: "कागदपत्रे", hi: "दस्तावेज", te: "పత్రాలు", kn: "ದಾಖಲೆಗಳು", gu: "દસ્તાવેજો")}',
                                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        AppStrings.tr(loc, en: 'View Process & Apply ➔', mr: 'तपशील व अर्ज प्रक्रिया पाहा ➔', hi: 'विवरण व आवेदन प्रक्रिया देखें ➔', te: 'వివరాలు & దరఖాస్తు చూడండి ➔', kn: 'ವಿವರಗಳು ಮತ್ತು ಅರ್ಜಿ ಪ್ರಕ್ರಿಯೆ ನೋಡಿ ➔', gu: 'વિગતો અને અરજી પ્રક્રિયા જુઓ ➔'),
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
