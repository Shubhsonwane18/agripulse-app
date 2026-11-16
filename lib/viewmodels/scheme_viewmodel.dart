import 'package:flutter/foundation.dart';
import '../models/scheme_model.dart';

class SchemeViewModel extends ChangeNotifier {
  final List<GovtScheme> _schemes = GovtScheme.getCuratedSchemes();
  String _selectedCategory = 'all';
  String _searchQuery = '';

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<GovtScheme> get filteredSchemes {
    return _schemes.where((s) {
      final matchesCategory = _selectedCategory == 'all' || s.category == _selectedCategory;
      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = query.isEmpty ||
          s.title.toLowerCase().contains(query) ||
          s.titleMr.toLowerCase().contains(query) ||
          s.subsidyText.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void setCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
