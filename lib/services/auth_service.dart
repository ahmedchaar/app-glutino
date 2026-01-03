import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  // Initialize GoogleSignIn
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional: clientId (only for web if not in index.html, but better in index.html)
    // scopes: ['email'],
  );

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  static const String _userKey = 'user_data';

  AuthService() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(userString);
        _currentUser = User.fromJson(userMap);
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading user: $e');
      }
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    if (email.isNotEmpty && password.length >= 6) {
      final nameParts = email.split('@')[0].split('.');
      final firstName = nameParts.isNotEmpty ? nameParts.first : 'User';
      final lastName = nameParts.length > 1 ? nameParts[1] : '';

      _currentUser = User(
        email: email,
        firstName: firstName,
        lastName: lastName,
      );
      
      await _saveUserToPrefs();
      _setLoading(false);
      return true;
    }

    _setLoading(false);
    return false;
  }

  Future<bool> signUp(String firstName, String lastName, String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.length >= 6) {
      _currentUser = User(
        email: email,
        firstName: firstName,
        lastName: lastName,
      );
      
      await _saveUserToPrefs();
      _setLoading(false);
      return true;
    }

    _setLoading(false);
    return false;
  }

  Future<bool> socialLogin(String provider) async {
    _setLoading(true);

    if (provider == 'Google') {
      try {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        
        if (googleUser != null) {
          // Success
          final nameParts = googleUser.displayName?.split(' ') ?? ['User'];
          final firstName = nameParts.isNotEmpty ? nameParts.first : 'User';
          final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

          _currentUser = User(
            email: googleUser.email,
            firstName: firstName,
            lastName: lastName,
          );

          await _saveUserToPrefs();
          _setLoading(false);
          return true;
        } else {
          // User canceled
          _setLoading(false);
          return false;
        }
      } catch (error) {
        debugPrint('Google Sign In Error: $error');
        _setLoading(false);
        return false;
      }
    }

    // Fallback for other providers (Facebook/Apple) - Simulated for now
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = User(
      email: 'user@$provider.com',
      firstName: '$provider User',
      lastName: '',
    );

    await _saveUserToPrefs();
    _setLoading(false);
    return true;
  }
   Future<void> updateProfile({
  required String firstName,
    required String lastName,
    required String email,
  }) async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(
      firstName: firstName,
      lastName: lastName,
      email: email,
      // 👇 KEEP EXISTING PHOTO
      photoBase64: _currentUser!.photoBase64,
    );

    await _saveUserToPrefs();
    notifyListeners();
  }


 Future<void> updateProfilePhoto(String base64Image) async {
  if (_currentUser == null) return;

  _currentUser = _currentUser!.copyWith(photoBase64: base64Image);
  await _saveUserToPrefs();
  notifyListeners();
}



  Future<void> logout() async {
    if (_googleSignIn.currentUser != null) {
      await _googleSignIn.signOut();
    }
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    notifyListeners();
  }

  Future<void> _saveUserToPrefs() async {
    if (_currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(_currentUser!.toJson()));
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
