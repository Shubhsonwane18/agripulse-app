import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/khata_model.dart';
import '../services/storage_service.dart';

class KhataViewModel extends ChangeNotifier {
  List<KhataEntry> _entries = [];
  String _selectedCrop = 'all';

  KhataViewModel() {
    _loadEntries();
  }

  List<KhataEntry> get entries => _entries;
  String get selectedCrop => _selectedCrop;

  List<KhataEntry> get filteredEntries {
    if (_selectedCrop == 'all') return _entries;
    return _entries.where((e) => e.cropName.contains(_selectedCrop)).toList();
  }

  double get totalIncome {
    return filteredEntries
        .where((e) => e.isIncome)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get totalExpense {
    return filteredEntries
        .where((e) => e.isExpense)
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get netProfit => totalIncome - totalExpense;

  double get roiPercentage {
    if (totalExpense <= 0) return 0.0;
    return ((netProfit) / totalExpense) * 100;
  }

  void setCropFilter(String crop) {
    if (_selectedCrop != crop) {
      _selectedCrop = crop;
      notifyListeners();
    }
  }

  Future<void> addEntry({
    required String cropName,
    required String category,
    required String categoryLabelMr,
    required String type,
    required double amount,
    DateTime? date,
    String notes = '',
  }) async {
    final newEntry = KhataEntry(
      id: 'kh_${DateTime.now().millisecondsSinceEpoch}',
      cropName: cropName,
      category: category,
      categoryLabelMr: categoryLabelMr,
      type: type,
      amount: amount,
      date: date ?? DateTime.now(),
      notes: notes,
    );

    _entries.insert(0, newEntry);
    notifyListeners();
    await _persist();
  }

  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
    await _persist();
  }

  void _loadEntries() {
    final raw = StorageService.getKhataJson();
    if (raw != null && raw.isNotEmpty) {
      try {
        final list = jsonDecode(raw) as List;
        _entries = list.map((e) => KhataEntry.fromJson(e as Map<String, dynamic>)).toList();
        notifyListeners();
        return;
      } catch (e) {
        print('[KhataViewModel] load error: $e');
      }
    }
    // Fallback default realistic sample entries for farmer
    _entries = KhataEntry.getDefaultSampleEntries();
    notifyListeners();
  }

  Future<void> _persist() async {
    try {
      final jsonList = _entries.map((e) => e.toJson()).toList();
      await StorageService.saveKhataJson(jsonEncode(jsonList));
    } catch (e) {
      print('[KhataViewModel] persist error: $e');
    }
  }
}
