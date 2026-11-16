import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'home/home_view.dart';
import 'markets/markets_view.dart';
import 'weather/weather_view.dart';
import 'disease/disease_scanner_view.dart';
import 'chat/chat_view.dart';
import 'soil/soil_advisory_view.dart';
import 'store/store_view.dart';
import 'profile/profile_view.dart';

class MainNavScaffold extends StatefulWidget {
  final int initialIndex;

  const MainNavScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainNavScaffold> createState() => _MainNavScaffoldState();
}

class _MainNavScaffoldState extends State<MainNavScaffold> {
  late int _currentIndex;

  final List<Widget> _views = const [
    HomeView(),
    MarketsView(),
    WeatherView(),
    DiseaseScannerView(),
    ChatView(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final loc = authVm.locale;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              accountName: Text(
                authVm.currentUser?.fullName ?? 'शेतकरी (Farmer)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              accountEmail: Text(
                '${authVm.currentUser?.village ?? "शिरोळ"}, ${authVm.currentUser?.district ?? "कोल्हापूर"} • ${authVm.currentUser?.landSizeAcres ?? 4.5} एकर',
                style: const TextStyle(fontSize: 12),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  authVm.currentUser?.fullName.isNotEmpty == true
                      ? authVm.currentUser!.fullName[0]
                      : 'क',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: AppColors.primary),
              title: Text(AppStrings.get('navHome', locale: loc)),
              selected: _currentIndex == 0,
              onTap: () {
                Navigator.pop(context);
                _onTabTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.trending_up, color: AppColors.primary),
              title: Text(AppStrings.get('navMarkets', locale: loc)),
              selected: _currentIndex == 1,
              onTap: () {
                Navigator.pop(context);
                _onTabTapped(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud, color: AppColors.primary),
              title: Text(AppStrings.get('navWeather', locale: loc)),
              selected: _currentIndex == 2,
              onTap: () {
                Navigator.pop(context);
                _onTabTapped(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: Text(AppStrings.get('navDisease', locale: loc)),
              selected: _currentIndex == 3,
              onTap: () {
                Navigator.pop(context);
                _onTabTapped(3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.record_voice_over, color: AppColors.primary),
              title: Text(AppStrings.get('navChat', locale: loc)),
              selected: _currentIndex == 4,
              onTap: () {
                Navigator.pop(context);
                _onTabTapped(4);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.science, color: Colors.teal),
              title: Text(AppStrings.get('navSoil', locale: loc)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SoilAdvisoryView()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag, color: Colors.indigo),
              title: Text(AppStrings.get('navStore', locale: loc)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StoreView()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blueGrey),
              title: Text(AppStrings.get('navProfile', locale: loc)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileView()),
                );
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        backgroundColor: Colors.white,
        indicatorColor: AppColors.accentLight,
        elevation: 8,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: AppColors.primary),
            label: AppStrings.get('navHome', locale: loc),
          ),
          NavigationDestination(
            icon: const Icon(Icons.trending_up_outlined),
            selectedIcon: const Icon(Icons.trending_up, color: AppColors.primary),
            label: AppStrings.get('navMarkets', locale: loc),
          ),
          NavigationDestination(
            icon: const Icon(Icons.cloud_outlined),
            selectedIcon: const Icon(Icons.cloud, color: AppColors.primary),
            label: AppStrings.get('navWeather', locale: loc),
          ),
          NavigationDestination(
            icon: const Icon(Icons.camera_alt_outlined),
            selectedIcon: const Icon(Icons.camera_alt, color: AppColors.primary),
            label: AppStrings.get('navDisease', locale: loc),
          ),
          NavigationDestination(
            icon: const Icon(Icons.record_voice_over_outlined),
            selectedIcon: const Icon(Icons.record_voice_over, color: AppColors.primary),
            label: AppStrings.get('navChat', locale: loc),
          ),
        ],
      ),
    );
  }
}
