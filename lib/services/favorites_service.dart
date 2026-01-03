import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FavoritesService extends ChangeNotifier {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  final _storage = const FlutterSecureStorage();
  
  Set<String> _favoriteIds = {};
  String? _currentUserEmail;
  bool _initialized = false;

  Set<String> get favoriteIds => _favoriteIds;

  Future<void> init(String userEmail) async {
    if (_currentUserEmail == userEmail && _initialized) return;
    
    _currentUserEmail = userEmail;
    _favoriteIds = {};
    _initialized = false;

    final key = 'favorite_restaurants_$userEmail';
    try {
      final data = await _storage.read(key: key);
      if (data != null) {
        // SAFEGUARD: If favorites data is > 2MB, clear it
        if (data.length > 2 * 1024 * 1024) {
          debugPrint("CRITICAL: Favorites data too large (${data.length}). Clearing.");
          await _storage.delete(key: key);
          return;
        }
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
    if (_currentUserEmail == null) return;
    try {
      final key = 'favorite_restaurants_$_currentUserEmail';
      await _storage.write(key: key, value: jsonEncode(_favoriteIds.toList()));
    } catch (e) {
      debugPrint("Error persisting favorites: $e");
    }
  }
}
