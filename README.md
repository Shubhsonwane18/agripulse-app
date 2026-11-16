# AgriPulse (किसानमित्र) Flutter Mobile App — MVVM Architecture

The mobile application for **AgriPulse-AI (किसानमित्र)**, built using Flutter and the **Model-View-ViewModel (MVVM)** design pattern with `Provider`.

---

## 🚀 Key Features & Shared Services with Web

1. **Unified Authentication & Real-Time Sync**:
   - Shares the exact same Supabase database (`profiles` table) and authentication provider as the Next.js web application.
   - Any updates made in the web app (farmer location, land size, crop portfolio, language preference) are automatically synced to the mobile app and vice-versa.
   - Includes **1-Click Demo Farmer Mode** (Ramesh Patil - Shirol, Kolhapur) for instant access without password barriers.

2. **Hyperlocal Weather & MOS Downscaling**:
   - 2-km farm-level microclimate downscaling via Open-Meteo and IMD/CHIRPS calibrated GradientBoosting model.
   - 24-hour spraying window timeline with convective downpour warnings, rain wash-off lockout, and wind drift hazards.
   - 7-day agronomic forecast with university advisory.

3. **Mandi Net Arbitrage & Logistics Calculator**:
   - Mathematically computes true in-hand cash after diesel, tolls, handling, and APMC cess deductions across nearby candidate yards.
   - Supports Tata Ace, Pickup 407, Tractor Trolley, and Three-Wheeler vehicle efficiencies.

4. **Leaf Disease Scanner & Agronomy Guard**:
   - Real-time camera & gallery leaf analysis.
   - Provides CIBRC approved chemical prescriptions (dosages, water volume, waiting periods) cross-validated with active weather spraying windows.

5. **KisanMitra Multilingual Voice Assistant**:
   - Voice note recording and playback supporting Marathi, Hindi, and English.
   - Context-aware agronomic query resolution.

6. **Soil Health NPK & Fertilizer Calculator**:
   - Soil test parameter adjustment (N, P, K, pH) with ICAR-standard Urea, DAP, and MOP bag dosage recommendations.

7. **Agri Input Store**:
   - Curated agricultural inputs catalog with shopping cart and direct order placement.

---

## 📁 MVVM Architecture & Directory Layout

```text
mobile/
├── pubspec.yaml                       # Dependencies (provider, http, geolocator, etc.)
├── android/app/src/main/AndroidManifest.xml
└── lib/
    ├── main.dart                      # App entrypoint, Theme, MultiProvider setup
    ├── constants/
    │   ├── api_constants.dart         # FastAPI backend & Supabase configuration
    │   ├── app_colors.dart            # Emerald & Forest Green (#165b33) palette
    │   └── app_strings.dart           # Marathi, Hindi, English translations
    ├── models/                        # Domain models matching FastAPI schemas
    │   ├── user_model.dart            # User profile synced with web Supabase
    │   ├── weather_model.dart         # Hourly slots, daily forecast, MOS metrics
    │   ├── mandi_model.dart           # Mandi candidates & net profit rankings
    │   ├── disease_model.dart         # Pathology diagnosis & CIBRC prescriptions
    │   ├── chat_model.dart            # Chat messages & voice notes
    │   ├── store_model.dart           # Products & cart items
    │   ├── soil_model.dart            # Soil NPK & ICAR recommendations
    │   └── village_model.dart         # LGD directory records
    ├── services/                      # Data providers & network clients
    │   ├── api_service.dart           # FastAPI REST client (Arbitrage, Weather, Disease)
    │   ├── auth_service.dart          # Supabase Auth client & cloud profile sync
    │   ├── storage_service.dart       # Offline cache & SharedPreferences
    │   └── location_service.dart      # GPS auto-detection
    ├── viewmodels/                    # MVVM State Management (ChangeNotifiers)
    │   ├── auth_viewmodel.dart        # Session, sync, profile, language
    │   ├── weather_viewmodel.dart     # Spray windows, MOS downscaler
    │   ├── mandi_viewmodel.dart       # Net profit ranker, vehicle mileage
    │   ├── disease_viewmodel.dart     # Leaf image diagnosis, chemical dosage
    │   ├── chat_viewmodel.dart        # Voice note recording, KisanMitra chat
    │   ├── soil_viewmodel.dart        # Soil NPK calculations
    │   └── store_viewmodel.dart       # Product catalog, cart & checkout
    └── views/                         # Flutter UI Widgets
        ├── main_nav_scaffold.dart     # Bottom navigation & drawer
        ├── home/home_view.dart        # Farmer microclimate dashboard
        ├── weather/weather_view.dart  # MOS downscaling timeline & spray guard
        ├── markets/markets_view.dart  # Mandi net arbitrage ranker
        ├── disease/disease_scanner_view.dart # Leaf scanner & CIBRC dosage
        ├── chat/chat_view.dart        # KisanMitra voice chat
        ├── soil/soil_advisory_view.dart # Soil health calculator
        ├── store/store_view.dart      # Agri input store & cart
        ├── profile/profile_view.dart  # Farmer profile & sync settings
        └── auth/login_view.dart       # 1-Click demo & unified cloud sign in
```

---

## 🛠️ How to Run the App

1. Ensure Flutter SDK 3.19+ is installed.
2. Install dependencies:
   ```bash
   cd mobile
   flutter pub get
   ```
3. Run on connected device or emulator:
   ```bash
   flutter run
   ```
4. Build release APK:
   ```bash
   flutter build apk --release
   ```
