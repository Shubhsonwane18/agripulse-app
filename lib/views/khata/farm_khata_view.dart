import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
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

  void _showAddEntryDialog(BuildContext context, KhataViewModel khataVm, {required bool isExpense, required bool isEn}) {
    _amountController.clear();
    _notesController.clear();

    String selectedCrop = isEn ? 'Soybean' : 'सोयाबीन (Soybean)';
    final categories = isExpense ? KhataEntry.expenseCategories : KhataEntry.incomeCategories;
    String selectedCatId = categories.first['id']!;
    String selectedCatLabel = isEn ? (categories.first['labelShortEn'] ?? 'Fertilizers') : categories.first['labelShort']!;

    final crops = isEn ? [
      'Soybean',
      'Cotton',
      'Sugarcane',
      'Onion',
      'Tur / Arhar',
      'Vegetables',
      'General Farm',
    ] : [
      'सोयाबीन (Soybean)',
      'कापूस (Cotton)',
      'ऊस (Sugarcane)',
      'कांदा (Onion)',
      'तूर (Tur)',
      'भाजीपाला (Vegetables)',
      'इतर शेतकाम (General Farm)',
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
                    isExpense ? (isEn ? 'Add New Farm Expense' : 'नवीन खर्च नोंदवा (Add Expense)') : (isEn ? 'Add New Farm Income' : 'नवीन उत्पन्न नोंदवा (Add Income)'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Crop Dropdown
              Text(isEn ? 'Associated Crop:' : 'संबंधित पीक:', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              DropdownButtonFormField<String>(
                value: selectedCrop,
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
              Text(isEn ? 'Category:' : 'खर्च / उत्पन्नाचा प्रकार:', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((cat) {
                    final isSel = selectedCatId == cat['id'];
                    final label = isEn ? (cat['labelShortEn'] ?? cat['labelShort']!) : cat['labelShort']!;
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() {
                              selectedCatId = cat['id']!;
                              selectedCatLabel = isEn ? (cat['labelShortEn'] ?? cat['labelShort']!) : cat['labelShort']!;
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),

              // Amount Input
              Text(isEn ? 'Amount (₹):' : 'रक्कम (₹ Amount):', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  hintText: '0.00',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 6),

              // Quick Amount Chips
              Row(
                children: [500, 1000, 2500, 5000].map((amt) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ActionChip(
                      label: Text('+₹$amt', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      backgroundColor: AppColors.background,
                      onPressed: () {
                        final current = double.tryParse(_amountController.text) ?? 0.0;
                        setModalState(() {
                          _amountController.text = (current + amt).toStringAsFixed(0);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),

              // Notes Input
              Text(isEn ? 'Details / Note (Optional):' : 'तपशील / टीप (पर्यायी):', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              TextField(
                controller: _notesController,
                decoration: InputDecoration(
                  hintText: isEn ? 'e.g. 2 bags DAP or 5 labor charges' : 'उदा. २ पोती DAP किंवा ५ मजुरांची मजुरी',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
              const SizedBox(height: 16),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final amt = double.tryParse(_amountController.text.trim()) ?? 0.0;
                    if (amt <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isEn ? 'Please enter a valid amount' : 'कृपया योग्य रक्कम टाका'), backgroundColor: Colors.red),
                      );
                      return;
                    }

                    await khataVm.addEntry(
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
                        content: Text(isExpense ? (isEn ? '✓ Expense logged successfully!' : '✓ खर्च यशस्वीरीत्या नोंदवला!') : (isEn ? '✓ Income logged successfully!' : '✓ उत्पन्न यशस्वीरीत्या नोंदवले!')),
                        backgroundColor: isExpense ? Colors.red.shade700 : AppColors.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isExpense ? Colors.red.shade700 : AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isExpense ? (isEn ? 'Save Expense' : 'खर्च सेव्ह करा') : (isEn ? 'Save Income' : 'उत्पन्न सेव्ह करा'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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

    final isEn = authVm.isEn;

    final crops = [
      {'id': 'all', 'label': isEn ? 'All Crops' : 'सर्व पिके (All)'},
      {'id': 'सोयाबीन', 'label': isEn ? '🌱 Soybean' : '🌱 सोयाबीन'},
      {'id': 'कापूस', 'label': isEn ? '☁️ Cotton' : '☁️ कापूस'},
      {'id': 'ऊस', 'label': isEn ? '🎋 Sugarcane' : '🎋 ऊस'},
      {'id': 'कांदा', 'label': isEn ? '🧅 Onion' : '🧅 कांदा'},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEn ? 'Farm P&L Ledger (Khata)' : 'शेतकरी नफा-तोटा वही (Farm Khata)',
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
                        isEn ? 'Net In-Hand Profit' : 'हातात उरलेला निव्वळ नफा',
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
                              isEn ? 'Total Revenue (Income)' : 'एकूण विक्री उत्पन्न (Revenue)',
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
                              isEn ? 'Total Expenses' : 'एकूण खर्च (Expenses)',
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
                    onPressed: () => _showAddEntryDialog(context, khataVm, isExpense: true, isEn: isEn),
                    icon: const Icon(Icons.remove_circle, size: 18),
                    label: Text(isEn ? 'Add Expense' : 'खर्च नोंदवा', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                    onPressed: () => _showAddEntryDialog(context, khataVm, isExpense: false, isEn: isEn),
                    icon: const Icon(Icons.add_circle, size: 18),
                    label: Text(isEn ? 'Add Income' : 'उत्पन्न नोंदवा', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
                  isEn ? 'Transaction History:' : 'खर्च व जमा व्यवहार इतिहास (History):',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text(
                  '${khataVm.filteredEntries.length} ${isEn ? "entries" : "नोंदी"}',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                Text(
                  '${khataVm.filteredEntries.length} नोंदी',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ...khataVm.filteredEntries.map((e) {
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
                                isEn ? (e.isExpense ? (KhataEntry.expenseCategories.firstWhere((c) => c['id'] == e.category, orElse: () => {})['labelShortEn'] ?? e.categoryLabelMr) : (KhataEntry.incomeCategories.firstWhere((c) => c['id'] == e.category, orElse: () => {})['labelShortEn'] ?? e.categoryLabelMr)) : e.categoryLabelMr,
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
