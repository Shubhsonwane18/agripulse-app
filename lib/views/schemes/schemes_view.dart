import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../models/scheme_model.dart';
import '../../viewmodels/scheme_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';

class SchemesView extends StatelessWidget {
  const SchemesView({super.key});

  void _showSchemeDetails(BuildContext context, GovtScheme scheme, bool isEn) {
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
                          isEn ? scheme.title : scheme.titleMr,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                        ),
                        Text(
                          isEn ? scheme.titleMr : scheme.title,
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
                isEn ? 'Eligibility Criteria:' : 'पात्रता निकष (Eligibility Criteria):',
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
                  isEn ? scheme.eligibility : scheme.eligibilityMr,
                  style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                ),
              ),
              const SizedBox(height: 16),

              // Required documents checklist
              Text(
                isEn ? 'Required Documents for Application:' : 'आवश्यक कागदपत्रे (Required Documents):',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              ...scheme.requiredDocuments.map((doc) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(doc, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),

              // Application steps
              Text(
                isEn ? 'Application Steps & Procedure:' : 'अर्ज कसा करावा? (Step-by-Step Application):',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              ...scheme.applicationSteps.map((step) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Text(
                        step,
                        style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.4),
                      ),
                    ),
                  )),
              const SizedBox(height: 16),

              // Portal info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.language, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEn ? 'Official Government Portal:' : 'अधिकृत शासकीय पोर्टल:',
                            style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                          ),
                          Text(
                            scheme.portalName,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          Text(
                            scheme.portalUrl,
                            style: const TextStyle(fontSize: 10, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.check, size: 18),
                  label: Text(isEn ? 'Close' : 'समजले (Close)'),
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
    final isEn = authVm.isEn;

    final categories = isEn
        ? [
            {'id': 'all', 'label': 'All Schemes'},
            {'id': 'solar', 'label': '☀️ Solar Pumps'},
            {'id': 'irrigation', 'label': '💧 Drip Irrigation'},
            {'id': 'insurance', 'label': '🛡️ ₹1 Crop Insurance'},
            {'id': 'machinery', 'label': '🚜 Farm Machinery'},
            {'id': 'direct_benefit', 'label': '💰 Direct DBT'},
          ]
        : [
            {'id': 'all', 'label': 'सर्व योजना (All)'},
            {'id': 'solar', 'label': '☀️ सौर ऊर्जा'},
            {'id': 'irrigation', 'label': '💧 ठिबक सिंचन'},
            {'id': 'insurance', 'label': '🛡️ १ रु. पीक विमा'},
            {'id': 'machinery', 'label': '🚜 अवजारे'},
            {'id': 'direct_benefit', 'label': '💰 थेट बँक मदत'},
          ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEn ? 'Govt Schemes & DBT Subsidies' : 'शासकीय योजना व थेट अनुदान',
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
                hintText: isEn ? 'Search schemes, solar pumps, drip...' : 'योजना किंवा अनुदानाचे नाव शोधा...',
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

          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Row(
              children: categories.map((cat) {
                final isSelected = schemeVm.selectedCategory == cat['id'];
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(
                      cat['label']!,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.cardBorder,
                      ),
                    ),
                    onSelected: (_) => schemeVm.setCategory(cat['id']!),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),

          // Schemes List
          Expanded(
            child: schemeVm.filteredSchemes.isEmpty
                ? Center(
                    child: Text(isEn ? 'No schemes found in this category.' : 'या वर्गवारीत कोणतीही योजना आढळली नाही.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(14),
                    itemCount: schemeVm.filteredSchemes.length,
                    itemBuilder: (context, idx) {
                      final s = schemeVm.filteredSchemes[idx];
                      return InkWell(
                        onTap: () => _showSchemeDetails(context, s, isEn),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: s.isFeatured ? AppColors.primary.withValues(alpha: 0.5) : AppColors.cardBorder,
                              width: s.isFeatured ? 1.5 : 1.0,
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      isEn ? s.category.toUpperCase() : s.categoryLabelMr,
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.green.shade200),
                                    ),
                                    child: Text(
                                      s.deadline,
                                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isEn ? s.title : s.titleMr,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                s.subsidyHighlight,
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                s.subsidyText,
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.file_copy_outlined, size: 14, color: AppColors.textMuted),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${s.requiredDocuments.length} ${isEn ? "Documents" : "कागदपत्रे आवश्यक"}',
                                        style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    isEn ? 'View Process & Apply ➔' : 'तपशील व अर्ज प्रक्रिया पाहा ➔',
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
