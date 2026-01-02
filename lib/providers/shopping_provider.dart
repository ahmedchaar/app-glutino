import 'package:flutter/material.dart';
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
}

class ShoppingProvider extends ChangeNotifier {
  final List<ShoppingItem> _items = [];
  String _lastRecipeName = ""; 
  final Uuid _uuid = const Uuid();

  List<ShoppingItem> get items => _items;
  String get lastRecipeName => _lastRecipeName;

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
    notifyListeners();
  }

  void toggleStatus(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].isCompleted = !_items[index].isCompleted;
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCompleted() {
    _items.removeWhere((item) => item.isCompleted);
    notifyListeners();
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