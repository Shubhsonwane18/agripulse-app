import 'package:flutter/foundation.dart';
import '../models/store_model.dart';
import '../services/api_service.dart';

class StoreViewModel extends ChangeNotifier {
  final ApiService _apiService;
  List<Product> _products = [];
  final List<CartItem> _cart = [];
  String _selectedCategory = 'all';
  bool _isLoading = false;

  StoreViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService() {
    loadProducts();
  }

  List<Product> get products {
    if (_selectedCategory == 'all') return _products;
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  List<CartItem> get cart => _cart;
  int get cartCount => _cart.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotal => _cart.fold(0.0, (sum, item) => sum + item.total);
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _apiService.fetchProducts();
    } catch (_) {
      // Products fallback handled inside service
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addToCart(Product product) {
    final idx = _cart.indexWhere((item) => item.product.id == product.id);
    if (idx >= 0) {
      _cart[idx].quantity += 1;
    } else {
      _cart.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int newQty) {
    final idx = _cart.indexWhere((item) => item.product.id == productId);
    if (idx >= 0) {
      if (newQty <= 0) {
        _cart.removeAt(idx);
      } else {
        _cart[idx].quantity = newQty;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }
}
