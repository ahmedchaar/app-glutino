import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavoritesService extends ChangeNotifier {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  final _storage = const FlutterSecureStorage();
  final String _key = 'favorite_restaurants';
  
  Set<String> _favoriteIds = {};
  bool _initialized = false;

  Set<String> get favoriteIds => _favoriteIds;

  Future<void> init() async {
    if (_initialized) return;
    try {
      final data = await _storage.read(key: _key);
      if (data != null) {
        final List<dynamic> decoded = jsonDecode(data);
        _favoriteIds = decoded.map((e) => e.toString()).toSet();
      }
    } catch (e) {
      debugPrint("Error loading favorites: $e");
    }
    _initialized = true;
    notifyListeners();
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    try {
      await _storage.write(key: _key, value: jsonEncode(_favoriteIds.toList()));
    } catch (e) {
      debugPrint("Error persisting favorites: $e");
    }
  }
}
