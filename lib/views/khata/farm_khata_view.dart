import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/khata_model.dart';
import '../../viewmodels/khata_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';

class FarmKhataView extends StatefulWidget {
  const FarmKhataView({super.key});

  @override
  State<FarmKhataView> createState() => _FarmKhataViewState();
}

class _FarmKhataViewState extends State<FarmKhataView> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showAddEntryDialog(BuildContext context, KhataViewModel khataVm, String loc, {required bool isExpense}) {
    _amountController.clear();
    _notesController.clear();

    String selectedCrop = AppStrings.tr(loc, en: 'Soybean', mr: 'सोयाबीन (Soybean)', hi: 'सोयाबीन', te: 'సోయాబీన్', kn: 'ಸೋಯಾಬೀನ್', gu: 'સોયાબીન');
    final categories = isExpense ? KhataEntry.expenseCategories : KhataEntry.incomeCategories;
    String selectedCatId = categories.first['id']!;
    String selectedCatLabel = (loc == 'en' || loc == 'hi' || loc == 'te' || loc == 'kn' || loc == 'gu')
        ? (categories.first['labelShortEn'] ?? 'Fertilizers')
        : categories.first['labelShort']!;

    final crops = [
      AppStrings.tr(loc, en: 'Soybean', mr: 'सोयाबीन (Soybean)', hi: 'सोयाबीन', te: 'సోయాబీన్', kn: 'ಸೋಯಾಬೀನ್', gu: 'સોયાબીન'),
      AppStrings.tr(loc, en: 'Cotton', mr: 'कापूस (Cotton)', hi: 'कपास', te: 'పత్తి', kn: 'ಹತ್ತಿ', gu: 'કપાસ'),
      AppStrings.tr(loc, en: 'Sugarcane', mr: 'ऊस (Sugarcane)', hi: 'गन्ना', te: 'చెరకు', kn: 'ಕಬ್ಬು', gu: 'શેરડી'),
      AppStrings.tr(loc, en: 'Onion', mr: 'कांदा (Onion)', hi: 'प्याज', te: 'ఉల్లిపాయ', kn: 'ಈರುಳ್ಳಿ', gu: 'ડુંગળી'),
      AppStrings.tr(loc, en: 'Tur / Arhar', mr: 'तूर (Tur)', hi: 'अरहर / तूर', te: 'కంది', kn: 'ತೊಗರಿ', gu: 'તુવેર'),
      AppStrings.tr(loc, en: 'Vegetables', mr: 'भाजीपाला (Vegetables)', hi: 'सब्जियां', te: 'కూరగాయలు', kn: 'ತರಕಾರಿಗಳು', gu: 'શાકભાજી'),
      AppStrings.tr(loc, en: 'General Farm', mr: 'इतर शेतकाम (General Farm)', hi: 'सामान्य खेत कार्य', te: 'సాధారణ పనులు', kn: 'ಸಾಮಾನ್ಯ ಕೆಲಸ', gu: 'સામાન્ય ખેતી'),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    isExpense ? Icons.remove_circle : Icons.add_circle,
                    color: isExpense ? Colors.red : Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isExpense
                        ? AppStrings.tr(loc, en: 'Add New Farm Expense', mr: 'नवीन खर्च नोंदवा', hi: 'नया खर्च दर्ज करें', te: 'కొత్త ఖర్చు నమోదు చేయండి', kn: 'ಹೊಸ ವೆಚ್ಚ ದಾಖಲಿಸಿ', gu: 'નવો ખર્ચ નોંધો')
                        : AppStrings.tr(loc, en: 'Add New Farm Income', mr: 'नवीन उत्पन्न नोंदवा', hi: 'नयी आय दर्ज करें', te: 'కొత్త ఆదాయం నమోదు చేయండి', kn: 'ಹೊಸ ಆದಾಯ ದಾಖಲಿಸಿ', gu: 'નવી આવક નોંધો'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Crop Dropdown
              Text(
                AppStrings.tr(loc, en: 'Associated Crop:', mr: 'संबंधित पीक:', hi: 'संबंधित फसल:', te: 'సంబంధిత పంట:', kn: 'ಸಂಬಂಧಿತ ಬೆಳೆ:', gu: 'સંબંધિત પાક:'),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                initialValue: selectedCrop,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                items: crops.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12)))).toList(),
                onChanged: (val) {
                  if (val != null) setModalState(() => selectedCrop = val);
                },
              ),
              const SizedBox(height: 12),

              // Category Selector
              Text(
                AppStrings.tr(loc, en: 'Category:', mr: 'खर्च / उत्पन्नाचा प्रकार:', hi: 'श्रेणी (Category):', te: 'వర్గం:', kn: 'ವರ್ಗ:', gu: 'વર્ગ:'),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSel = selectedCatId == cat['id'];
                    final label = (loc == 'en' || loc == 'hi' || loc == 'te' || loc == 'kn' || loc == 'gu')
                        ? (cat['labelShortEn'] ?? cat['labelShort']!)
                        : cat['labelShort']!;
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSel ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        selected: isSel,
                        selectedColor: isExpense ? Colors.red.shade700 : AppColors.primary,
                        backgroundColor: AppColors.background,
                        showCheckmark: false,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: isSel ? (isExpense ? Colors.red.shade700 : AppColors.primary) : AppColors.cardBorder,
                          ),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              selectedCatId = cat['id']!;
                              selectedCatLabel = (loc == 'en' || loc == 'hi' || loc == 'te' || loc == 'kn' || loc == 'gu')
                                  ? (cat['labelShortEn'] ?? cat['labelShort']!)
                                  : cat['labelShort']!;
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // Amount
              Text(
                AppStrings.tr(loc, en: 'Amount (₹):', mr: 'रक्कम (₹):', hi: 'रकम (₹):', te: 'మొత్తం (₹):', kn: 'ಮೊತ್ತ (₹):', gu: 'રકમ (₹):'),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(fontWeight: FontWeight.bold),
                  hintText: 'e.g. 3500',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 8),

              // Quick Amount Chips
              Wrap(
                spacing: 6,
                children: [500, 1000, 2500, 5000, 10000].map((amt) {
                  return InkWell(
                    onTap: () {
                      _amountController.text = amt.toString();
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Text(
                        '+₹$amt',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Notes / Details
              Text(
                AppStrings.tr(loc, en: 'Details / Note (Optional):', mr: 'तपशील / टीप (पर्यायी):', hi: 'विवरण / नोट (वैकल्पिक):', te: 'వివరాలు / గమనిక:', kn: 'ವಿವರಗಳು / ಟಿಪ್ಪಣಿ:', gu: 'વિગતો / નોંધ:'),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: AppStrings.tr(loc, en: 'e.g. 2 bags DAP or 5 labor charges', mr: 'उदा. २ पोती DAP किंवा ५ मजुरांची मजुरी', hi: 'उदा. २ बोरी DAP या ५ मजदूर मजदूरी', te: 'ఉదా. 2 బస్తాలు DAP లేదా కూలి ఖర్చులు', kn: 'ಉದಾ. 2 ಚೀಲ ಡಿಎಪಿ ಅಥವಾ ಕೂಲಿ ವೆಚ್ಚ', gu: 'દા.ત. ૨ થેલી DAP અથવા ૫ મજૂર ખર્ચ'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 18),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final amt = double.tryParse(_amountController.text.trim());
                    if (amt == null || amt <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppStrings.tr(loc, en: 'Please enter a valid amount', mr: 'कृपया योग्य रक्कम टाका', hi: 'कृपया सही रकम दर्ज करें', te: 'దయచేసి సరైన మొత్తం నమోదు చేయండి', kn: 'ದಯವಿಟ್ಟು ಮಾನ್ಯ ಮೊತ್ತವನ್ನು ನಮೂದಿಸಿ', gu: 'કૃપા કરીને માન્ય રકમ દાખલ કરો')),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    khataVm.addEntry(
                      cropName: selectedCrop,
                      category: selectedCatId,
                      categoryLabelMr: selectedCatLabel,
                      type: isExpense ? 'expense' : 'income',
                      amount: amt,
                      notes: _notesController.text.trim(),
                    );

                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isExpense
                              ? AppStrings.tr(loc, en: '✓ Expense logged successfully!', mr: '✓ खर्च यशस्वीरीत्या नोंदवला!', hi: '✓ खर्च सफलतापूर्वक दर्ज किया गया!', te: '✓ ఖర్చు విజయవంతంగా నమోదు చేయబడింది!', kn: '✓ ವೆಚ್ಚ ಯಶಸ್ವಿಯಾಗಿ ದಾಖಲಾಗಿದೆ!', gu: '✓ ખર્ચ સફળતાપૂર્વક નોંધાયો!')
                              : AppStrings.tr(loc, en: '✓ Income logged successfully!', mr: '✓ उत्पन्न यशस्वीरीत्या नोंदवले!', hi: '✓ आय सफलतापूर्वक दर्ज की गई!', te: '✓ ఆదాయం విజయవంతంగా నమోదు చేయబడింది!', kn: '✓ ಆದಾಯ ಯಶಸ್ವಿಯಾಗಿ ದಾಖಲಾಗಿದೆ!', gu: '✓ આવક સફળતાપૂર્વક નોંધાઈ!'),
                        ),
                        backgroundColor: isExpense ? Colors.red.shade700 : AppColors.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isExpense ? Colors.red.shade700 : AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isExpense
                        ? AppStrings.tr(loc, en: 'Save Expense', mr: 'खर्च सेव्ह करा', hi: 'खर्च सहेजें', te: 'ఖర్చు సేవ్ చేయండి', kn: 'ವೆಚ್ಚ ಉಳಿಸಿ', gu: 'ખર્ચ સાચવો')
                        : AppStrings.tr(loc, en: 'Save Income', mr: 'उत्पन्न सेव्ह करा', hi: 'आय सहेजें', te: 'ఆదాయం సేవ్ చేయండి', kn: 'ಆದಾಯ ಉಳಿಸಿ', gu: 'આવક સાચવો'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
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
    final khataVm = context.watch<KhataViewModel>();
    final authVm = context.watch<AuthViewModel>();
    final loc = authVm.locale;

    final crops = [
      {'id': 'all', 'label': AppStrings.tr(loc, en: 'All Crops', mr: 'सर्व पिके', hi: 'सभी फसलें', te: 'అన్ని పంటలు', kn: 'ಎಲ್ಲಾ ಬೆಳೆಗಳು', gu: 'તમામ પાક')},
      {'id': 'सोयाबीन', 'label': AppStrings.tr(loc, en: '🌱 Soybean', mr: '🌱 सोयाबीन', hi: '🌱 सोयाबीन', te: '🌱 సోయాబీన్', kn: '🌱 ಸೋಯಾಬೀನ್', gu: '🌱 સોયાબીન')},
      {'id': 'कापूस', 'label': AppStrings.tr(loc, en: '☁️ Cotton', mr: '☁️ कापूस', hi: '☁️ कपास', te: '☁️ పత్తి', kn: '☁️ ಹತ್ತಿ', gu: '☁️ કપાસ')},
      {'id': 'ऊस', 'label': AppStrings.tr(loc, en: '🎋 Sugarcane', mr: '🎋 ऊस', hi: '🎋 गन्ना', te: '🎋 చెరకు', kn: '🎋 ಕಬ್ಬು', gu: '🎋 શેરડી')},
      {'id': 'कांदा', 'label': AppStrings.tr(loc, en: '🧅 Onion', mr: '🧅 कांदा', hi: '🧅 प्याज', te: '🧅 ఉల్లిపాయ', kn: '🧅 ಈರುಳ್ಳಿ', gu: '🧅 ડુંગળી')},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.get('farmKhata', locale: loc),
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Net Balance Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    khataVm.netProfit >= 0 ? const Color(0xFF165B33) : const Color(0xFFB91C1C),
                    khataVm.netProfit >= 0 ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Color(0x15000000), blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.tr(loc, en: 'Net In-Hand Profit', mr: 'हातात उरलेला निव्वळ नफा', hi: 'शुद्ध बचत / लाभ', te: 'చేతికి వచ్చే నికర లాభం', kn: 'ನಿವ್ವಳ ಲಾಭ', gu: 'ચોખ્ખો નફો'),
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'ROI ${khataVm.roiPercentage.toStringAsFixed(1)}%',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '₹${khataVm.netProfit.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.white24, height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.tr(loc, en: 'Total Revenue (Income)', mr: 'एकूण विक्री उत्पन्न (Revenue)', hi: 'कुल आय (Revenue)', te: 'మొత్తం అమ్మకాలు (ఆదాయం)', kn: 'ಒಟ್ಟು ಆದಾಯ', gu: 'કુલ આવક'),
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10),
                            ),
                            Text(
                              '₹${khataVm.totalIncome.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(width: 1, height: 30, color: Colors.white24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.tr(loc, en: 'Total Expenses', mr: 'एकूण खर्च (Expenses)', hi: 'कुल खर्च (Expenses)', te: 'మొత్తం ఖర్చులు', kn: 'ಒಟ್ಟು ವೆಚ್ಚಗಳು', gu: 'કુલ ખર્ચ'),
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 10),
                            ),
                            Text(
                              '₹${khataVm.totalExpense.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Action Buttons: + Add Expense / + Add Income
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddEntryDialog(context, khataVm, loc, isExpense: true),
                    icon: const Icon(Icons.remove_circle, size: 18),
                    label: Text(
                      AppStrings.tr(loc, en: 'Add Expense', mr: 'खर्च नोंदवा', hi: 'खर्च दर्ज करें', te: 'ఖర్చు నమోదు', kn: 'ವೆಚ್ಚ ದಾಖಲಿಸಿ', gu: 'ખર્ચ ઉમેરો'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddEntryDialog(context, khataVm, loc, isExpense: false),
                    icon: const Icon(Icons.add_circle, size: 18),
                    label: Text(
                      AppStrings.tr(loc, en: 'Add Income', mr: 'उत्पन्न नोंदवा', hi: 'आय दर्ज करें', te: 'ఆదాయం నమోదు', kn: 'ಆದಾಯ ದಾಖಲಿಸಿ', gu: 'આવક ઉમેરો'),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
            const SizedBox(height: 14),

            // Crop Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: crops.map((c) {
                  final isSel = khataVm.selectedCrop == c['id'];
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
                      onSelected: (_) => khataVm.setCropFilter(c['id']!),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // Transaction History Timeline
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.tr(loc, en: 'Transaction History:', mr: 'खर्च व जमा व्यवहार इतिहास (History):', hi: 'लेन-देन इतिहास:', te: 'లావాదేవీల చరిత్ర:', kn: 'ವಹಿವಾಟು ಇತಿಹಾಸ:', gu: 'વ્યવહાર ઇતિહાસ:'),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text(
                  '${khataVm.filteredEntries.length} ${AppStrings.tr(loc, en: "entries", mr: "नोंदी", hi: "प्रविष्टियां", te: "నమోదులు", kn: "ದಾಖಲೆಗಳು", gu: "નોંધ")}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ...khataVm.filteredEntries.map((e) {
              final isMr = loc == 'mr';
              final label = !isMr
                  ? (e.isExpense
                      ? (KhataEntry.expenseCategories.firstWhere((c) => c['id'] == e.category, orElse: () => {})['labelShortEn'] ?? e.categoryLabelMr)
                      : (KhataEntry.incomeCategories.firstWhere((c) => c['id'] == e.category, orElse: () => {})['labelShortEn'] ?? e.categoryLabelMr))
                  : e.categoryLabelMr;

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: e.isExpense ? Colors.red.shade50 : Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        e.isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                        size: 18,
                        color: e.isExpense ? Colors.red.shade700 : Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                label,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  e.cropName.split(' ').first,
                                  style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                          if (e.notes.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              e.notes,
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          const SizedBox(height: 2),
                          Text(
                            '${e.date.day}/${e.date.month}/${e.date.year}',
                            style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${e.isExpense ? "-" : "+"}₹${e.amount.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: e.isExpense ? Colors.red.shade700 : AppColors.primary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => khataVm.deleteEntry(e.id),
                        ),
                      ],
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
