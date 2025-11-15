import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(GlutinoApp());
}

class GlutinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glutino',
      theme: ThemeData(
        primaryColor: Color(0xFFE67E22),
        scaffoldBackgroundColor: Color(0xFFF8F9FA),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          '🍪 GLUTINO',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2C3E50),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Color(0xFF2C3E50)),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person, color: Color(0xFF2C3E50)),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bannière de bienvenue
            _WelcomeBanner(),
            SizedBox(height: 24),
            
            // Section 1: RECHERCHE ALIMENTS SÉCURISÉE
            _SectionTitle(
              title: "🔍 Recherche d'Aliments",
              subtitle: "Scan et analyse des produits",
            ),
            _FeatureGrid(
              features: [
                _FeatureItem(
                  icon: Icons.qr_code_scanner,
                  title: "Scanner Produit",
                  subtitle: "Analyse gluten instantanée",
                  color: Color(0xFF27AE60),
                ),
                _FeatureItem(
                  icon: Icons.search,
                  title: "Base de Données",
                  subtitle: "50 000+ produits analysés",
                  color: Color(0xFF3498DB),
                ),
                _FeatureItem(
                  icon: Icons.info,
                  title: "Détails Nutritionnels",
                  subtitle: "Allergènes complets",
                  color: Color(0xFF9B59B6),
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // Section 2: RESTAURATION & GÉOLOCALISATION
            _SectionTitle(
              title: "📍 Restauration Sûre",
              subtitle: "Manger à l'extérieur sans risque",
            ),
            _FeatureGrid(
              features: [
                _FeatureItem(
                  icon: Icons.map,
                  title: "Restaurants Proches",
                  subtitle: "Lieux certifiés sans gluten",
                  color: Color(0xFFE74C3C),
                ),
                _FeatureItem(
                  icon: Icons.star,
                  title: "Avis Communautaires",
                  subtitle: "Retours d'utilisateurs",
                  color: Color(0xFFF39C12),
                ),
                _FeatureItem(
                  icon: Icons.filter_alt,
                  title: "Filtres Intelligents",
                  subtitle: "Type de repas, budget...",
                  color: Color(0xFF1ABC9C),
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // Section 3: GESTION DU PROFIL
            _SectionTitle(
              title: "👤 Profil Personnalisé",
              subtitle: "Adapté à votre intolérance",
            ),
            _FeatureGrid(
              features: [
                _FeatureItem(
                  icon: Icons.medical_services,
                  title: "Niveau d'Intolérance",
                  subtitle: "Cœliaque, hypersensible...",
                  color: Color(0xFFE67E22),
                ),
                _FeatureItem(
                  icon: Icons.block,
                  title: "Liste d'Évitement",
                  subtitle: "Aliments personnalisés à bannir",
                  color: Color(0xFF95A5A6),
                ),
                _FeatureItem(
                  icon: Icons.bookmark,
                  title: "Historique & Favoris",
                  subtitle: "Produits et lieux préférés",
                  color: Color(0xFF34495E),
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // Section 4: LISTES DE COURSES
            _SectionTitle(
              title: "🛒 Listes de Courses",
              subtitle: "Planifiez vos achats sereinement",
            ),
            _FeatureGrid(
              features: [
                _FeatureItem(
                  icon: Icons.list_alt,
                  title: "Liste Numérique",
                  subtitle: "Création et gestion simple",
                  color: Color(0xFF2ECC71),
                ),
                _FeatureItem(
                  icon: Icons.lightbulb,
                  title: "Alternatives Intelligentes",
                  subtitle: "Suggestions sans gluten",
                  color: Color(0xFF9B59B6),
                ),
                _FeatureItem(
                  icon: Icons.share,
                  title: "Partage Famille",
                  subtitle: "Évitez les erreurs d'achat",
                  color: Color(0xFF3498DB),
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // Section 5: RECETTES & PLANNING
            _SectionTitle(
              title: "👨‍🍳 Recettes Intelligentes",
              subtitle: "Cuisinez sans gluten facilement",
            ),
            _FeatureGrid(
              features: [
                _FeatureItem(
                  icon: Icons.menu_book,
                  title: "Fiches Recettes",
                  subtitle: "Étapes, nutrition, coût",
                  color: Color(0xFFE74C3C),
                ),
                _FeatureItem(
                  icon: Icons.calendar_today,
                  title: "Planning 7 Jours",
                  subtitle: "Menu hebdomadaire équilibré",
                  color: Color(0xFFF39C12),
                ),
                _FeatureItem(
                  icon: Icons.explore,
                  title: "Découverte Rapide",
                  subtitle: "Filtres durée, budget, type",
                  color: Color(0xFF1ABC9C),
                ),
              ],
            ),
            SizedBox(height: 24),
            
            // Section 6: RESSOURCES ÉDUCATIVES
            _SectionTitle(
              title: "📚 Ressources & Conseils",
              subtitle: "Informez-vous et restez à jour",
            ),
            _FeatureGrid(
              features: [
                _FeatureItem(
                  icon: Icons.article,
                  title: "Articles Éducatifs",
                  subtitle: "Cuisine, voyages, fêtes",
                  color: Color(0xFF34495E),
                ),
                _FeatureItem(
                  icon: Icons.cake,
                  title: "Recettes Inspiration",
                  subtitle: "Variez vos plaisirs",
                  color: Color(0xFFE67E22),
                ),
                _FeatureItem(
                  icon: Icons.warning,
                  title: "Alertes Produits",
                  subtitle: "Rappels et nouveautés",
                  color: Color(0xFFE74C3C),
                ),
              ],
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
      
      // Barre de navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFE67E22),
          unselectedItemColor: Color(0xFF7F8C8D),
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w500),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner),
              label: 'Scanner',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Carte',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

// COMPOSANTS RÉUTILISABLES CORRIGÉS

class _WelcomeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE67E22), Color(0xFFD35400)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE67E22).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenue sur Glutino !',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Votre compagnon pour une vie sans gluten sereine',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2C3E50),
          ),
        ),
        SizedBox(height: 4),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Color(0xFF7F8C8D),
          ),
        ),
      ],
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  final List<_FeatureItem> features;

  const _FeatureGrid({required this.features});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        return features[index];
      },
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigation vers la feature
          },
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    color: Color(0xFF7F8C8D),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}