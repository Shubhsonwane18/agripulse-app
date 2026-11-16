class CropTrackerData {
  final String growingCrop;
  final String cropStage;
  final double acreage;
  final double storedStockQuintals;
  final String storageLocation;

  const CropTrackerData({
    this.growingCrop = 'सोयाबीन (Soybean)',
    this.cropStage = 'दाणे भरणे (Pod Filling)',
    this.acreage = 3.5,
    this.storedStockQuintals = 45.0,
    this.storageLocation = 'शेतकऱ्यांचे घर / शेतातील गोदाम',
  });

  CropTrackerData copyWith({
    String? growingCrop,
    String? cropStage,
    double? acreage,
    double? storedStockQuintals,
    String? storageLocation,
  }) {
    return CropTrackerData(
      growingCrop: growingCrop ?? this.growingCrop,
      cropStage: cropStage ?? this.cropStage,
      acreage: acreage ?? this.acreage,
      storedStockQuintals: storedStockQuintals ?? this.storedStockQuintals,
      storageLocation: storageLocation ?? this.storageLocation,
    );
  }
}

class CropPriceForecast {
  final String cropName;
  final double currentPrice;
  final double predictedPrice;
  final double priceDelta;
  final double priceChangePercent;
  final bool shouldHold; // true = HOLD, false = SELL
  final String verdictBadge;
  final String advisoryText;
  final double potentialExtraProfit;
  final int daysAhead;
  final int confidencePercent;
  final List<double> weeklyTrend;

  const CropPriceForecast({
    required this.cropName,
    required this.currentPrice,
    required this.predictedPrice,
    required this.priceDelta,
    required this.priceChangePercent,
    required this.shouldHold,
    required this.verdictBadge,
    required this.advisoryText,
    required this.potentialExtraProfit,
    required this.daysAhead,
    required this.confidencePercent,
    required this.weeklyTrend,
  });

  factory CropPriceForecast.predict(String crop, double quantityQuintals) {
    final lower = crop.toLowerCase();

    // 1. Onion -> Price Drop expected (SELL NOW)
    if (lower.contains('onion') || lower.contains('कांदा')) {
      const current = 2350.0;
      const predicted = 1950.0;
      const delta = predicted - current;
      return CropPriceForecast(
        cropName: 'कांदा (Onion)',
        currentPrice: current,
        predictedPrice: predicted,
        priceDelta: delta,
        priceChangePercent: -17.0,
        shouldHold: false,
        verdictBadge: '🔴 तात्काळ विक्री करा (SELL NOW)',
        advisoryText: 'नवीन खरीप कांद्याची आवक बाजारात वाढत असल्याने पुढील १०-१५ दिवसांत भाव प्रति क्विंटल ₹३५० ते ₹४०० ने घसरण्याची शक्यता आहे. नजीकच्या मंडईत त्वरित विक्रीचा सल्ला.',
        potentialExtraProfit: 0.0,
        daysAhead: 15,
        confidencePercent: 88,
        weeklyTrend: const [2350, 2220, 2100, 1950],
      );
    }

    // 2. Tomato -> Perishable Price Volatility (SELL NOW)
    if (lower.contains('tomato') || lower.contains('टोमॅटो')) {
      const current = 1850.0;
      const predicted = 1500.0;
      const delta = predicted - current;
      return CropPriceForecast(
        cropName: 'टोमॅटो (Tomato)',
        currentPrice: current,
        predictedPrice: predicted,
        priceDelta: delta,
        priceChangePercent: -18.9,
        shouldHold: false,
        verdictBadge: '🔴 त्वरित विक्री करा (SELL NOW)',
        advisoryText: 'नाशवंत पीक असून बाजारात स्थानिक आवक वाढली आहे. साठवणूक न करता आजच सर्वोत्तम भाव देणाऱ्या बाजारपेठेत माल विका.',
        potentialExtraProfit: 0.0,
        daysAhead: 7,
        confidencePercent: 91,
        weeklyTrend: const [1850, 1720, 1600, 1500],
      );
    }

    // 3. Cotton -> Price Rise expected (HOLD)
    if (lower.contains('cotton') || lower.contains('कापूस')) {
      const current = 7150.0;
      const predicted = 7780.0;
      const delta = predicted - current;
      final gain = (delta * quantityQuintals).clamp(0.0, 999999.0);
      return CropPriceForecast(
        cropName: 'कापूस (Cotton)',
        currentPrice: current,
        predictedPrice: predicted,
        priceDelta: delta,
        priceChangePercent: 8.8,
        shouldHold: true,
        verdictBadge: '🟢 साठवून ठेवा (HOLD FOR PROFIT)',
        advisoryText: 'जागतिक बाजारात कापसाच्या धाग्याला वाढती मागणी आणि जिनिंग मिलकडून मोठी खरेदी अपेक्षित आहे. पुढील २०-२५ दिवसांत भाव ₹६००+ ने वाढतील.',
        potentialExtraProfit: gain,
        daysAhead: 25,
        confidencePercent: 89,
        weeklyTrend: const [7150, 7300, 7550, 7780],
      );
    }

    // 4. Tur / Arhar -> High Demand (HOLD)
    if (lower.contains('tur') || lower.contains('तूर') || lower.contains('arhar')) {
      const current = 9600.0;
      const predicted = 10450.0;
      const delta = predicted - current;
      final gain = (delta * quantityQuintals).clamp(0.0, 999999.0);
      return CropPriceForecast(
        cropName: 'तूर (Pigeon Pea)',
        currentPrice: current,
        predictedPrice: predicted,
        priceDelta: delta,
        priceChangePercent: 8.9,
        shouldHold: true,
        verdictBadge: '🟢 साठवून ठेवा (HOLD FOR PROFIT)',
        advisoryText: 'डाळींची घरगुती मागणी तीव्र असून पुरवठा मर्यादित आहे. पुढील ३० दिवसांत भाव ₹१०,००० चा टप्पा पार करण्याची ९४% शक्यता आहे.',
        potentialExtraProfit: gain,
        daysAhead: 30,
        confidencePercent: 94,
        weeklyTrend: const [9600, 9850, 10150, 10450],
      );
    }

    // 5. Default Soybean -> Price Rise Expected (HOLD)
    const current = 4820.0;
    const predicted = 5380.0;
    const delta = predicted - current;
    final gain = (delta * quantityQuintals).clamp(0.0, 999999.0);
    return CropPriceForecast(
      cropName: 'सोयाबीन (Soybean)',
      currentPrice: current,
      predictedPrice: predicted,
      priceDelta: delta,
      priceChangePercent: 11.6,
      shouldHold: true,
      verdictBadge: '🟢 साठवून ठेवा (HOLD FOR PROFIT)',
      advisoryText: 'स्थानिक बाजारपेठेत सोयाबीनची आवक कमी होत आहे आणि केंद्र सरकारच्या खाद्यतेल धोरणामुळे सोयाबीन डीओसी (DOC) मागणी वाढली आहे. पुढील १५-२५ दिवसांत भाव प्रति क्विंटल ₹५६० ने वाढण्याचा अंदाज.',
      potentialExtraProfit: gain,
      daysAhead: 20,
      confidencePercent: 92,
      weeklyTrend: const [4820, 4980, 5180, 5380],
    );
  }
}
