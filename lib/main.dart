import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:glutino_app/screens/login_screen.dart';
import 'package:glutino_app/screens/home_screen.dart';
import 'package:glutino_app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: const GlutinoApp(),
    ),
  );
}

class GlutinoApp extends StatelessWidget {
  const GlutinoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glutino',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 12, 162, 77),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
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
  void initState() {
    super.initState();
    // Check session on startup is handled by AuthService constructor,
    // but we can trigger a refresh if needed or just wait for it to be ready.
    // Since AuthService loads async, we rely on Consumer/watch.
  }

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