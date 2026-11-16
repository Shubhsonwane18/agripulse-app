import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 4);

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();

    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'किसानमित्र',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 11,
              ),
            ),
        ],
      ),
      actions: [
        // Language Selector Chip
        PopupMenuButton<String>(
          initialValue: authVm.locale,
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  authVm.isMr ? 'मराठी' : (authVm.isHi ? 'हिंदी' : 'EN'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          onSelected: (loc) => authVm.setLocale(loc),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'mr', child: Text('मराठी (Marathi)')),
            const PopupMenuItem(value: 'hi', child: Text('हिंदी (Hindi)')),
            const PopupMenuItem(value: 'en', child: Text('English')),
          ],
        ),
        if (actions != null) ...actions!,
        const SizedBox(width: 8),
      ],
    );
  }
}
