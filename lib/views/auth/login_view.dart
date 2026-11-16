import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../main_nav_scaffold.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isSignUp = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSuccess(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavScaffold()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final loc = authVm.locale;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Brand Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.eco, color: AppColors.primary, size: 48),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'AgriPulse',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'किसानमित्र',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.get('tagline', locale: loc),
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),

                // 1-Click Demo Login Button (Immediate zero-friction entry)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF165B33), Color(0xFF10B981)],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x25165B33),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      await authVm.loginAsDemo();
                      _onSuccess(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppStrings.get('demoLogin', locale: loc),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          AppStrings.get('demoSub', locale: loc),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Or Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        authVm.isMr ? 'किंवा ईमेलने सुरू ठेवा' : 'Or continue with email',
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    children: [
                      // Mode Selector Tabs (Sign In / Sign Up)
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _isSignUp = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: !_isSignUp ? AppColors.primary : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  AppStrings.get('signIn', locale: loc),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: !_isSignUp ? AppColors.primary : AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _isSignUp = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _isSignUp ? AppColors.primary : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  AppStrings.get('signUp', locale: loc),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _isSignUp ? AppColors.primary : AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (_isSignUp) ...[
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: AppStrings.get('fullNameLabel', locale: loc),
                            prefixIcon: const Icon(Icons.person_outline, size: 20),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: AppStrings.get('phoneLabel', locale: loc),
                            prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: AppStrings.get('emailLabel', locale: loc),
                          prefixIcon: const Icon(Icons.email_outlined, size: 20),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: AppStrings.get('passwordLabel', locale: loc),
                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (authVm.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            authVm.errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 11),
                          ),
                        ),

                      ElevatedButton(
                        onPressed: authVm.isLoading
                            ? null
                            : () async {
                                final email = _emailController.text.trim();
                                final pass = _passwordController.text.trim();
                                if (email.isEmpty || pass.isEmpty) return;

                                if (_isSignUp) {
                                  final name = _nameController.text.trim();
                                  final phone = _phoneController.text.trim();
                                  final ok = await authVm.signUp(
                                    email: email,
                                    password: pass,
                                    fullName: name.isNotEmpty ? name : 'शेतकरी',
                                    phone: phone,
                                  );
                                  if (ok) _onSuccess(context);
                                } else {
                                  final ok = await authVm.signIn(email, pass);
                                  if (ok) _onSuccess(context);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: authVm.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                _isSignUp
                                    ? AppStrings.get('signUp', locale: loc)
                                    : AppStrings.get('signIn', locale: loc),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Reassurance Cross-platform Sync Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      authVm.isMr
                          ? 'वेब आणि ॲपमध्ये एकाच खात्यावरून संपूर्ण डेटा थेट सिंक'
                          : '100% Unified Cloud Sync with AgriPulse Web App',
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
