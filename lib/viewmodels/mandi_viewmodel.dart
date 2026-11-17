import 'package:flutter/foundation.dart';
import '../models/mandi_model.dart';
import '../services/api_service.dart';
import '../services/mandi_directory_service.dart';

class MandiViewModel extends ChangeNotifier {
  final ApiService _apiService;

  double _weightQuintals = 25.0;
  String _selectedVehicle = 'tata_ace';
  final double _dieselPrice = 92.0;
  String _selectedCommodity = 'Soybean';

  StateLocation _selectedState = MandiDirectoryService.states.firstWhere(
    (s) => s.id == 'maharashtra',
    orElse: () => MandiDirectoryService.states.first,
  );

  CityLocation _selectedCity = MandiDirectoryService.cities.firstWhere(
    (c) => c.id == 'kolhapur',
    orElse: () => MandiDirectoryService.cities.first,
  );

  bool _isLoading = false;
  List<MandiEvaluation> _rankings = [];
  String? _errorMessage;

  MandiViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService() {
    calculateArbitrage();
  }

  double get weightQuintals => _weightQuintals;
  String get selectedVehicle => _selectedVehicle;
  double get dieselPrice => _dieselPrice;
  String get selectedCommodity => _selectedCommodity;
  StateLocation get selectedState => _selectedState;
  CityLocation get selectedCity => _selectedCity;
  List<StateLocation> get states => MandiDirectoryService.states;
  List<CityLocation> get citiesForSelectedState => MandiDirectoryService.getCitiesByState(_selectedState.id);
  bool get isLoading => _isLoading;
  List<MandiEvaluation> get rankings => _rankings;
  String? get errorMessage => _errorMessage;

  MandiEvaluation? get bestMandi => _rankings.isNotEmpty ? _rankings.first : null;
  MandiEvaluation? get nearestMandi {
    if (_rankings.isEmpty) return null;
    var sortedByDist = List<MandiEvaluation>.from(_rankings);
    sortedByDist.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return sortedByDist.first;
  }

  double get netProfitDelta {
    if (bestMandi != null && nearestMandi != null && bestMandi != nearestMandi) {
      return bestMandi!.netEarnings - nearestMandi!.netEarnings;
    }
    return 0.0;
  }

  void setStateLocation(StateLocation state) {
    if (_selectedState.id != state.id) {
      _selectedState = state;
      final citiesInState = MandiDirectoryService.getCitiesByState(state.id);
      _selectedCity = citiesInState.first;
      calculateArbitrage();
    }
  }

  void setCity(CityLocation city) {
    if (_selectedCity.id != city.id) {
      _selectedCity = city;
      final stateMatch = MandiDirectoryService.states.firstWhere(
        (s) => s.id == city.stateId,
        orElse: () => _selectedState,
      );
      _selectedState = stateMatch;
      calculateArbitrage();
    }
  }

  void setCityByName(String cityName) {
    final match = MandiDirectoryService.cities.firstWhere(
      (c) => c.nameEn.toLowerCase() == cityName.toLowerCase() ||
             c.nameMr == cityName ||
             c.id == cityName.toLowerCase(),
      orElse: () => _selectedCity,
    );
    setCity(match);
  }

  void setWeight(double weight) {
    if (weight > 0 && _weightQuintals != weight) {
      _weightQuintals = weight;
      _autoSelectVehicle(weight);
      calculateArbitrage();
    }
  }

  void setVehicle(String vehicleId) {
    if (_selectedVehicle != vehicleId) {
      _selectedVehicle = vehicleId;
      calculateArbitrage();
    }
  }

  void setCommodity(String commodity) {
    if (_selectedCommodity != commodity) {
      _selectedCommodity = commodity;
      calculateArbitrage();
    }
  }

  // Automatic Vehicle Selection based on harvest quantity
  String _autoSelectVehicle(double q) {
    String autoVehicleId;
    if (q <= 10) {
      autoVehicleId = 'three_wheeler';
    } else if (q <= 25) {
      autoVehicleId = 'tata_ace';
    } else if (q <= 60) {
      autoVehicleId = 'pickup_407';
    } else {
      autoVehicleId = 'tractor';
    }
    _selectedVehicle = autoVehicleId;
    return autoVehicleId;
  }

  Future<void> calculateArbitrage() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final candidates = MandiDirectoryService.getCandidatesForCropAndCity(
        cropId: _selectedCommodity,
        selectedCity: _selectedCity,
      );

      final result = await _apiService.calculateArbitrage(
        weightQuintals: _weightQuintals,
        vehicleType: _selectedVehicle,
        mandis: candidates,
      );

      _rankings = result;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
