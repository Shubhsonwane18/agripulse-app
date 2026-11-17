import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/supported_languages.dart';
import '../../models/user_model.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../auth/login_view.dart';
import '../language/language_selection_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  void _showEditProfileDialog(BuildContext context, AuthViewModel authVm, UserProfile? user) {
    final nameCtrl = TextEditingController(text: user?.fullName ?? '');
    final phoneCtrl = TextEditingController(text: user?.phone ?? '');
    final villageCtrl = TextEditingController(text: user?.village ?? 'Shirol');
    final districtCtrl = TextEditingController(text: user?.district ?? 'Kolhapur');
    final acresCtrl = TextEditingController(text: (user?.landSizeAcres ?? 4.5).toString());
    final loc = authVm.locale;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.edit_note_rounded, color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppStrings.tr(
                        loc,
                        en: 'Edit Farm & Profile Details',
                        mr: 'शेतकरी व शेतजमीन तपशील संपादित करा',
                        hi: 'खेत व किसान विवरण संपादित करें',
                        te: 'వ్యవసాయ & ప్రొఫైల్ వివరాలు సవరించండి',
                        kn: 'ಕೃಷಿ ಮತ್ತು ಪ್ರೊಫೈಲ್ ವಿವರಗಳನ್ನು ಸಂಪಾದಿಸಿ',
                        gu: 'ખેતી અને પ્રોફાઇલ વિગતો સંપાદિત કરો',
                      ),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.tr(loc, en: 'Farmer Full Name:', mr: 'शेतकऱ्याचे पूर्ण नाव:', hi: 'किसान का पूरा नाम:', te: 'రైతు పూర్తి పేరు:', kn: 'ರೈತನ ಪೂರ್ಣ ಹೆಸರು:', gu: 'ખેડૂતનું પૂરું નામ:'),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  hintText: AppStrings.tr(loc, en: 'e.g. Ramesh Patil', mr: 'उदा. रमेश पाटील', hi: 'उदा. रमेश पाटिल', te: 'ఉదా. రమేష్ పాటిల్', kn: 'ಉದಾ. ರಮೇಶ್ ಪಾಟೀಲ್', gu: 'દા.ત. રમેશ પાટીલ'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.tr(loc, en: 'Mobile / WhatsApp Number:', mr: 'मोबाईल / व्हॉट्सअ‍ॅप नंबर:', hi: 'मोबाइल / व्हाट्सएप नंबर:', te: 'మొబైల్ / వాట్సాప్ నంబర్:', kn: 'ಮೊಬೈಲ್ / ವಾಟ್ಸಾಪ್ ಸಂಖ್ಯೆ:', gu: 'મોબાઇલ / વ્હોટ્સએપ નંબર:'),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '+91 98220 12345',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.tr(loc, en: 'Village:', mr: 'गाव:', hi: 'गांव:', te: 'గ్రామం:', kn: 'ಗ್ರಾಮ:', gu: 'ગામ:'),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: villageCtrl,
                          decoration: InputDecoration(
                            hintText: 'e.g. Shirol',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.tr(loc, en: 'District / City:', mr: 'जिल्हा / शहर:', hi: 'जिला / शहर:', te: 'జిల్లా / నగరం:', kn: 'ಜಿಲ್ಲೆ / ನಗರ:', gu: 'જિલ્લો / શહેર:'),
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: districtCtrl,
                          decoration: InputDecoration(
                            hintText: 'e.g. Kolhapur',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.tr(loc, en: 'Total Farmland (Acres):', mr: 'एकूण शेतजमीन (एकर):', hi: 'कुल कृषि भूमि (एकड़):', te: 'మొత్తం వ్యవసాయ భూమి (ఎకరాలు):', kn: 'ಒಟ್ಟು ಕೃಷಿ ಭೂಮಿ (ಎಕರೆ):', gu: 'કુલ ખેતીની જમીન (એકર):'),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: acresCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: '4.5',
                  suffixText: AppStrings.tr(loc, en: 'Acres', mr: 'एकर', hi: 'एकड़', te: 'ఎకరాలు', kn: 'ಎಕರೆ', gu: 'એકર'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final acres = double.tryParse(acresCtrl.text.trim()) ?? (user?.landSizeAcres ?? 4.5);
                    await authVm.updateProfile(
                      fullName: nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : user?.fullName,
                      phone: phoneCtrl.text.trim().isNotEmpty ? phoneCtrl.text.trim() : user?.phone,
                      village: villageCtrl.text.trim().isNotEmpty ? villageCtrl.text.trim() : user?.village,
                      district: districtCtrl.text.trim().isNotEmpty ? districtCtrl.text.trim() : user?.district,
                      landSizeAcres: acres,
                    );
                    if (ctx.mounted) Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppStrings.tr(
                            loc,
                            en: '✓ Profile details saved successfully!',
                            mr: '✓ शेतकरी तपशील यशस्वीरीत्या सेव्ह केला!',
                            hi: '✓ प्रोफाइल विवरण सफलतापूर्वक सहेजा गया!',
                            te: '✓ ప్రొఫైల్ వివరాలు విజయవంతంగా సేవ్ చేయబడ్డాయి!',
                            kn: '✓ ಪ್ರೊಫೈಲ್ ವಿವರಗಳನ್ನು ಯಶಸ್ವಿಯಾಗಿ ಉಳಿಸಲಾಗಿದೆ!',
                            gu: '✓ પ્રોફાઇલ વિગતો સફળતાપૂર્વક સાચવવામાં આવી!',
                          ),
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    AppStrings.tr(loc, en: 'Save Details', mr: 'माहिती सेव्ह करा', hi: 'विवरण सहेजें', te: 'వివరాలు సేవ్ చేయండి', kn: 'ವಿವರಗಳನ್ನು ಉಳಿಸಿ', gu: 'વિગતો સાચવો'),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.currentUser;
    final loc = authVm.locale;
    final currentLang = SupportedLanguages.findByCode(loc);

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
                      user?.fullName.isNotEmpty == true ? user!.fullName[0] : '👨‍🌾',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.fullName.isNotEmpty == true ? user!.fullName : AppStrings.tr(loc, en: 'Farmer', mr: 'शेतकरी', hi: 'किसान', te: 'రైతు', kn: 'ರೈತ', gu: 'ખેડૂત'),
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
                      '📍 ${user?.village ?? "Shirol"}, ${user?.district ?? "Kolhapur"} • ${user?.landSizeAcres ?? 4.5} ${AppStrings.tr(loc, en: "Acres", mr: "एकर", hi: "एकड़", te: "ఎకరాలు", kn: "ಎಕರೆ", gu: "એકર")}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => _showEditProfileDialog(context, authVm, user),
                    icon: const Icon(Icons.edit, size: 16, color: AppColors.primary),
                    label: Text(
                      AppStrings.tr(loc, en: 'Edit Farm Profile Details', mr: 'तपशील बदला / संपादित करा (Edit)', hi: 'खेत प्रोफाइल विवरण संपादित करें', te: 'వ్యవసాయ ప్రొఫైల్ సవరించండి', kn: 'ಕೃಷಿ ಪ್ರೊಫೈಲ್ ಸಂಪಾದಿಸಿ', gu: 'ખેતી પ્રોફાઇલ સંપાદિત કરો'),
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                        Text(
                          AppStrings.tr(loc, en: 'Automatic Cloud Data Sync', mr: 'वेब व ॲप ऑटोमॅटिक सिंक', hi: 'वेब एवं ऐप ऑटोमैटिक सिंक', te: 'వెబ్ & యాప్ ఆటోమేటిక్ సమకాలీకరణ', kn: 'ವೆಬ್ ಮತ್ತು ಆಪ್ ಸ್ವಯಂಚಾಲಿತ ಸಿಂಕ್', gu: 'વેબ અને એપ આપમેળે સમન્વયન'),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.translate_rounded, color: AppColors.primary, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.get('language', locale: loc),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LanguageSelectionView(isFirstTime: false),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.primary),
                        label: Text(
                          AppStrings.tr(loc, en: 'All Languages', mr: 'सर्व भाषा', hi: 'सभी भाषाएं', te: 'అన్ని భాషలు', kn: 'ಎಲ್ಲಾ ಭಾಷೆಗಳು', gu: 'તમામ ભાષાઓ'),
                          style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Currently active language banner
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LanguageSelectionView(isFirstTime: false),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Row(
                        children: [
                          Text(currentLang.icon, style: const TextStyle(fontSize: 22)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${currentLang.nativeName} (${currentLang.englishName})',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  currentLang.region,
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              AppStrings.tr(loc, en: 'Active', mr: 'सक्रिय', hi: 'सक्रिय', te: 'యాక్టివ్', kn: 'ಸಕ್ರಿಯ', gu: 'સક્રિય'),
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  // Quick switch buttons for top languages
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildQuickLangPill(context, authVm, 'mr', 'मराठी'),
                      _buildQuickLangPill(context, authVm, 'hi', 'हिन्दी'),
                      _buildQuickLangPill(context, authVm, 'te', 'తెలుగు'),
                      _buildQuickLangPill(context, authVm, 'kn', 'ಕನ್ನಡ'),
                      _buildQuickLangPill(context, authVm, 'gu', 'ગુજરાતી'),
                      _buildQuickLangPill(context, authVm, 'en', 'English'),
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
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginView()),
                    (route) => false,
                  );
                }
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

  Widget _buildQuickLangPill(BuildContext context, AuthViewModel vm, String code, String label) {
    final isSel = vm.locale == code;
    return InkWell(
      onTap: () => vm.setLocale(code),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSel ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSel ? AppColors.primary : AppColors.cardBorder,
          ),
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
    );
  }
}
