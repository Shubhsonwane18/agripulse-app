import 'package:flutter/foundation.dart';
import '../models/intercropping_model.dart';

class IntercroppingViewModel extends ChangeNotifier {
  final List<IntercropPlan> _plans = IntercropPlan.getProvenPlans();
  final List<CropRotationRule> _rotationRules = CropRotationRule.getRotationRules();
  String _selectedMainCrop = 'all';
  double _farmAcreage = 2.5;

  List<IntercropPlan> get plans => _plans;
  List<CropRotationRule> get rotationRules => _rotationRules;
  String get selectedMainCrop => _selectedMainCrop;
  double get farmAcreage => _farmAcreage;

  List<IntercropPlan> get filteredPlans {
    if (_selectedMainCrop == 'all') return _plans;
    return _plans.where((p) => p.mainCrop.contains(_selectedMainCrop)).toList();
  }

  void setMainCrop(String crop) {
    if (_selectedMainCrop != crop) {
      _selectedMainCrop = crop;
      notifyListeners();
    }
  }

  void setAcreage(double acreage) {
    if (acreage > 0 && _farmAcreage != acreage) {
      _farmAcreage = acreage;
      notifyListeners();
    }
  }

  double calculateProjectedExtraIncome(IntercropPlan plan) {
    return plan.extraIncomePerAcre * _farmAcreage;
  }
}
