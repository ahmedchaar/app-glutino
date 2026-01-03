import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C3E50)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sécurité du compte',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2C3E50),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Protégez votre compte',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF7F8C8D),
            ),
          ),
          const SizedBox(height: 24),
          _buildSecurityTile(
            context,
            Icons.lock_outline,
            'Changer le mot de passe',
            'Dernière modification il y a 30 jours',
            () => _showComingSoon(context, 'Changement de mot de passe'),
          ),
          _buildSecurityTile(
            context,
            Icons.fingerprint,
            'Authentification biométrique',
            'Utiliser Touch ID ou Face ID',
            () => _showComingSoon(context, 'Authentification biométrique'),
          ),
          _buildSecurityTile(
            context,
            Icons.devices,
            'Appareils connectés',
            'Gérer les appareils autorisés',
            () => _showComingSoon(context, 'Gestion des appareils'),
          ),
          _buildSecurityTile(
            context,
            Icons.history,
            'Historique de connexion',
            'Voir l\'activité récente',
            () => _showComingSoon(context, 'Historique de connexion'),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTile(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F8F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF2ECC71)),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2C3E50),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: const Color(0xFF7F8C8D),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature sera disponible prochainement'),
        backgroundColor: const Color(0xFF2ECC71),
      ),
    );
  }
}
