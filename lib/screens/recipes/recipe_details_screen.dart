import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/recipe_model.dart';
import 'package:provider/provider.dart';
import '../../providers/shopping_provider.dart';
import '../shopping/shopping_list_tab.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(recipe.title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(recipe.image, height: 250, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.title, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(recipe.description, style: GoogleFonts.poppins(color: Colors.grey[700], fontSize: 14)),
                  const SizedBox(height: 12),
                  // Tags
                  if (recipe.tags.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: recipe.tags.map((t) => Chip(label: Text(t))).toList(),
                    ),
                  const SizedBox(height: 18),

                  // The Grid of info cards
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      _buildInfoCard(Icons.timer, 'Préparation', recipe.prepTime),
                      _buildInfoCard(Icons.outdoor_grill, 'Cuisson', recipe.cookTime),
                      _buildInfoCard(Icons.group, 'Portions', recipe.servings),
                      _buildInfoCard(Icons.restaurant_menu, 'Difficulté', recipe.difficulty),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  Text('Ingrédients', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  ...recipe.ingredients.map((ing) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.circle, size: 8, color: Colors.black54),
                            const SizedBox(width: 8),
                            Expanded(child: Text(ing, style: GoogleFonts.poppins(fontSize: 14)))
                          ],
                        ),
                      )),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      // 1. Add ingredients to the provider
                      Provider.of<ShoppingProvider>(context, listen: false)
                          .addIngredients(recipe.ingredients, recipe.title);

                      // 2. Show a quick confirmation message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ingrédients de ${recipe.title} ajoutés !'),
                          backgroundColor: const Color(0xFF5ED3A3),
                        ),
                      );


                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShoppingListTab()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5ED3A3), // Matches Figma
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('Ajouter à la liste de courses', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF5ED3A3)),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}