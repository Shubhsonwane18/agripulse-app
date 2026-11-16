class Product {
  final String id;
  final String name;
  final String localName;
  final String category; // 'seeds', 'fertilizers', 'pesticides', 'tools'
  final double price;
  final String unit; // '50 kg bag', '1 L bottle', 'Pack'
  final String? imageUrl;
  final String description;
  final bool inStock;
  final bool expertApproved;

  Product({
    required this.id,
    required this.name,
    required this.localName,
    required this.category,
    required this.price,
    required this.unit,
    this.imageUrl,
    required this.description,
    this.inStock = true,
    this.expertApproved = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      localName: json['local_name']?.toString() ?? json['localName']?.toString() ?? json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? 'fertilizers',
      price: (json['price'] ?? 0.0).toDouble(),
      unit: json['unit']?.toString() ?? 'Pack',
      imageUrl: json['image_url']?.toString() ?? json['imageUrl']?.toString(),
      description: json['description']?.toString() ?? '',
      inStock: json['in_stock'] != false && json['inStock'] != false,
      expertApproved: json['expert_approved'] != false && json['expertApproved'] != false,
    );
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get total => product.price * quantity;
}
