import 'package:flutter/material.dart';

class ShoppingProvider extends ChangeNotifier {
  final List<Map<String, String>> _items = [];
  String _lastRecipeName = ""; 

  List<Map<String, String>> get items => _items;
  String get lastRecipeName => _lastRecipeName;

  void addIngredients(List<String> ingredients, String recipeName) {
    _lastRecipeName = recipeName;
    for (var ingredient in ingredients) {
      _items.add({
        'name': ingredient, 
        'quantity': 'À acheter',
      });
    }
    notifyListeners();
  }
}