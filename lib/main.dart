import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:glutino_app/screens/login_screen.dart';
import 'package:glutino_app/screens/home_screen.dart';
import 'package:glutino_app/services/auth_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/language_provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: const GlutinoApp(),
    ),
  );
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