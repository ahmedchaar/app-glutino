import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../login_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Title
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mon Profil',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C3E50),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, color: Color(0xFF2ECC71)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Avatar Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F8F5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Color(0xFF2ECC71),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user != null ? '${user.firstName} ${user.lastName}' : 'Utilisateur',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  user?.email ?? 'email@example.com',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF95A5A6),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Modification non implémentée')));
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Modifier le profil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2ECC71),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Preferences de santé
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Préférences de santé',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2C3E50),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Niveau de sensibilité au gluten',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF7F8C8D),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: 'Cœliaque strict',
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                  ),
                  items: ['Cœliaque strict', 'Sensible', 'Préférence'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {},
                ),
                const SizedBox(height: 16),
                Text(
                  'Langue de l\'application',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFF7F8C8D),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2ECC71),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("Français", style: GoogleFonts.poppins(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFF0F0F0),
                          foregroundColor: Colors.black,
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text("عربي", style: GoogleFonts.poppins(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Mes Favoris
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Mes Favoris',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2C3E50),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _FavoriteCard(
                  icon: Icons.restaurant,
                  title: "Restaurants\nenregistrés",
                  color: const Color(0xFFE8F8F5), // Light Green
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _FavoriteCard(
                  icon: Icons.qr_code_scanner, // Should be barcode like
                  iconData: Icons.barcode_reader,
                  title: "Produits\nenregistrés",
                  color: const Color(0xFFE8F8F5),
                ),
              ),
            ],
          ),
           const SizedBox(height: 32),

          // Settings List
          _SettingsTile(icon: Icons.notifications_none, title: "Notifications"),
          _SettingsTile(icon: Icons.security, title: "Sécurité du compte"),
          _SettingsTile(icon: Icons.lock_outline, title: "Confidentialité"),
          _SettingsTile(icon: Icons.help_outline, title: "Aide & Support"),

          const SizedBox(height: 32),

          // Logout Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Déconnexion", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                    content: Text("Êtes-vous sûr de vouloir vous déconnecter ?", style: GoogleFonts.poppins()),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Annuler", style: GoogleFonts.poppins(color: Colors.grey)),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context); // Close dialog
                          await Provider.of<AuthService>(context, listen: false).logout();
                          if (context.mounted) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
                          }
                        },
                        child: Text("Déconnexion", style: GoogleFonts.poppins(color: const Color(0xFFE74C3C), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text('Déconnexion'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE74C3C), // Red
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
           const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final IconData? icon;
  final IconData? iconData;
  final String title;
  final Color color;

  const _FavoriteCard({
    this.icon,
    this.iconData,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFA5E6D2).withOpacity(0.5), // Mint-ish color from image
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon ?? iconData, color: const Color(0xFF2ECC71), size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SettingsTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2ECC71)),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF2C3E50),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          // Navigation logic placeholder
        },
      ),
    );
  }
}
