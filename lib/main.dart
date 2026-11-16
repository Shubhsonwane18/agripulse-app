import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'constants/app_colors.dart';
import 'services/storage_service.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'viewmodels/mandi_viewmodel.dart';
import 'viewmodels/disease_viewmodel.dart';
import 'viewmodels/chat_viewmodel.dart';
import 'viewmodels/soil_viewmodel.dart';
import 'viewmodels/store_viewmodel.dart';
import 'views/main_nav_scaffold.dart';
import 'views/auth/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system navigation & status bar colors
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize offline local storage
  await StorageService.init();

  final apiService = ApiService();
  final authService = AuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(authService: authService)),
        ChangeNotifierProvider(create: (_) => WeatherViewModel(apiService: apiService)),
        ChangeNotifierProvider(create: (_) => MandiViewModel(apiService: apiService)),
        ChangeNotifierProvider(create: (_) => DiseaseViewModel(apiService: apiService)),
        ChangeNotifierProvider(create: (_) => ChatViewModel(apiService: apiService)),
        ChangeNotifierProvider(create: (_) => SoilViewModel()),
        ChangeNotifierProvider(create: (_) => StoreViewModel(apiService: apiService)),
      ],
      child: const AgriPulseApp(),
    ),
  );
}

class AgriPulseApp extends StatelessWidget {
  const AgriPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    return MaterialApp(
      title: 'AgriPulse (किसानमित्र)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          background: AppColors.background,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: authVm.isAuthenticated ? const MainNavScaffold() : const LoginView(),
    );
  }
}
