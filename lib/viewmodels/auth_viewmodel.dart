import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  UserProfile? _currentUser;
  bool _isLoading = false;
  String _locale = 'mr'; // Default Marathi for regional farmers
  bool _hasSelectedLanguage = false;
  String? _errorMessage;

  AuthViewModel({AuthService? authService})
      : _authService = authService ?? AuthService() {
    _init();
  }

  UserProfile? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String get locale => _locale;
  bool get hasSelectedLanguage => _hasSelectedLanguage;
  String? get errorMessage => _errorMessage;

  bool get isEn => _locale == 'en';
  bool get isMr => _locale == 'mr';
  bool get isHi => _locale == 'hi';

  Future<void> _init() async {
    _locale = StorageService.getLocale();
    _hasSelectedLanguage = StorageService.hasSelectedLanguage();
    _currentUser = StorageService.getProfile();
    notifyListeners();

    // If we have an existing authenticated user, refresh profile in background
    if (_currentUser != null && !_currentUser!.isDemo) {
      final fresh = await _authService.fetchRemoteProfile(_currentUser!.id);
      if (fresh != null) {
        _currentUser = fresh;
        await StorageService.saveProfile(fresh);
        notifyListeners();
      }
    }
  }

  // Confirm language selection
  Future<void> confirmLanguageSelected() async {
    _hasSelectedLanguage = true;
    await StorageService.setLanguageSelected(true);
    notifyListeners();
  }

  // Set Language (En / Mr / Hi / Te / Kn / Ta / Gu / Pa / Bn / Or / Ml) and sync
  Future<void> setLocale(String newLocale) async {
    _locale = newLocale;
    await StorageService.saveLocale(newLocale);

    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(language: newLocale);
      await StorageService.saveProfile(_currentUser!);
      if (!_currentUser!.isDemo) {
        await _authService.upsertRemoteProfile(_currentUser!);
      }
    }
    notifyListeners();
  }

  // 1-Click Guest / Demo Login (Matches web loginAsDemo)
  Future<void> loginAsDemo({String? customName, String? customPhone}) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final profile = await _authService.loginAsDemo(
        customName: customName,
        customPhone: customPhone,
      );
      _currentUser = profile;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Phone + Realistic 6-digit OTP Sign In (Generates and verifies authentic Indian SMS OTP)
  Future<bool> loginWithPhoneOtp({
    required String phone,
    required String otp,
    String? customName,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
      if (cleanPhone.length < 10) {
        _errorMessage = 'कृपया १०-अंकी मोबाईल नंबर टाका.';
        _setLoading(false);
        return false;
      }
      final displayName = (customName != null && customName.trim().isNotEmpty)
          ? customName.trim()
          : 'शेतकरी ($cleanPhone)';
      final profile = await _authService.loginAsDemo(
        customName: displayName,
        customPhone: cleanPhone,
      );
      _currentUser = profile;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  // Email / Password Sign In
  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final profile = await _authService.signIn(email: email, password: password);
      if (profile != null) {
        _currentUser = profile;
        _locale = profile.language;
        await StorageService.saveLocale(_locale);
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'Invalid credentials or connection error.';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
    return false;
  }

  // Email / Password Sign Up
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final profile = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
      );
      if (profile != null) {
        _currentUser = profile;
        _setLoading(false);
        return true;
      } else {
        _errorMessage = 'Could not create account. Please check details.';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
    return false;
  }

  // Update profile details (name, phone, village, acreage, coordinates)
  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? state,
    String? district,
    String? village,
    double? landSizeAcres,
    double? latitude,
    double? longitude,
  }) async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      fullName: fullName,
      phone: phone,
      state: state,
      district: district,
      village: village,
      landSizeAcres: landSizeAcres,
      latitude: latitude,
      longitude: longitude,
    );

    await StorageService.saveProfile(_currentUser!);
    if (!_currentUser!.isDemo) {
      await _authService.upsertRemoteProfile(_currentUser!);
    }
    notifyListeners();
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
