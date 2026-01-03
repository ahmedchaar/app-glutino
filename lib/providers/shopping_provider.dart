import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ShoppingItem {
  final String id;
  final String name;
  bool isCompleted;
  final String type;
  final String? alternative;

  ShoppingItem({
    required this.id,
    required this.name,
    this.isCompleted = false,
    this.type = 'Produit',
    this.alternative,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isCompleted': isCompleted,
    'type': type,
    'alternative': alternative,
  };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => ShoppingItem(
    id: json['id'],
    name: json['name'],
    isCompleted: json['isCompleted'],
    type: json['type'],
    alternative: json['alternative'],
  );
}

class ShoppingProvider extends ChangeNotifier {
  List<ShoppingItem> _items = [];
  String _lastRecipeName = ""; 
  final Uuid _uuid = const Uuid();
  String? _currentUserEmail;
  bool _initialized = false;

  List<ShoppingItem> get items => _items;
  String get lastRecipeName => _lastRecipeName;

  Future<void> init(String userEmail) async {
    if (_currentUserEmail == userEmail && _initialized) return;
    
    _currentUserEmail = userEmail;
    _items = [];
    _initialized = false;

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'shopping_list_$userEmail';
      String? data = prefs.getString(key);
      
      // SAFEGUARD: If data is > 5MB, clear it
      if (data != null && data.length > 5 * 1024 * 1024) {
        debugPrint("CRITICAL: Shopping list data too large (${data.length}). Clearing.");
        await prefs.remove(key);
        data = null;
      }
      
      if (data != null) {
        final List<dynamic> decoded = jsonDecode(data);
        _items = decoded.map((e) => ShoppingItem.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Error loading shopping list: $e");
    }
    
    _initialized = true;
    notifyListeners();
  }

  void addIngredients(List<String> ingredients, String recipeName) {
    _lastRecipeName = recipeName;
    for (var ingredient in ingredients) {
      _addItem(ingredient, type: 'Ingrédient');
    }
    notifyListeners();
  }

  void addProduct(String productName) {
    _lastRecipeName = productName;
    _addItem(productName, type: 'Produit');
    notifyListeners();
  }

  void addItem(String name) {
    _addItem(name, type: 'Perso');
    notifyListeners();
  }

  void _addItem(String name, {required String type}) {
    // Basic Gluten check logic for suggestions
    String? alternative;
    final lowerName = name.toLowerCase();
    if (lowerName.contains('pâte') || lowerName.contains('spaghetti') || lowerName.contains('penne')) {
      alternative = "Pâtes sans gluten (Maïs/Riz)";
    } else if (lowerName.contains('pain') || lowerName.contains('baguette')) {
      alternative = "Pain sans gluten";
    } else if (lowerName.contains('farine') && !lowerName.contains('maïs') && !lowerName.contains('riz')) {
      alternative = "Mix Farine sans gluten";
    } else if (lowerName.contains('biscuit') || lowerName.contains('gâteau')) {
      alternative = "Biscuits certifiés sans gluten";
    } else if (lowerName.contains('bière')) {
      alternative = "Bière sans gluten / Cidre";
    }

    _items.add(ShoppingItem(
      id: _uuid.v4(), 
      name: name, 
      type: type,
      alternative: alternative,
    ));
    _persist();
    notifyListeners();
  }

  void toggleStatus(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].isCompleted = !_items[index].isCompleted;
      _persist();
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    _persist();
    notifyListeners();
  }

  void clearCompleted() {
    _items.removeWhere((item) => item.isCompleted);
    _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    if (_currentUserEmail == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'shopping_list_$_currentUserEmail';
      final data = jsonEncode(_items.map((e) => e.toJson()).toList());
      await prefs.setString(key, data);
    } catch (e) {
      debugPrint("Error persisting shopping list: $e");
    }
  }

  String getShareableText() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("🛒 Ma liste de courses Glutino :");
    for (var item in _items) {
      buffer.writeln("- [${item.isCompleted ? 'x' : ' '}] ${item.name}");
      if (item.alternative != null) {
         buffer.writeln("  💡 Alternative: ${item.alternative}");
      }
    }
    return buffer.toString();
  }
}