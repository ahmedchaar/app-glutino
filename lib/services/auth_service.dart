import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService() {
    _loadUser();
  }

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  static const String _userKey = 'user_data';

  Future<void> _loadUser() async {
    // Try to load manually saved user first
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

    // Listen to Firebase Auth state
    _firebaseAuth.authStateChanges().listen((firebaseUser) {
        if (firebaseUser != null) {
             final nameParts = firebaseUser.displayName?.split(' ') ?? ['User'];
             final firstName = nameParts.isNotEmpty ? nameParts.first : 'User';
             final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
             
             _currentUser = User(
               email: firebaseUser.email ?? '',
               firstName: firstName,
               lastName: lastName,
             );
             _saveUserToPrefs(); // Sync to local storage
        }
        notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      // _loadUser listener will handle state update
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
        
        _currentUser = User(
            email: email,
            firstName: firstName,
            lastName: lastName
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
                 // Listener updates state
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
            // NOTE: Requires iOS configuration and entitlement
             final credential = await SignInWithApple.getAppleIDCredential(
                scopes: [
                  AppleIDAuthorizationScopes.email,
                  AppleIDAuthorizationScopes.fullName,
                ],
              );
              
              // Firebase sign in with Apple not fully mocked here without proper tokens, 
              // but this is the standard flow.
              // For now we will just simulate success if credential exists
              debugPrint("Apple ID Credential received: ${credential.email}");
               _currentUser = User(
                  email: credential.email ?? 'apple@user.com',
                  firstName: credential.givenName ?? 'Apple',
                  lastName: credential.familyName ?? 'User'
               );
               await _saveUserToPrefs();
               _setLoading(false);
               return true;
        }
    } catch (e) {
        debugPrint('Social Login Error ($provider): $e');
    }

    _setLoading(false);
    return false;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
    // Facebook Logout?
    await FacebookAuth.instance.logOut();

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
