import 'package:flutter/foundation.dart';
import '../models/soil_model.dart';
import '../models/crop_tracker_model.dart';

class SoilViewModel extends ChangeNotifier {
  SoilTestInput _currentInput = SoilTestInput();
  SoilAdvisoryResult? _result;
  GeoSoilProfile? _detectedSoil;
  CropTrackerData _cropTracker = const CropTrackerData();
  CropPriceForecast? _priceForecast;

  SoilViewModel() {
    calculateAdvisory();
    detectFromCoordinates(lat: 16.71, lon: 74.59, district: 'Kolhapur', village: 'Shirol');
    _updateForecast();
  }

  SoilTestInput get currentInput => _currentInput;
  SoilAdvisoryResult? get result => _result;
  GeoSoilProfile get detectedSoil => _detectedSoil ?? GeoSoilProfile.detectFromLocation();
  CropTrackerData get cropTracker => _cropTracker;
  CropPriceForecast get priceForecast => _priceForecast ?? CropPriceForecast.predict(_cropTracker.growingCrop, _cropTracker.storedStockQuintals);

  void detectFromCoordinates({double? lat, double? lon, String? district, String? village}) {
    _detectedSoil = GeoSoilProfile.detectFromLocation(
      lat: lat,
      lon: lon,
      district: district,
      village: village,
    );
    notifyListeners();
  }

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

  void updateCropTracker({
    String? growingCrop,
    String? cropStage,
    double? acreage,
    double? storedStockQuintals,
    String? storageLocation,
  }) {
    _cropTracker = _cropTracker.copyWith(
      growingCrop: growingCrop,
      cropStage: cropStage,
      acreage: acreage,
      storedStockQuintals: storedStockQuintals,
      storageLocation: storageLocation,
    );
    _updateForecast();
    notifyListeners();
  }

  void _updateForecast() {
    _priceForecast = CropPriceForecast.predict(
      _cropTracker.growingCrop,
      _cropTracker.storedStockQuintals,
    );
  }
}

