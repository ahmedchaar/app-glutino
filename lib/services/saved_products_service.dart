import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class SavedProductsService extends ChangeNotifier {
  static final SavedProductsService _instance = SavedProductsService._internal();
  factory SavedProductsService() => _instance;
  SavedProductsService._internal();

  List<Product> _products = [];
  String? _currentUserEmail;
  bool _initialized = false;

  List<Product> get products => _products;

  Future<void> init(String userEmail) async {
    if (_currentUserEmail == userEmail && _initialized) return;
    
    _currentUserEmail = userEmail;
    _products = [];
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'saved_products_$userEmail';
      String? data = prefs.getString(key);
      
      // SAFEGUARD: If data is > 10MB, clear it
      if (data != null && data.length > 10 * 1024 * 1024) {
        debugPrint("CRITICAL: Saved products data too large (${data.length}). Clearing.");
        await prefs.remove(key);
        data = null;
      }
      
      if (data != null) {
        final List<dynamic> decoded = jsonDecode(data);
        _products = decoded.map((e) => Product.fromLocalJson(e)).toList();
        
        // Limit to 100 products
        if (_products.length > 100) {
          _products = _products.take(100).toList();
          await _persist();
        }
      }
    } catch (e) {
      debugPrint("Error loading saved products: $e");
    }
    
    _initialized = true;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    if (_currentUserEmail == null) return;
    
    // Remove if already exists (avoid duplicates)
    _products.removeWhere((p) => p.barcode == product.barcode);
    
    // Add to beginning
    _products.insert(0, product);
    
    // Limit to 100 products
    if (_products.length > 100) {
      _products = _products.take(100).toList();
    }
    
    await _persist();
    notifyListeners();
  }

  Future<void> removeProduct(String barcode) async {
    if (_currentUserEmail == null) return;
    
    _products.removeWhere((p) => p.barcode == barcode);
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    if (_currentUserEmail == null) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'saved_products_$_currentUserEmail';
      final data = jsonEncode(_products.map((p) => p.toJson()).toList());
      await prefs.setString(key, data);
    } catch (e) {
      debugPrint("Error persisting saved products: $e");
    }
  }
}
