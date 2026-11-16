class KhataEntry {
  final String id;
  final String cropName;
  final String category; // 'seeds', 'fertilizers', 'pesticides', 'labor', 'machinery', 'transport', 'sale_income', 'other'
  final String categoryLabelMr;
  final String type; // 'expense' or 'income'
  final double amount;
  final DateTime date;
  final String notes;

  const KhataEntry({
    required this.id,
    required this.cropName,
    required this.category,
    required this.categoryLabelMr,
    required this.type,
    required this.amount,
    required this.date,
    this.notes = '',
  });

  bool get isExpense => type == 'expense';
  bool get isIncome => type == 'income';

  factory KhataEntry.fromJson(Map<String, dynamic> json) {
    return KhataEntry(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      cropName: json['crop_name']?.toString() ?? 'सोयाबीन',
      category: json['category']?.toString() ?? 'fertilizers',
      categoryLabelMr: json['category_label_mr']?.toString() ?? 'खते',
      type: json['type']?.toString() ?? 'expense',
      amount: (json['amount'] ?? 0.0).toDouble(),
      date: json['date'] != null ? DateTime.parse(json['date'].toString()) : DateTime.now(),
      notes: json['notes']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'crop_name': cropName,
      'category': category,
      'category_label_mr': categoryLabelMr,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }

  static const List<Map<String, String>> expenseCategories = [
    {'id': 'fertilizers', 'label': '🧪 रासायनिक व सेंद्रिय खते', 'labelShort': 'खते'},
    {'id': 'seeds', 'label': '🌱 बियाणे खरेदी', 'labelShort': 'बियाणे'},
    {'id': 'pesticides', 'label': '🧴 कीटकनाशक व बुरशीनाशक', 'labelShort': 'कीटकनाशक'},
    {'id': 'labor', 'label': '👷 मजुरी, खुरपणी व फवारणी', 'labelShort': 'मजुरी'},
    {'id': 'machinery', 'label': '🚜 ट्रॅक्टर नांगरणी व मळणी', 'labelShort': 'ट्रॅक्टर भाडे'},
    {'id': 'transport', 'label': '🚚 वाहतूक, टोल व हमाली', 'labelShort': 'वाहतूक'},
    {'id': 'irrigation_cost', 'label': '💧 पाणी, वीज व सिंचन', 'labelShort': 'सिंचन खर्च'},
    {'id': 'other', 'label': '📦 इतर किरकोळ खर्च', 'labelShort': 'इतर खर्च'},
  ];

  static const List<Map<String, String>> incomeCategories = [
    {'id': 'mandi_sale', 'label': '💰 बाजार समिती (APMC) विक्री', 'labelShort': 'मंडी विक्री'},
    {'id': 'local_trader_sale', 'label': '🏪 स्थानिक व्यापारी खरेदी', 'labelShort': 'व्यापारी विक्री'},
    {'id': 'direct_customer_sale', 'label': '🛒 थेट ग्राहक विक्री', 'labelShort': 'थेट विक्री'},
    {'id': 'dbt_subsidy_income', 'label': '🏛️ सरकारी अनुदान (DBT जमा)', 'labelShort': 'सरकारी अनुदान'},
  ];

  static List<KhataEntry> getDefaultSampleEntries() {
    final now = DateTime.now();
    return [
      KhataEntry(
        id: 'kh-1',
        cropName: 'सोयाबीन (Soybean)',
        category: 'seeds',
        categoryLabelMr: 'बियाणे खरेदी',
        type: 'expense',
        amount: 3200.0,
        date: now.subtract(const Duration(days: 60)),
        notes: 'JS-335 प्रमाणित बियाणे (३० किलो बॅग)',
      ),
      KhataEntry(
        id: 'kh-2',
        cropName: 'सोयाबीन (Soybean)',
        category: 'machinery',
        categoryLabelMr: 'ट्रॅक्टर नांगरणी',
        type: 'expense',
        amount: 2400.0,
        date: now.subtract(const Duration(days: 55)),
        notes: 'रोटाव्हेटर २ एकर नांगरणी',
      ),
      KhataEntry(
        id: 'kh-3',
        cropName: 'सोयाबीन (Soybean)',
        category: 'fertilizers',
        categoryLabelMr: 'रासायनिक खते',
        type: 'expense',
        amount: 2700.0,
        date: now.subtract(const Duration(days: 45)),
        notes: 'DAP २ पोती + सल्फर',
      ),
      KhataEntry(
        id: 'kh-4',
        cropName: 'सोयाबीन (Soybean)',
        category: 'pesticides',
        categoryLabelMr: 'कीटकनाशक फवारणी',
        type: 'expense',
        amount: 1450.0,
        date: now.subtract(const Duration(days: 30)),
        notes: 'अळीनाशक व बुरशीनाशक फवारणी',
      ),
      KhataEntry(
        id: 'kh-5',
        cropName: 'सोयाबीन (Soybean)',
        category: 'labor',
        categoryLabelMr: 'खुरपणी व मजुरी',
        type: 'expense',
        amount: 2800.0,
        date: now.subtract(const Duration(days: 20)),
        notes: 'तण काढणी व फवारणी मजुरी',
      ),
      KhataEntry(
        id: 'kh-6',
        cropName: 'सोयाबीन (Soybean)',
        category: 'mandi_sale',
        categoryLabelMr: 'मंडी विक्री',
        type: 'income',
        amount: 113307.0,
        date: now.subtract(const Duration(days: 2)),
        notes: 'लातूर मार्केट यार्ड - २५ क्विंटल सोयाबीन विक्री',
      ),
    ];
  }
}
