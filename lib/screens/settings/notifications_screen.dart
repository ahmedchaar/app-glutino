import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _newProducts = true;
  bool _newRestaurants = true;
  bool _recipeUpdates = false;
  bool _promotions = false;

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
          'Notifications',
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
            'Gérer vos notifications',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF7F8C8D),
            ),
          ),
          const SizedBox(height: 24),
          _buildNotificationTile(
            'Nouveaux produits',
            'Recevoir des notifications pour les nouveaux produits sans gluten',
            _newProducts,
            (val) => setState(() => _newProducts = val),
          ),
          _buildNotificationTile(
            'Nouveaux restaurants',
            'Être informé des nouveaux restaurants sans gluten',
            _newRestaurants,
            (val) => setState(() => _newRestaurants = val),
          ),
          _buildNotificationTile(
            'Mises à jour des recettes',
            'Nouvelles recettes et conseils culinaires',
            _recipeUpdates,
            (val) => setState(() => _recipeUpdates = val),
          ),
          _buildNotificationTile(
            'Promotions',
            'Offres spéciales et réductions',
            _promotions,
            (val) => setState(() => _promotions = val),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: SwitchListTile(
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
        value: value,
        activeColor: const Color(0xFF2ECC71),
        onChanged: onChanged,
      ),
    );
  }
}
