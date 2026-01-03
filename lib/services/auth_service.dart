import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService() {
    _initAuth();
  }

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  void _initAuth() {
    _firebaseAuth.authStateChanges().listen((firebaseUser) async {
        if (firebaseUser != null) {
             final email = firebaseUser.email ?? '';
             
             final prefs = await SharedPreferences.getInstance();
             final key = 'user_metadata_$email';
             String? userData = prefs.getString(key);
             
             // SAFEGUARD: If user data is > 5MB, it's likely corrupted/bloated. Clear it.
             if (userData != null && userData.length > 5 * 1024 * 1024) {
                debugPrint("CRITICAL: User data too large (${userData.length}). Clearing.");
                await prefs.remove(key);
                userData = null;
             }
             
             if (userData != null) {
                try {
                   _currentUser = User.fromJson(jsonDecode(userData));
                } catch (e) {
                   debugPrint("Error decoding user metadata: $e");
                }
             } else {
                final nameParts = firebaseUser.displayName?.split(' ') ?? ['User'];
                final firstName = nameParts.isNotEmpty ? nameParts.first : 'User';
                final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
                
                _currentUser = User(
                  email: email,
                  firstName: firstName,
                  lastName: lastName,
                );
             }
        } else {
             _currentUser = null;
        }
        notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      _setLoading(false);
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> signUp(String firstName, String lastName, String email, String password) async {
    _setLoading(true);
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await credential.user!.updateDisplayName("$firstName $lastName");
        
        // 🔥 Create and save initial user metadata immediately
        _currentUser = User(
          email: email,
          firstName: firstName,
          lastName: lastName,
        );
        await _saveUserToPrefs();
      }
      _setLoading(false);
      return true;
    } catch (e) {
      debugPrint('Signup error: $e');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
      try {
          await _firebaseAuth.sendPasswordResetEmail(email: email);
          return true;
      } catch (e) {
          debugPrint("Reset password error: $e");
          return false;
      }
  }

  Future<bool> socialLogin(String provider) async {
    _setLoading(true);

    try {
        if (provider == 'Google') {
            final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
            if (googleUser != null) {
                final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
                final firebase_auth.AuthCredential credential = firebase_auth.GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                );
                await _firebaseAuth.signInWithCredential(credential);
                _setLoading(false);
                return true;
            }
        } else if (provider == 'Facebook') {
             final LoginResult result = await FacebookAuth.instance.login();
             if (result.status == LoginStatus.success) {
                  final AccessToken accessToken = result.accessToken!;
                  final firebase_auth.AuthCredential credential = firebase_auth.FacebookAuthProvider.credential(accessToken.tokenString);
                  await _firebaseAuth.signInWithCredential(credential);
                   _setLoading(false);
                   return true;
             }
        } else if (provider == 'Apple') {
             final credential = await SignInWithApple.getAppleIDCredential(
                scopes: [
                  AppleIDAuthorizationScopes.email,
                  AppleIDAuthorizationScopes.fullName,
                ],
              );
              
              debugPrint("Apple ID Credential received: ${credential.email}");
               // Mocking successful auth for Apple as we need real backend for full flow usually
               _currentUser = User(
                  email: credential.email ?? 'apple@user.com',
                  firstName: credential.givenName ?? 'Apple',
                  lastName: credential.familyName ?? 'User'
               );
               _setLoading(false);
               return true;
        }
    } catch (e) {
        debugPrint('Social Login Error ($provider): $e');
    }

    _setLoading(false);
    return false;
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

  Future<void> updateSensitivity(String level) async {
    if (_currentUser == null) return;

    _currentUser = _currentUser!.copyWith(sensitivity: level);
    await _saveUserToPrefs();
    notifyListeners();
  }

  Future<void> _saveUserToPrefs() async {
    if (_currentUser == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_metadata_${_currentUser!.email}', jsonEncode(_currentUser!.toJson()));
    } catch (e) {
      debugPrint("Error saving user to prefs: $e");
    }
  }



  Future<void> logout() async {
    try {
        await _firebaseAuth.signOut();
    } catch (e) {
        debugPrint("Firebase SignOut Error: $e");
    }
    
    try {
        if (await _googleSignIn.isSignedIn()) {
          await _googleSignIn.signOut();
        }
    } catch (e) {
        debugPrint("Google SignOut Error: $e");
    }

    try {
        await FacebookAuth.instance.logOut();
    } catch (e) {
        // Ignored
    }

    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
