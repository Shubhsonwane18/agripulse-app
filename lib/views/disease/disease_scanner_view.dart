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
              style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 10),
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
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 12),
                      Text(
                        'AI पान रोग निदान सुरू आहे...',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 40),
          ),
          const SizedBox(height: 14),
          const Text(
            'रोगाची लागण झालेल्या पानाचा स्पष्ट फोटो काढा',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'कॅमेरा थेट पानाच्या जवळ ठेवून सूर्यप्रकाशात फोटो घ्या.',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
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
              backgroundColor: Colors.black.withOpacity(0.6),
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
                      color: Colors.emerald.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${(res.confidence * 100).toStringAsFixed(0)}% AI अचूकता',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.emerald.shade900,
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
                  border: Border.all(color: isWeatherSafe ? Colors.emerald.shade300 : Colors.rose.shade300),
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
                            ? 'हवामान अनुकूल: सध्या फवारणी करणे सुरक्षित आहे.'
                            : 'हवामान धोका: पाऊस किंवा वेगाने वाहणाऱ्या वाऱ्यामुळे आत्ता फवारणी करू नका.',
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
                      'बाजार नाव (Trade): ${rx.tradeNames}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRxBadge('प्रमाण', rx.dosagePerAcre),
                      _buildRxBadge('पाणी', rx.waterVolumeLiters),
                      _buildRxBadge('प्रतीक्षा काळ', '${rx.waitingPeriodDays} दिवस'),
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
