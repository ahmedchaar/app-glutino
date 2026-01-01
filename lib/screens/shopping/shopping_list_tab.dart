import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/shopping_provider.dart';

class ShoppingListTab extends StatelessWidget {
  const ShoppingListTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2C3E50), size: 20),
          onPressed: () => Navigator.pop(context), // Reculer à la page precedente
        ),
        title: Text(
          'Ma Liste',
          style: GoogleFonts.poppins(
            color: const Color(0xFF2C3E50),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // -----------------------
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Success Banner
              _buildSuccessBanner(),

              const SizedBox(height: 30),

              // 2. Title Section
              _buildTitleSection(),

              const SizedBox(height: 20),

              // 3. Dynamic Ingredients List
              Consumer<ShoppingProvider>(
                builder: (context, shoppingData, child) {
                  return Column(
                    children: [
                      ...shoppingData.items.asMap().entries.map((entry) {
                        int index = entry.key;
                        var item = entry.value;

                        return _buildIngredientItem(
                          (index + 1).toString(), 
                          item['name']!,          
                          item['type'] ?? "Article",           
                        );
                      }).toList(),
                      
                      
                      if (shoppingData.items.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Text(
                              'Aucun article ajouté',
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildIngredientItem(String number, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEDF9F4),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(
                color: Color(0xFF5ED3A3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessBanner() {
    return Consumer<ShoppingProvider>(
      builder: (context, shoppingData, child) {
        // If no recipe was added yet, show a generic welcome banner
        String lastItem = shoppingData.lastRecipeName.isEmpty 
            ? "votre sélection" 
            : shoppingData.lastRecipeName;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF5ED3A3), // Solid green like your Figma success state
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ajouté avec succès !',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Dernier ajout: $lastItem',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                       ),
                     ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Liste de courses',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Gérez les ingrédients ajoutés depuis les recettes',
          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }
}