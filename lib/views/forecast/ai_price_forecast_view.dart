import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../models/crop_tracker_model.dart';
import '../../services/mandi_directory_service.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/mandi_viewmodel.dart';
import '../markets/mandi_profit_calculator_view.dart';

class AiPriceForecastView extends StatefulWidget {
  final String? initialCrop;
  final double? initialQuantity;

  const AiPriceForecastView({
    super.key,
    this.initialCrop,
    this.initialQuantity,
  });

  @override
  State<AiPriceForecastView> createState() => _AiPriceForecastViewState();
}

class _AiPriceForecastViewState extends State<AiPriceForecastView> {
  late String _selectedCategoryId;
  late CropItem _selectedCrop;
  late double _quantityQuintals;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;
  late TextEditingController _customCropController;
  bool _isCustomCrop = false;
  late CropPriceForecast _forecast;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = 'grains';

    // Find initial crop or default to Soybean
    final initCropName = widget.initialCrop ?? 'Soybean';
    _selectedCrop = MandiDirectoryService.crops.firstWhere(
      (c) => c.id.toLowerCase() == initCropName.toLowerCase() ||
             c.nameEn.toLowerCase().contains(initCropName.toLowerCase()) ||
             c.nameMr.contains(initCropName),
      orElse: () => MandiDirectoryService.crops.first,
    );
    _selectedCategoryId = _selectedCrop.categoryId;

    _quantityQuintals = widget.initialQuantity ?? 30.0;
    _quantityController = TextEditingController(text: _quantityQuintals.toStringAsFixed(0));
    _priceController = TextEditingController(text: _selectedCrop.benchmarkPrice.toStringAsFixed(0));
    _customCropController = TextEditingController();

