import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/disease_viewmodel.dart';
import '../../viewmodels/weather_viewmodel.dart';

class DiseaseScannerView extends StatelessWidget {
  const DiseaseScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final diseaseVm = context.watch<DiseaseViewModel>();
    final weatherVm = context.watch<WeatherViewModel>();
    final loc = authVm.locale;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.get('diseaseTitle', locale: loc),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
            ),
            Text(
              AppStrings.get('diseaseSubtitle', locale: loc),
              style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 10),
            ),
          ],
        ),
        actions: [
          if (diseaseVm.selectedImage != null)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => diseaseVm.clearScan(),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Upload / Camera Action Box
            if (diseaseVm.selectedImage == null)
              _buildImagePickerBox(context, diseaseVm, loc)
            else
              _buildImagePreviewBox(context, diseaseVm),

            const SizedBox(height: 16),

            // 2. Loading State
            if (diseaseVm.isAnalyzing) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(color: AppColors.primary),
                      const SizedBox(height: 12),
                      Text(
                        AppStrings.tr(
                          loc,
                          en: 'AI leaf disease diagnosis in progress...',
                          mr: 'AI पान रोग निदान सुरू आहे...',
                          hi: 'AI फसल रोग जांच जारी है...',
                          te: 'AI ఆకు తెగులు విశ్లేషణ జరుగుతోంది...',
                          kn: 'AI ಎಲೆ ರೋಗ ಪತ್ತೆ ಪ್ರಕ್ರಿಯೆ ಪ್ರಗತಿಯಲ್ಲಿದೆ...',
                          gu: 'AI પાંદડાના રોગની તપાસ ચાલુ છે...',
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ] else if (diseaseVm.diagnosisResult != null) ...[
              // 3. AI Diagnosis Result Card
              _buildDiagnosisResultCard(context, diseaseVm, weatherVm, loc),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImagePickerBox(BuildContext context, DiseaseViewModel vm, String loc) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 40),
          ),
          const SizedBox(height: 14),
          Text(
            AppStrings.tr(
              loc,
              en: 'Take a clear photo of infected crop leaf',
              mr: 'रोगाची लागण झालेल्या पानाचा स्पष्ट फोटो काढा',
              hi: 'रोग प्रभावित पत्ते की स्पष्ट तस्वीर लें',
              te: 'తెగులు సోకిన ఆకు యొక్క స్పష్టమైన ఫోటో తీయండి',
              kn: 'ರೋಗ ಪೀಡಿತ ಎಲೆಯ ಸ್ಪಷ್ಟ ಫೋಟೋ ತೆಗೆಯಿರಿ',
              gu: 'રોગગ્રસ્ત પાંદડાનો સ્પષ્ટ ફોટો લો',
            ),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.tr(
              loc,
              en: 'Hold camera close to leaf with adequate sunlight.',
              mr: 'कॅमेरा थेट पानाच्या जवळ ठेवून सूर्यप्रकाशात फोटो घ्या.',
              hi: 'कैमरा पत्ते के पास रखकर पर्याप्त रोशनी में फोटो लें।',
              te: 'సూర్యరశ్మిలో కెమెరాను ఆకుకు దగ్గరగా ఉంచి ఫోటో తీయండి.',
              kn: 'ಸಾಕಷ್ಟು ಬೆಳಕಿನಲ್ಲಿ ಕ್ಯಾಮೆರಾವನ್ನು ಎಲೆಯ ಹತ್ತಿರ ಇರಿಸಿ ಫೋಟೋ ತೆಗೆಯಿರಿ.',
              gu: 'પૂરતા સૂર્યપ્રકાશમાં કેમેરા પાંદડા નજીક રાખી ફોટો લો.',
            ),
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => vm.pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                  label: Text(
                    AppStrings.get('takePhoto', locale: loc),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => vm.pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library, color: AppColors.primary, size: 18),
                  label: Text(
                    AppStrings.get('uploadPhoto', locale: loc),
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreviewBox(BuildContext context, DiseaseViewModel vm) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Image.file(
            vm.selectedImage!,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 10,
            right: 10,
            child: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.6),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 18),
                onPressed: () => vm.clearScan(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisResultCard(
    BuildContext context,
    DiseaseViewModel diseaseVm,
    WeatherViewModel weatherVm,
    String loc,
  ) {
    final res = diseaseVm.diagnosisResult!;
    final isWeatherSafe = weatherVm.isSafeToSpray;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Disease Identification Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    res.cropName,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.accentLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${(res.confidence * 100).toStringAsFixed(0)}% AI ${AppStrings.tr(loc, en: "Accuracy", mr: "अचूकता", hi: "सटीकता", te: "ఖచ్చితత్వం", kn: "ನಿಖರತೆ", gu: "ચોકસાઈ")}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                res.diseaseName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),

              // Weather Guard Lockout Validation
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isWeatherSafe ? AppColors.successBg : AppColors.dangerBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isWeatherSafe ? AppColors.accent : AppColors.danger),
                ),
                child: Row(
                  children: [
                    Icon(
                      isWeatherSafe ? Icons.check_circle : Icons.warning_amber_rounded,
                      color: isWeatherSafe ? AppColors.success : AppColors.danger,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isWeatherSafe
                            ? AppStrings.tr(
                                loc,
                                en: 'Safe to Spray: Weather conditions are optimal for chemical application.',
                                mr: 'हवामान अनुकूल: सध्या फवारणी करणे सुरक्षित आहे.',
                                hi: 'छिड़काव के लिए सुरक्षित: मौसम की स्थिति दवा छिड़काव के अनुकूल है।',
                                te: 'స్ప్రే చేయడానికి అనుకూలం: వాతావరణ పరిస్థితులు బాగున్నాయి.',
                                kn: 'ಸಿಂಪಡಿಸಲು ಸುರಕ್ಷಿತ: ಹವಾಮಾನ ಪರಿಸ್ಥಿತಿಗಳು ಸೂಕ್ತವಾಗಿವೆ.',
                                gu: 'છંટકાવ માટે અનુકૂળ: હવામાન પરિસ્થિતિ શ્રેષ્ઠ છે.',
                              )
                            : AppStrings.tr(
                                loc,
                                en: 'Weather Risk: Rain or high wind drift hazard. Do not spray now.',
                                mr: 'हवामान धोका: पाऊस किंवा वेगाने वाहणाऱ्या वाऱ्यामुळे आत्ता फवारणी करू नका.',
                                hi: 'मौसम जोखिम: बारिश या तेज हवा का खतरा। अभी छिड़काव न करें।',
                                te: 'వాతావరణ ప్రమాదం: వర్షం లేదా గాలి ప్రమాదం. ఇప్పుడు పిచికారీ చేయవద్దు.',
                                kn: 'ಹವಾಮಾನ ಅಪಾಯ: ಮಳೆ ಅಥವಾ ಬಲವಾದ ಗಾಳಿಯ ಅಪಾಯ. ಈಗ ಸಿಂಪಡಿಸಬೇಡಿ.',
                                gu: 'હવામાન જોખમ: વરસાદ અથવા ભારે પવનનું જોખમ. હમણાં છંટકાવ ન કરો.',
                              ),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isWeatherSafe ? AppColors.success : AppColors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // CIBRC Chemical Prescriptions
        Text(
          AppStrings.get('chemicalRx', locale: loc),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        ...res.chemicalPrescriptions.map((rx) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rx.chemicalName,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                  if (rx.tradeNames != null)
                    Text(
                      '${AppStrings.tr(loc, en: "Trade Name", mr: "बाजार नाव (Trade)", hi: "व्यापारिक नाम", te: "మార్కెట్ పేరు", kn: "ವಾಣಿಜ್ಯ ಹೆಸರು", gu: "વેપારી નામ")}: ${rx.tradeNames}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRxBadge(AppStrings.tr(loc, en: 'Dosage', mr: 'प्रमाण', hi: 'मात्रा', te: 'మోతాదు', kn: 'ಪ್ರಮಾಣ', gu: 'માત્રા'), rx.dosagePerAcre),
                      _buildRxBadge(AppStrings.tr(loc, en: 'Water', mr: 'पाणी', hi: 'पानी', te: 'నీరు', kn: 'ನೀರು', gu: 'પાણી'), rx.waterVolumeLiters),
                      _buildRxBadge(
                        AppStrings.tr(loc, en: 'Waiting Period', mr: 'प्रतीक्षा काळ', hi: 'प्रतीक्षा अवधि', te: 'వేచి ఉండే సమయం', kn: 'ಕಾಯುವ ಅವಧಿ', gu: 'પ્રતીક્ષા સમય'),
                        '${rx.waitingPeriodDays} ${AppStrings.tr(loc, en: "days", mr: "दिवस", hi: "दिन", te: "రోజులు", kn: "ದಿನಗಳು", gu: "દિવસ")}',
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildRxBadge(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
