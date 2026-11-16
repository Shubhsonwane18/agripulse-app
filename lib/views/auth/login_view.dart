import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/supported_languages.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../main_nav_scaffold.dart';
import '../language/language_selection_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Mode: 0 = Phone OTP (Default), 1 = Email / Password
  int _authMode = 0;
  bool _isSignUp = false;

  // Phone OTP controllers
  final TextEditingController _phoneOtpController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _otpAutoFilled = false;
  bool _otpTriggered = false;

  // Email / Password controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneOtpController.addListener(() {
      final text = _phoneOtpController.text.trim();
      if (text.length >= 10 && !_otpTriggered) {
        setState(() {
          _otpTriggered = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _phoneOtpController.dispose();
    _otpController.dispose();
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

  void _autofillDummyOtp() {
    setState(() {
      _otpController.text = '123456';
      _otpAutoFilled = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('डमी OTP 123456 भरला आहे!'),
          ],
        ),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _submitPhoneOtp(AuthViewModel authVm) async {
    final phone = _phoneOtpController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृपया १० अंकी मोबाईल नंबर टाका'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // If OTP is empty, default fill with 123456 for instant convenience
    if (_otpController.text.trim().isEmpty) {
      _otpController.text = '123456';
      _otpAutoFilled = true;
    }

    final otp = _otpController.text.trim();
    final ok = await authVm.loginWithPhoneOtp(
      phone: phone,
      otp: otp,
      customName: 'शेतकरी ($phone)',
    );

    if (ok && mounted) {
      _onSuccess(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final loc = authVm.locale;
    final currentLang = SupportedLanguages.findByCode(loc);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Language Switcher Bar
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LanguageSelectionView(isFirstTime: false),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.language_rounded, color: AppColors.primary, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '${currentLang.nativeName} (${currentLang.englishName})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Brand Emblem
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.eco, color: AppColors.primary, size: 44),
                ),
                const SizedBox(height: 8),
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
                      child: Text(
                        AppStrings.get('appHindiName', locale: loc),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  AppStrings.get('tagline', locale: loc),
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 18),

                // 1-Click Instant Demo Login Banner
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
                      if (context.mounted) _onSuccess(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.bolt, color: Colors.amber, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              AppStrings.get('demoLogin', locale: loc),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppStrings.get('demoSub', locale: loc),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Main Login Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: const [
                      BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Auth Mode Tabs: 0 = Mobile OTP, 1 = Email/Password
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _authMode = 0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                    color: _authMode == 0 ? AppColors.primary : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.phone_android_rounded,
                                          size: 16,
                                          color: _authMode == 0 ? Colors.white : AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          authVm.isMr ? 'मोबाईल OTP' : (authVm.isHi ? 'मोबाइल OTP' : 'Phone OTP'),
                                          style: TextStyle(
                                            color: _authMode == 0 ? Colors.white : AppColors.textSecondary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _authMode = 1),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 9),
                                  decoration: BoxDecoration(
                                    color: _authMode == 1 ? AppColors.primary : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.email_outlined,
                                          size: 16,
                                          color: _authMode == 1 ? Colors.white : AppColors.textSecondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          authVm.isMr ? 'ईमेल लॉगिन' : (authVm.isHi ? 'ईमेल लॉगिन' : 'Email Login'),
                                          style: TextStyle(
                                            color: _authMode == 1 ? Colors.white : AppColors.textSecondary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // TAB 0: Mobile OTP Flow
                      if (_authMode == 0) ...[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            authVm.isMr ? 'आपला १०-अंकी मोबाईल नंबर टाका' : 'Enter 10-Digit Mobile Number',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // 10-Digit Phone Input
                        TextField(
                          controller: _phoneOtpController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          decoration: InputDecoration(
                            counterText: '',
                            prefixIcon: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('🇮🇳', style: TextStyle(fontSize: 18)),
                                  SizedBox(width: 4),
                                  Text(
                                    '+91',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  ),
                                  SizedBox(width: 6),
                                  Text('|', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            hintText: '98765 43210',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // OTP Section (Appears when 10 digits entered or triggered)
                        if (_otpTriggered || _phoneOtpController.text.length >= 10) ...[
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.mark_email_read_outlined, size: 18, color: AppColors.primary),
                                        const SizedBox(width: 6),
                                        Text(
                                          authVm.isMr ? 'SMS द्वारे OTP पाठवला आहे' : 'OTP Sent via SMS',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: AppColors.primary),
                                      ),
                                      child: const Text(
                                        '6-Digits',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // OTP Field
                                TextField(
                                  controller: _otpController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    letterSpacing: 8,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    hintText: '• • • • • •',
                                    hintStyle: const TextStyle(letterSpacing: 6, color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(color: AppColors.primary),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Prominent "Autofill Dummy OTP (123456)" Button
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton.icon(
                                    onPressed: _autofillDummyOtp,
                                    icon: const Icon(Icons.bolt, color: Colors.amber, size: 18),
                                    label: Text(
                                      authVm.isMr
                                          ? '⚡ ऑटो-फिल डमी OTP (123456)'
                                          : (authVm.isHi ? '⚡ ऑटो-फिल डमी OTP (123456)' : '⚡ Autofill Dummy OTP (123456)'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),

                                if (_otpAutoFilled) ...[
                                  const SizedBox(height: 6),
                                  const Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.green, size: 14),
                                        SizedBox(width: 4),
                                        Text(
                                          '✓ OTP आपोआप भरला गेला आहे',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Open App Button
                          ElevatedButton(
                            onPressed: authVm.isLoading ? null : () => _submitPhoneOtp(authVm),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: authVm.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.login, color: Colors.white, size: 18),
                                      const SizedBox(width: 6),
                                      Text(
                                        authVm.isMr
                                            ? 'सत्यापित करा व ॲप उघडा ➔'
                                            : (authVm.isHi ? 'सत्यापित करें और ऐप खोलें ➔' : 'Verify & Open App ➔'),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ] else ...[
                          // Button to trigger OTP if length not yet 10
                          ElevatedButton(
                            onPressed: () {
                              if (_phoneOtpController.text.length < 10) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('कृपया पूर्ण १०-अंकी नंबर टाका'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                setState(() => _otpTriggered = true);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              minimumSize: const Size.fromHeight(46),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text(
                              authVm.isMr ? 'OTP मागवा (Get OTP)' : 'Get OTP',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ] else ...[
                        // TAB 1: Email / Password Flow
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _isSignUp = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: !_isSignUp ? AppColors.primaryLight : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppStrings.get('signIn', locale: loc),
                                      style: TextStyle(
                                        color: !_isSignUp ? AppColors.primary : AppColors.textSecondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
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
                                  decoration: BoxDecoration(
                                    color: _isSignUp ? AppColors.primaryLight : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppStrings.get('signUp', locale: loc),
                                      style: TextStyle(
                                        color: _isSignUp ? AppColors.primary : AppColors.textSecondary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

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
                          const SizedBox(height: 10),
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
                          const SizedBox(height: 10),
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
                        const SizedBox(height: 10),

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
                        const SizedBox(height: 14),

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
                                    if (ok && context.mounted) _onSuccess(context);
                                  } else {
                                    final ok = await authVm.signIn(email, pass);
                                    if (ok && context.mounted) _onSuccess(context);
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
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Reassurance Cross-platform Sync Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.verified_user_outlined, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      AppStrings.get('syncNotice', locale: loc),
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
