import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:glutino_app/screens/login_screen.dart';
import 'package:glutino_app/screens/home_screen.dart';
import 'package:glutino_app/services/auth_service.dart';
import 'package:glutino_app/services/saved_products_service.dart';
import 'package:glutino_app/providers/shopping_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/language_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => ShoppingProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => SavedProductsService()),
        ],
        child: const GlutinoApp(),
      ),
    );
  } catch (e) {
    debugPrint("CRITICAL STARTUP ERROR: $e");
    runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RescueScreen(),
    ));
  }
}

class RescueScreen extends StatelessWidget {
  const RescueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isResetting = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 24),
                  const Text(
                    "Erreur Critique au Démarrage",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "L'application ne peut pas démarrer suite à une erreur de mémoire.\nCliquez sur le bouton pour réparer.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: isResetting ? null : () async {
                      setState(() => isResetting = true);
                      debugPrint("RESCUE: Starting Resilient Hard Reset...");
                      
                      // 1. Native Hard Reset
                      try {
                        debugPrint("RESCUE: Calling native forceClearStorage...");
                        const channel = MethodChannel('com.example.glutino/storage');
                        await channel.invokeMethod('forceClearStorage');
                        debugPrint("RESCUE: Native reset successful");
                      } catch (e) {
                        debugPrint("RESCUE: Native reset failed (continuing...): $e");
                      }

                      // 2. Clear Secure Storage
                      try {
                        debugPrint("RESCUE: Clearing Secure Storage...");
                        const storage = FlutterSecureStorage();
                        await storage.deleteAll();
                        debugPrint("RESCUE: Secure Storage cleared");
                      } catch (e) {
                        debugPrint("RESCUE: Secure Storage clear failed: $e");
                      }

                      // 3. Clear SharedPreferences from Dart
                      try {
                        debugPrint("RESCUE: Clearing SharedPreferences from Dart...");
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        debugPrint("RESCUE: Dart-side prefs cleared");
                      } catch (e) {
                        debugPrint("RESCUE: Dart clear failed (expected if OOM): $e");
                      }

                      // 4. Final status
                      debugPrint("RESCUE: All reset attempts finished.");
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Tentative de réinitialisation terminée. Veuillez relancer l'application."),
                            backgroundColor: Colors.blueAccent,
                            duration: Duration(seconds: 5),
                          ),
                        );
                      }
                      if (context.mounted) setState(() => isResetting = false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isResetting 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Réinitialiser l'application"),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "(Note: Cela supprimera vos données locales pour réparer le crash)",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}


class GlutinoApp extends StatelessWidget {
  const GlutinoApp({super.key});

 @override
Widget build(BuildContext context) {
  final languageProvider = context.watch<LanguageProvider>();

  return MaterialApp(
    title: 'Glutino',
    debugShowCheckedModeBanner: false,

    locale: languageProvider.locale,

    supportedLocales: const [
      Locale('fr'),
      Locale('ar'),
    ],

    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],

    theme: ThemeData(
      primaryColor: const Color.fromARGB(255, 12, 162, 77),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      fontFamily: GoogleFonts.poppins().fontFamily,
    ),

    home: const AuthWrapper(),
  );
}

}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        if (authService.isAuthenticated) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}