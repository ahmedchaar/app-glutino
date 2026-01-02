import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glutino_app/screens/tabs/home_tab.dart';
import 'package:glutino_app/screens/tabs/profile_tab.dart';
import 'package:glutino_app/screens/tabs/products_tab.dart';
import 'package:glutino_app/screens/tabs/restos_tab.dart';
import 'package:glutino_app/screens/recipes/recipes_tab.dart';
import 'package:glutino_app/screens/shopping/shopping_list_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      HomeTab(
        onNavigateToRecipes: () => setState(() => _currentIndex = 1),
        onNavigateToProducts: () => setState(() => _currentIndex = 2),
        onNavigateToRestos: () => setState(() => _currentIndex = 3),
      ),
      const RecipesTab(),
      const ProductsTab(),
      const RestosTab(),
      const ShoppingListTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: tabs,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2ECC71),
          unselectedItemColor: const Color(0xFF95A5A6),
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Accueil'),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), activeIcon: Icon(Icons.local_dining), label: 'Recettes'),
            BottomNavigationBarItem(icon: Icon(Icons.inbox_outlined), activeIcon: Icon(Icons.inbox), label: 'Produits'),
            BottomNavigationBarItem(icon: Icon(Icons.restaurant_outlined), activeIcon: Icon(Icons.restaurant), label: 'Restos'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), activeIcon: Icon(Icons.shopping_cart), label: 'Courses'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}