import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../auth/login_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.currentUser;
    final loc = authVm.locale;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          AppStrings.get('navProfile', locale: loc),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      user?.fullName.isNotEmpty == true ? user!.fullName[0] : 'श',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.fullName ?? 'शेतकरी (Farmer)',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    user?.phone ?? user?.email ?? '+91 98220 12345',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '📍 ${user?.village ?? "शिरोळ"}, ${user?.district ?? "कोल्हापूर"} • ${user?.landSizeAcres ?? 4.5} एकर',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Cloud Data Sync Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sync, color: Colors.blue, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Web & App ऑटोमॅटिक सिंक',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue),
                        ),
                        Text(
                          AppStrings.get('syncNotice', locale: loc),
                          style: TextStyle(fontSize: 11, color: Colors.blue.shade900),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Language Selector Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.get('language', locale: loc),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildLangChoice(authVm, 'mr', 'मराठी'),
                      const SizedBox(width: 8),
                      _buildLangChoice(authVm, 'hi', 'हिंदी'),
                      const SizedBox(width: 8),
                      _buildLangChoice(authVm, 'en', 'English'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sign out button
            OutlinedButton.icon(
              onPressed: () async {
                await authVm.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginView()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: Text(
                AppStrings.get('logout', locale: loc),
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangChoice(AuthViewModel vm, String code, String label) {
    final isSel = vm.locale == code;
    return Expanded(
      child: InkWell(
        onTap: () => vm.setLocale(code),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSel ? AppColors.primary : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSel ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