    _runForecastCalculation();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _customCropController.dispose();
    super.dispose();
  }

  void _runForecastCalculation() {
    final customPrice = double.tryParse(_priceController.text);
    final cropName = _isCustomCrop && _customCropController.text.trim().isNotEmpty
        ? _customCropController.text.trim()
        : _selectedCrop.nameEn;

    setState(() {
      _forecast = CropPriceForecast.predict(
        cropName,
        _quantityQuintals,
        userCustomPrice: customPrice,
      );
    });
  }

  void _onCategorySelected(String categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _isCustomCrop = false;
      final cropsInCat = MandiDirectoryService.crops.where((c) => c.categoryId == categoryId).toList();
      if (cropsInCat.isNotEmpty) {
        _selectedCrop = cropsInCat.first;
        _priceController.text = _selectedCrop.benchmarkPrice.toStringAsFixed(0);
      }
    });
    _runForecastCalculation();
  }

  void _onCropSelected(CropItem crop) {
    setState(() {
      _selectedCrop = crop;
      _isCustomCrop = false;
      _priceController.text = crop.benchmarkPrice.toStringAsFixed(0);
    });
    _runForecastCalculation();
  }

  void _onQuantityChipTapped(double q) {
    setState(() {
      _quantityQuintals = q;
      _quantityController.text = q.toStringAsFixed(0);
    });
    _runForecastCalculation();
  }

  @override
  Widget build(BuildContext context) {
    final authVm = Provider.of<AuthViewModel>(context);
    final loc = authVm.locale;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.tr(
            loc,
            en: 'AI Crop Price Forecast',
            mr: 'पिकांचे AI बाजारभाव भाकीत',
            hi: 'फसल मूल्य पूर्वानुमान (AI)',
            te: 'AI పంట ధరల అంచనా',
            kn: 'AI ಬೆಳೆ ಬೆಲೆ ಮುನ್ಸೂಚನೆ',
            gu: 'AI પાક ભાવ અનુમાન',
          ),
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Hero Banner
            _buildHeroInfoBanner(loc),
            const SizedBox(height: 16),

            // Step 1: Crop Selection Card
            _buildCropSelectionCard(loc),
            const SizedBox(height: 14),

            // Step 2: Quantity & Base Price Card
            _buildQuantityAndPriceCard(loc),
            const SizedBox(height: 16),

            // Step 3: AI Verdict & Forecast Results
            _buildForecastResultsSection(loc, authVm),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // 1. Hero Info Banner
  Widget _buildHeroInfoBanner(String loc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.25),
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
            child: const Icon(Icons.auto_graph_rounded, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.tr(
                    loc,
                    en: 'Hold vs. Sell AI Advisor',
                    mr: 'साठवून ठेवा की विका? AI निर्णय',
                    hi: 'रखें या बेचें? AI निर्णय सलाहकार',
                    te: 'నిల్వ ఉంచాలా లేదా అమ్మాలా? AI సలహా',
                    kn: 'ಶೇಖರಿಸಿಡಬೇಕೇ ಅಥವಾ ಮಾರಬೇಕೇ? AI ಸಲಹೆ',
                    gu: 'રાખો કે વેચો? AI સલાહકાર',
                  ),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.tr(
                    loc,
                    en: 'Predicts whether price will increase or decrease over 15-30 days and calculates your potential profit gain.',
                    mr: 'पुढील १५-३० दिवसांत भाव वाढणार की घसरणार? यावरून नफा कमावण्यासाठी योग्य निर्णय घ्या.',
                    hi: 'अगले 15-30 दिनों में कीमत बढ़ेगी या घटेगी? जानें और अधिकतम शुद्ध लाभ पाएं।',
                    te: 'రాబోయే 15-30 రోజుల్లో ధర పెరుగుతుందా లేదా తగ్గుతుందా అని తెలుసుకోండి.',
                    kn: 'ಮುಂದಿನ 15-30 ದಿನಗಳಲ್ಲಿ ಬೆಲೆ ಹೆಚ್ಚಾಗುವುದೇ ಅಥವಾ ಕಡಿಮೆಯಾಗುವುದೇ ಎಂದು ತಿಳಿಯಿರಿ.',
                    gu: 'આગામી 15-30 દિવસમાં ભાવ વધશે કે ઘટશે તે જાણી યોગ્ય નિર્ણય લો.',
                  ),
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Crop Selection Card
  Widget _buildCropSelectionCard(String loc) {
    final cropsInCat = MandiDirectoryService.crops.where((c) => c.categoryId == _selectedCategoryId).toList();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.grass_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    AppStrings.tr(
                      loc,
                      en: 'Step 1: Which Crop Do You Have?',
                      mr: 'पायरी १: तुमच्याकडे कोणते पीक आहे?',
                      hi: 'चरण 1: आपके पास कौन सी फसल है?',
                      te: 'దశ 1: మీ వద్ద ఏ పంట ఉంది?',
                      kn: 'ಹಂತ 1: ನಿಮ್ಮ ಬಳಿ ಯಾವ ಬೆಳೆ ಇದೆ?',
                      gu: 'પગલું 1: તમારી પાસે કયો પાક છે?',
                    ),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _selectedCrop.getName(loc),
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Horizontal Category Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: MandiDirectoryService.categories.map((cat) {
                final isSelected = cat.id == _selectedCategoryId;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    selected: isSelected,
                    showCheckmark: false,
                    avatar: Text(cat.icon, style: const TextStyle(fontSize: 14)),
                    label: Text(
                      cat.getName(loc),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: AppColors.primary,
                    onSelected: (_) => _onCategorySelected(cat.id),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // Crop Chips Wrap
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: cropsInCat.map((crop) {
              final isSelected = !_isCustomCrop && crop.id == _selectedCrop.id;
              return ChoiceChip(
                selected: isSelected,
                avatar: Text(crop.icon, style: const TextStyle(fontSize: 13)),
                label: Text(
                  crop.getName(loc),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.background,
                onSelected: (_) => _onCropSelected(crop),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.cardBorder,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 3. Quantity & Base Price Card
  Widget _buildQuantityAndPriceCard(String loc) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.scale_rounded, color: AppColors.primary, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    AppStrings.tr(
                      loc,
                      en: 'Step 2: Quantity & Current Price',
                      mr: 'पायरी २: वजन व सध्याचा बाजारभाव',
                      hi: 'चरण 2: मात्रा और वर्तमान बाजार भाव',
                      te: 'దశ 2: పరిమాణం మరియు ప్రస్తుత ధర',
                      kn: 'ಹಂತ 2: ತೂಕ ಮತ್ತು ಪ್ರಸ್ತುತ ಬೆಲೆ',
                      gu: 'પગલું 2: વજન અને વર્તમાન ભાવ',
                    ),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textPrimary),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${_quantityQuintals.toStringAsFixed(0)} Qtl',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Quick Quantity Chips
          Row(
            children: [10.0, 25.0, 50.0, 100.0, 200.0].map((q) {
              final isSelected = (_quantityQuintals - q).abs() < 0.1;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: InkWell(
                    onTap: () => _onQuantityChipTapped(q),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.cardBorder,
                        ),
                      ),
                      child: Text(
                        '${q.toInt()} Q',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),

          // Input Row for Custom Quantity & Current Price
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(loc, en: 'Harvest (Qtl)', mr: 'वजन (क्विंटल)', hi: 'मात्रा (क्विंटल)', te: 'పరిమాణం (క్విం)', kn: 'ತೂಕ (ಕ್ವಿಂಟಾಲ್)', gu: 'વજન (ક્વિન્ટલ)'),
                    labelStyle: const TextStyle(fontSize: 11),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (val) {
                    final q = double.tryParse(val);
                    if (q != null && q > 0) {
                      _quantityQuintals = q;
                      _runForecastCalculation();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: AppStrings.tr(loc, en: 'Today Rate (₹/Q)', mr: 'आजचा दर (₹/Q)', hi: 'आज का भाव (₹/Q)', te: 'నేటి ధర (₹/Q)', kn: 'ಇಂದಿನ ದರ (₹/Q)', gu: 'આજનો ભાવ (₹/Q)'),
                    labelStyle: const TextStyle(fontSize: 11),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (_) => _runForecastCalculation(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _runForecastCalculation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  AppStrings.tr(loc, en: 'Predict', mr: 'अंदाज', hi: 'अनुमान', te: 'అంచనా', kn: 'ಅಂದಾಜು', gu: 'અનુમાન'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 4. Forecast Results Section
  Widget _buildForecastResultsSection(String loc, AuthViewModel authVm) {
    final shouldHold = _forecast.shouldHold;
    final priceDelta = _forecast.priceDelta;
    final isPositive = priceDelta >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: shouldHold ? Colors.green.shade300 : Colors.red.shade300,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (shouldHold ? Colors.green : Colors.red).withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prominent AI Verdict Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: shouldHold ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: shouldHold ? Colors.green.shade600 : Colors.red.shade600,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      shouldHold ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                      size: 16,
                      color: shouldHold ? Colors.green.shade800 : Colors.red.shade800,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      shouldHold
                          ? AppStrings.tr(loc, en: '🟢 WAIT TO SELL (HOLD STOCK)', mr: '🟢 साठवून ठेवा (भाव वाढणार)', hi: '🟢 रोक कर रखें (भाव बढ़ेगा)', te: '🟢 నిల్వ ఉంచండి (ధర పెరుగుతుంది)', kn: '🟢 ಶೇಖರಿಸಿಡಿ (ಬೆಲೆ ಹೆಚ್ಚಾಗಲಿದೆ)', gu: '🟢 રોકી રાખો (ભાવ વધશે)')
                          : AppStrings.tr(loc, en: '🔴 SELL NOW (DO NOT WAIT)', mr: '🔴 तात्काळ विक्री करा (घसरण जोखीम)', hi: '🔴 तुरंत बेचें (गिरावट का जोखिम)', te: '🔴 ఇప్పుడే అమ్మండి (ధర తగ్గే ప్రమాదం)', kn: '🔴 ತಕ್ಷಣ ಮಾರಿ (ಬೆಲೆ ಕುಸಿತದ ಅಪಾಯ)', gu: '🔴 તુરંત વેચો (ભાવ ઘટવાનું જોખમ)'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: shouldHold ? Colors.green.shade900 : Colors.red.shade900,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${_forecast.confidencePercent}% Confidence',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Big Extra Profit or Price Drop Banner
          if (shouldHold && _forecast.potentialExtraProfit > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade400),
              ),
              child: Row(
                children: [
                  const Icon(Icons.savings_rounded, color: Color(0xFF2E7D32), size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.tr(
                            loc,
                            en: 'Potential Additional Profit by Waiting:',
                            mr: 'थांबल्यास संभाव्य अतिरिक्त नफा:',
                            hi: 'रुकने पर संभावित अतिरिक्त शुद्ध लाभ:',
                            te: 'వేచి ఉండటం వల్ల వచ్చే అదనపు లాభం:',
                            kn: 'ಕಾಯುವುದರಿಂದ ಸಿಗುವ ಸಂಭಾವ್ಯ ಹೆಚ್ಚುವರಿ ಲಾಭ:',
                            gu: 'રાખવાથી થતો સંભવિત વધારાનો નફો:',
                          ),
                          style: TextStyle(fontSize: 11, color: Colors.green.shade900, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '+₹${_forecast.potentialExtraProfit.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1B5E20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade300),
              ),
              child: Row(
                children: [
                  const Icon(Icons.trending_down_rounded, color: Colors.red, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.tr(
                            loc,
                            en: 'Action: Liquidate Stock Promptly',
                            mr: 'सल्ला: माल जास्त दिवस साठवू नका',
                            hi: 'सलाह: माल अधिक दिन न रोकें, तुरंत बेचें',
                            te: 'సలహా: పంటను ఎక్కువ రోజులు నిల్వ చేయవద్దు',
                            kn: 'ಸಲಹೆ: ಸ್ಟಾಕ್ ಅನ್ನು ಹೆಚ್ಚು ದಿನ ಇಟ್ಟುಕೊಳ್ಳಬೇಡಿ',
                            gu: 'સલાહ: માલ વધુ દિવસ ન સાચવો, તુરંત વેચો',
                          ),
                          style: TextStyle(fontSize: 11, color: Colors.red.shade900, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          AppStrings.tr(
                            loc,
                            en: 'Risk of spoilage & ₹300-₹500/Qtl price erosion',
                            mr: 'वजन घट, नासधूस व प्रति क्विंटल ₹३००-५०० नुकसान जोखीम',
                            hi: 'खराब होने और प्रति क्विंटल ₹300-500 गिरावट की आशंका',
                            te: 'ధర క్షీణత మరియు బరువు తగ్గే ప్రమాదం',
                            kn: 'ಹಾಳಾಗುವಿಕೆ ಮತ್ತು ದರ ಕುಸಿಯುವ ಭೀತಿ',
                            gu: 'બગાડ અને ક્વિન્ટલ દીઠ ₹૩૦૦-૫૦૦ ઘટવાનું જોખમ',
                          ),
                          style: TextStyle(fontSize: 11, color: Colors.red.shade800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 14),

          // 3 Price Metric Cards Row
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  title: AppStrings.tr(loc, en: "Today's Rate", mr: 'आजचा भाव', hi: 'आज का भाव', te: 'నేటి ధర', kn: 'ಇಂದಿನ ದರ', gu: 'આજનો ભાવ'),
                  value: '₹${_forecast.currentPrice.toStringAsFixed(0)}',
                  subtitle: '/Qtl',
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  title: '${_forecast.daysAhead} ${AppStrings.tr(loc, en: "Days Target", mr: 'दिवसांत अंदाज', hi: 'दिन बाद लक्ष्य', te: 'రోజుల లక్ష్యం', kn: 'ದಿನಗಳ ಗುರಿ', gu: 'દિવસોનું લક્ષ્ય')}',
                  value: '₹${_forecast.predictedPrice.toStringAsFixed(0)}',
                  subtitle: '/Qtl',
                  color: shouldHold ? const Color(0xFF1B5E20) : Colors.red.shade800,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  title: AppStrings.tr(loc, en: 'Price Delta', mr: 'फरक / बदल', hi: 'भाव अंतर', te: 'ధర మార్పు', kn: 'ದರ ಬದಲಾವಣೆ', gu: 'ભાવ તફાવત'),
                  value: '${isPositive ? "+" : ""}₹${priceDelta.abs().toStringAsFixed(0)}',
                  subtitle: '${isPositive ? "+" : ""}${_forecast.priceChangePercent}%',
                  color: isPositive ? Colors.green.shade800 : Colors.red.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Visual Weekly Price Progression
          Text(
            AppStrings.tr(
              loc,
              en: 'Projected 4-Week Price Trajectory:',
              mr: 'पुढील ४ आठवड्यांचा किंमत कल (Price Trajectory):',
              hi: 'आगामी 4 सप्ताह का अनुमानित मूल्य ग्राफ:',
              te: 'రాబోయే 4 వారాల ధర పథం:',
              kn: 'ಮುಂದಿನ 4 ವಾರಗಳ ಬೆಲೆಯ ಪಥ:',
              gu: 'આગામી 4 અઠવાડિયાનો અંદાજિત ભાવ ટ્રેક:',
            ),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(_forecast.weeklyTrend.length, (idx) {
              final val = _forecast.weeklyTrend[idx];
              final isLast = idx == _forecast.weeklyTrend.length - 1;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: isLast ? 0 : 4),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    color: isLast
                        ? (shouldHold ? Colors.green.shade50 : Colors.red.shade50)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isLast
                          ? (shouldHold ? Colors.green.shade300 : Colors.red.shade300)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'W${idx + 1}',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isLast ? (shouldHold ? Colors.green.shade900 : Colors.red.shade900) : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${val.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: isLast ? (shouldHold ? Colors.green.shade800 : Colors.red.shade800) : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),

          // Detailed Advisory Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.analytics_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      AppStrings.tr(
                        loc,
                        en: 'AI Market Intelligence & Reasoning:',
                        mr: 'AI बाजार विश्लेषण व कारण:',
                        hi: 'AI बाजार विश्लेषण एवं कारण:',
                        te: 'AI మార్కెట్ విశ్లేషణ & కారణం:',
                        kn: 'AI ಮಾರುಕಟ್ಟೆ ವಿಶ್ಲೇಷಣೆ ಮತ್ತು ಕಾರಣ:',
                        gu: 'AI બજાર વિશ્લેષણ અને કારણ:',
                      ),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  loc == 'mr'
                      ? _forecast.advisoryText
                      : (loc == 'en' ? _forecast.advisoryTextEn : _forecast.getAdvisory(false)),
                  style: const TextStyle(fontSize: 11, height: 1.4, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Direct Navigation Button to Mandi Profit Calculator
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                final mandiVm = Provider.of<MandiViewModel>(context, listen: false);
                mandiVm.setCommodity(_selectedCrop.id);
                mandiVm.setWeight(_quantityQuintals);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MandiProfitCalculatorView(),
                  ),
                );
              },
              icon: const Icon(Icons.calculate_rounded, color: Colors.white, size: 18),
              label: Text(
                AppStrings.tr(
                  loc,
                  en: 'Calculate Transport & Mandi Profit ➔',
                  mr: 'या पिकासाठी नफा व वाहतूक खर्च काढा ➔',
                  hi: 'इस फसल के लिए मंडी लाभ और परिवहन खर्च देखें ➔',
                  te: 'ఈ పంటకు రవాణా మరియు మార్కెట్ లాభం లెక్కించండి ➔',
                  kn: 'ಈ ಬೆಳೆಗೆ ಸಾರಿಗೆ ಮತ್ತು ಮಾರುಕಟ್ಟೆ ಲಾಭವನ್ನು ಲೆಕ್ಕ ಹಾಕಿ ➔',
                  gu: 'આ પાક માટે પરિવહન અને ચોખ્ખો નફો ગણો ➔',
                ),
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: color),
            textAlign: TextAlign.center,
          ),
          Text(
            subtitle,
            style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
