import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de la connexion. Vérifiez vos identifiants.')),
      );
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.socialLogin(provider);

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connexion $provider échouée. Vérifiez la configuration (SHA-1/Console).'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showResetPasswordDialog() {
    final emailCtrl = TextEditingController(text: _emailController.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Réinitialiser le mot de passe", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Entrez votre email pour recevoir un lien de réinitialisation.", style: GoogleFonts.poppins()),
            const SizedBox(height: 10),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (emailCtrl.text.isEmpty) return;
              
              final auth = Provider.of<AuthService>(context, listen: false);
              final success = await auth.resetPassword(emailCtrl.text);
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(success ? "Email envoyé !" : "Erreur lors de l'envoi."),
                  backgroundColor: success ? Colors.green : Colors.red,
                ));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2ECC71), foregroundColor: Colors.white),
            child: const Text("Envoyer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthService>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF2ECC71)))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Logo Placeholder/Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2ECC71),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Bienvenue sur\nGlutino',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2C3E50),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Votre compagnon pour une vie sans gluten',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF7F8C8D),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Email Input
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Adresse e-mail',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'votreemail@example.com',
                        hintStyle: GoogleFonts.poppins(color: const Color(0xFF95A5A6)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Input
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Mot de passe',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        hintStyle: GoogleFonts.poppins(color: const Color(0xFF95A5A6)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: const Color(0xFF95A5A6),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                          );
                        },
                        child: Text(
                          'Mot de passe oublié ?',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF2ECC71),
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2ECC71),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Se connecter',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'ou continuer avec',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF95A5A6),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.withOpacity(0.3))),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Social Buttons
                    _SocialButton(
                      icon: 'assets/google.png',
                      label: 'Continuer avec Google',
                      onPressed: () => _handleSocialLogin('Google'),
                      iconData: Icons.g_mobiledata,
                      iconColor: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    _SocialButton(
                      icon: 'assets/facebook.png',
                      label: 'Continuer avec Facebook',
                      onPressed: () => _handleSocialLogin('Facebook'),
                      iconData: Icons.facebook,
                      iconColor: Colors.blue,
                    ),
                    const SizedBox(height: 16),
                    _SocialButton(
                      icon: 'assets/apple.png',
                      label: 'Continuer avec Apple',
                      onPressed: () => _handleSocialLogin('Apple'),
                      iconData: Icons.apple,
                      iconColor: Colors.black,
                    ),

                    const SizedBox(height: 48),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vous n'avez pas de compte ? ",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF7F8C8D),
                            fontSize: 12,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUpScreen()),
                            );
                          },
                          child: Text(
                            'S\'inscrire maintenant',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF2ECC71),
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onPressed;
  final IconData? iconData;
  final Color? iconColor;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconData,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.withOpacity(0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            if (iconData != null)
              Icon(iconData, color: iconColor, size: 24),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF2C3E50),
                ),
              ),
            ),
            const SizedBox(width: 44),
          ],
        ),
      ),
    );
  }
}
