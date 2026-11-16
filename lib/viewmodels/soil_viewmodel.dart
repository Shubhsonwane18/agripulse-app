import 'package:flutter/foundation.dart';
import '../models/soil_model.dart';

class SoilViewModel extends ChangeNotifier {
  SoilTestInput _currentInput = SoilTestInput();
  SoilAdvisoryResult? _result;

  SoilViewModel() {
    calculateAdvisory();
  }

  SoilTestInput get currentInput => _currentInput;
  SoilAdvisoryResult? get result => _result;

  void updateInputs({
    double? nitrogen,
    double? phosphorus,
    double? potassium,
    double? ph,
    double? electricalConductivity,
    double? organicCarbon,
    String? targetCrop,
    double? acreage,
  }) {
    _currentInput = SoilTestInput(
      nitrogen: nitrogen ?? _currentInput.nitrogen,
      phosphorus: phosphorus ?? _currentInput.phosphorus,
      potassium: potassium ?? _currentInput.potassium,
      ph: ph ?? _currentInput.ph,
      electricalConductivity: electricalConductivity ?? _currentInput.electricalConductivity,
      organicCarbon: organicCarbon ?? _currentInput.organicCarbon,
      targetCrop: targetCrop ?? _currentInput.targetCrop,
      acreage: acreage ?? _currentInput.acreage,
    );
    calculateAdvisory();
  }

  void calculateAdvisory() {
    _result = SoilAdvisoryResult.calculate(_currentInput);
    notifyListeners();
  }
}
