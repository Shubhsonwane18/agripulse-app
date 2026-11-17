import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/supported_languages.dart';
import '../../services/mandi_directory_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/mandi_viewmodel.dart';
import '../../viewmodels/soil_viewmodel.dart';
import '../main_nav_scaffold.dart';
import '../language/language_selection_view.dart';

class FarmerOnboardingView extends StatefulWidget {
  const FarmerOnboardingView({super.key});

  @override
  State<FarmerOnboardingView> createState() => _FarmerOnboardingViewState();
}

class _FarmerOnboardingViewState extends State<FarmerOnboardingView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _acresController = TextEditingController(text: '4.5');
  final TextEditingController _villageController = TextEditingController(text: 'Shirol');

  CityLocation _selectedCity = MandiDirectoryService.cities.firstWhere(
    (c) => c.id == 'kolhapur',
    orElse: () => MandiDirectoryService.cities.first,
  );

  final Set<String> _selectedCrops = {'Soybean', 'Cotton'};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final authVm = context.read<AuthViewModel>();
    final user = authVm.currentUser;
    if (user != null && user.fullName.isNotEmpty) {
      _nameController.text = user.fullName.replaceAll(RegExp(r'\(.*?\)'), '').trim();
      if (user.village != null && user.village!.isNotEmpty) {
        _villageController.text = user.village!;
      }
      _acresController.text = user.landSizeAcres.toString();
      if (user.district != null && user.district!.isNotEmpty) {
        final match = MandiDirectoryService.cities.firstWhere(
          (c) => c.nameEn.toLowerCase() == user.district!.toLowerCase() ||
                 c.nameMr == user.district ||
                 c.id == user.district!.toLowerCase(),
          orElse: () => _selectedCity,
        );
        _selectedCity = match;
      }
      if (user.preferredCrops.isNotEmpty) {
        _selectedCrops.clear();
        _selectedCrops.addAll(user.preferredCrops);
      }
    } else {
      _nameController.text = 'Ramesh Patil';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _acresController.dispose();
    _villageController.dispose();
    super.dispose();
  }

  void _onCropToggled(String cropId) {
    setState(() {
      if (_selectedCrops.contains(cropId)) {
        if (_selectedCrops.length > 1) {
          _selectedCrops.remove(cropId);
        }
      } else {
        _selectedCrops.add(cropId);
      }
    });
  }

  Future<void> _submitOnboarding(BuildContext context) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name / कृपया आपले नाव टाका.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final acres = double.tryParse(_acresController.text.trim()) ?? 4.5;
    final village = _villageController.text.trim().isNotEmpty
        ? _villageController.text.trim()
        : 'Shirol';

    setState(() => _isSaving = true);

    final authVm = context.read<AuthViewModel>();
    final soilVm = context.read<SoilViewModel>();
    final mandiVm = context.read<MandiViewModel>();

    await authVm.completeOnboarding(
      fullName: name,
      landSizeAcres: acres,
      district: _selectedCity.nameEn,
      village: village,
      crops: _selectedCrops.toList(),
      latitude: _selectedCity.lat,
      longitude: _selectedCity.lon,
    );

    // Sync primary crop to Soil ViewModel and Mandi ViewModel
    if (_selectedCrops.isNotEmpty) {
      final firstCrop = _selectedCrops.first;
      mandiVm.setCommodity(firstCrop);
      soilVm.updateCropTracker(
        growingCrop: firstCrop,
        storedStockQuintals: (acres * 8.0).clamp(10.0, 300.0),
      );
    }

    setState(() => _isSaving = false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavScaffold()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final loc = authVm.locale;

    final String title = {
      'mr': 'आपले स्वागत आहे! शेती माहिती भरा',
      'hi': 'आपका स्वागत है! अपनी खेत प्रोफाइल बनाएं',
      'te': 'స్వాగతం! మీ వ్యవసాయ ప్రొఫైల్ వివరాలు పూరించండి',
      'kn': 'ಸುಸ್ವಾಗತ! ನಿಮ್ಮ ಕೃಷಿ ಪ್ರೊಫೈಲ್ ಭರ್ತಿ ಮಾಡಿ',
      'gu': 'સ્વાગત છે! તમારી ખેતી પ્રોફાઇલ બનાવો',
    }[loc] ?? 'Welcome! Set Up Your Farm Profile';

    final String subtitle = {
      'mr': 'अचूक बाजारभाव, हवामान आणि माती सल्ल्यासाठी शेताची माहिती नोंदवा',
      'hi': 'सटीक मंडी भाव, मौसम और मिट्टी सलाह के लिए अपनी जानकारी दर्ज करें',
      'te': 'ఖచ్చితమైన మార్కెట్ ధరలు & వాతావరణ సమాచారం కోసం వివరాలు ఇవ్వండి',
      'kn': 'ನಿಖರ ಮಾರುಕಟ್ಟೆ ದರ ಮತ್ತು ಹವಾಮಾನ ಮಾಹಿತಿಗಾಗಿ ಕೃಷಿ ವಿವರ ನೀಡಿ',
      'gu': 'સચોટ બજાર ભાવ અને હવામાન માટે તમારી વિગતો ભરો',
    }[loc] ?? 'Personalize your mandi rates, weather spray guards, and soil advisory';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          AppStrings.tr(
            loc,
            en: 'Farmer Profile Setup',
            mr: 'शेतकरी माहिती नोंदणी',
            hi: 'किसान प्रोफाइल सेटअप',
            te: 'రైతు ప్రొఫైల్ సెటప్',
            kn: 'ರೈತ ಪ್ರೊಫೈಲ್ ಸೆಟಪ್',
            gu: 'ખેડૂત પ્રોફાઇલ સેટઅપ',
          ),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LanguageSelectionView(isFirstTime: false),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.language_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    SupportedLanguages.findByCode(loc).nativeName,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Welcome Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFF1E4620)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.agriculture_rounded, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Form Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: const [
                    BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Farmer Name
                    Text(
                      {
                        'mr': '१. शेतकऱ्याचे पूर्ण नाव (Farmer Full Name)',
                        'hi': '१. किसान का पूरा नाम (Full Name)',
                        'te': '1. రైతు పూర్తి పేరు (Full Name)',
                        'kn': '1. ರೈತನ ಪೂರ್ಣ ಹೆಸರು (Full Name)',
                        'gu': '1. ખેડૂતનું પૂરું નામ (Full Name)',
                      }[loc] ?? '1. Farmer Full Name',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Ramesh Patil / रमेश पाटील',
                        prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary, size: 20),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. Farmland in Acres
                    Text(
                      {
                        'mr': '२. एकूण शेतजमीन (Farmland in Acres)',
                        'hi': '२. कुल कृषि भूमि (एकड़ में)',
                        'te': '2. మొత్తం వ్యవసాయ భూమి (ఎకరాలు)',
                        'kn': '2. ಒಟ್ಟು ಕೃಷಿ ಭೂಮಿ (ಎಕರೆ)',
                        'gu': '2. કુલ ખેતીની જમીન (એકરમાં)',
                      }[loc] ?? '2. Farmland Size (in Acres)',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _acresController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: 'e.g. 4.5',
                        suffixText: AppStrings.tr(loc, en: 'Acres', mr: 'एकर', hi: 'एकड़', te: 'ఎకరాలు', kn: 'ಎಕರೆ', gu: 'એકર'),
                        prefixIcon: const Icon(Icons.landscape_outlined, color: AppColors.primary, size: 20),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. City / District Dropdown
                    Text(
                      {
                        'mr': '३. आपला नजीकचा जिल्हा / शहर (City / District)',
                        'hi': '३. आपका नजदीकी जिला / शहर (City / District)',
                        'te': '3. మీ సమీప జిల్లా / నగరం (City / District)',
                        'kn': '3. ನಿಮ್ಮ ಹತ್ತಿರದ ಜಿಲ್ಲೆ / ನಗರ (City / District)',
                        'gu': '3. તમારો નજીકનો જિલ્લો / શહેર (City / District)',
                      }[loc] ?? '3. Primary City / District (For Mandi Distances)',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<CityLocation>(
                      initialValue: _selectedCity,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.location_city_rounded, color: AppColors.primary, size: 20),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: MandiDirectoryService.cities.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(city.getName(loc)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCity = val);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // 4. Village
                    Text(
                      {
                        'mr': '४. गाव / तालुका (Village / Taluka)',
                        'hi': '४. गांव / तहसील (Village / Taluka)',
                        'te': '4. గ్రామం / తాలూకా (Village)',
                        'kn': '4. ಗ್ರಾಮ / ತಾಲೂಕು (Village)',
                        'gu': '4. ગામ / તાલુકો (Village)',
                      }[loc] ?? '4. Village / Taluka',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _villageController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Shirol, Narayangaon, Lasalgaon...',
                        prefixIcon: const Icon(Icons.home_work_outlined, color: AppColors.primary, size: 20),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 5. Which crops do you usually grow? (Multi-select)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: const [
                    BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 2)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          {
                            'mr': '५. आपण शेतात कोणती पिके घेता? (Select Crops)',
                            'hi': '५. आप कौन सी फसलें उगाते हैं? (Select Crops)',
                            'te': '5. మీరు ఏ పంటలను పండిస్తారు? (Select Crops)',
                            'kn': '5. ನೀವು ಯಾವ ಬೆಳೆಗಳನ್ನು ಬೆಳೆಯುತ್ತೀರಿ?',
                            'gu': '5. તમે કયા પાક ઉગાડો છો? (Select Crops)',
                          }[loc] ?? '5. Which crops do you grow? (Select Multiple)',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${_selectedCrops.length} ${AppStrings.tr(loc, en: "selected", mr: "निवडले", hi: "चयनित", te: "ఎంపికయ్యాయి", kn: "ಆಯ್ಕೆಯಾಗಿದೆ", gu: "પસંદ કરેલ")}',
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Quick Selection Chips across all major crops
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: MandiDirectoryService.crops.map((crop) {
                        final isSel = _selectedCrops.contains(crop.id);
                        return FilterChip(
                          label: Text(crop.getName(loc)),
                          selected: isSel,
                          showCheckmark: false,
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.background,
                          labelStyle: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSel ? Colors.white : AppColors.textPrimary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: isSel ? AppColors.primary : AppColors.cardBorder,
                            ),
                          ),
                          onSelected: (_) => _onCropToggled(crop.id),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : () => _submitOnboarding(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 3,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          {
                            'mr': 'शेती प्रोफाइल सेव्ह करा व ॲप सुरू करा ➔',
                            'hi': 'खेत प्रोफाइल सहेजें एवं ऐप शुरू करें ➔',
                            'te': 'ప్రొఫైల్ సేవ్ చేసి ప్రారంభించండి ➔',
                            'kn': 'ಪ್ರೊಫೈಲ್ ಉಳಿಸಿ ಮತ್ತು ಪ್ರಾರಂಭಿಸಿ ➔',
                            'gu': 'પ્રોફાઇલ સાચવો અને શરૂ કરો ➔',
                          }[loc] ?? 'Save Farm Profile & Enter App ➔',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
