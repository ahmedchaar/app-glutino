import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Header Text
          Text(
            'Bienvenue sur Glutino',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Votre compagnon pour une vie sans gluten',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF7F8C8D),
            ),
          ),
          const SizedBox(height: 24),

          // Main Hero Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: BoxDecoration(
              color: const Color(0xFF2ECC71), // Main Brand Green
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2ECC71).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF2ECC71),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Mangez en toute\nsécurité',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Scannez des produits, découvrez des\nrecettes et trouvez des restaurants\nsans gluten près de chez vous',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Feature List
          _FeatureCard(
            icon: Icons.center_focus_weak, // Scanner like icon
            title: "Scanner des produits",
            subtitle: "Vérifiez instantanément si un produit\ncontient du gluten",
            color: const Color(0xFFE8F8F5), // Light Green bg
            iconColor: const Color(0xFF2ECC71),
          ),
          const SizedBox(height: 16),
          _FeatureCard(
            icon: Icons.restaurant_menu,
            // chef_hat might not be in material icons by default, using closest
            // Icons.restaurant_menu or local_dining usually work
            iconData: Icons.local_dining, 
            title: "Recettes sans gluten",
            subtitle: "Découvrez des délicieuses recettes\nadaptées à vos besoins",
            color: const Color(0xFFF0F9F6), // Slightly different tint
            iconColor: const Color(0xFF2ECC71),
          ),
          const SizedBox(height: 16),
          _FeatureCard(
            icon: Icons.restaurant,
            title: "Restaurants sûrs",
            subtitle: "Trouvez des restaurants avec des\noptions sans gluten",
            color: const Color(0xFFF0F9F6),
            iconColor: const Color(0xFF2ECC71),
          ),
          const SizedBox(height: 32),

          // Tip Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8F5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF2ECC71).withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb, color: Colors.orange, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF2C3E50),
                        height: 1.5,
                      ),
                      children: const [
                        TextSpan(
                          text: 'Astuce: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: 'Utilisez la barre de navigation ci-dessous pour explorer toutes les fonctionnalités de l\'application',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData? icon;
  final IconData? iconData; // Support both naming conventions if needed
  final String title;
  final String subtitle;
  final Color color;
  final Color iconColor;

  const _FeatureCard({
    this.icon,
    this.iconData,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon ?? iconData, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: const Color(0xFF7F8C8D),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
