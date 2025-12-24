import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glutino_app/screens/tabs/home_tab.dart';
import 'package:glutino_app/screens/tabs/profile_tab.dart';
import 'package:glutino_app/screens/tabs/products_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of tabs
  final List<Widget> _tabs = [
    const HomeTab(),
    const Center(child: Text('Recettes (À venir)')),
    const ProductsTab(),
    const Center(child: Text('Restaurants (À venir)')),
    const Center(child: Text('Courses (À venir)')),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    // Only show AppBar on tabs that are NOT Profile (since Profile has its own internal header)
    // Or we can just remove the global AppBar and let tabs handle it.
    // The design shows no AppBar on Home (just full content), and Profile has "Mon Profil" title.
    // So we will remove the Scaffold AppBar.

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _tabs,
        ),
      ),
      
      // Barre de navigation
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
          selectedItemColor: const Color(0xFF2ECC71), // Green
          unselectedItemColor: const Color(0xFF95A5A6), // Gray
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              // chef_hat not in material default? Let's use local_dining or restaurant_menu
              activeIcon: Icon(Icons.local_dining), // filled
              label: 'Recettes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inbox_outlined), // Box like product
              activeIcon: Icon(Icons.inbox),
              label: 'Produits',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_outlined),
              activeIcon: Icon(Icons.restaurant),
              label: 'Restos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
