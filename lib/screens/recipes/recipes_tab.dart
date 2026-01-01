import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/recipe_model.dart';
import 'recipe_details_screen.dart';

class RecipesTab extends StatelessWidget {
  const RecipesTab({super.key});

  static final List<Recipe> recipes = [
    Recipe(
      id: '1',
      title: 'Pain à la banane sans gluten',
      image: 'assets/images/recipes/banana_bread.png',
      description: 'Un cake à la banane moelleux et délicieux, parfait pour le petit-déjeuner ou le goûter.',
      ingredients: ['3 Bananes mûres', '2 tasses de farine sans gluten', '2 Œufs', '1/3 tasse de miel', '1 cuillère à café de bicarbonate de soude'],
      prepTime: '15 min',
      cookTime: '50 min',
      servings: '8 pers.',
      difficulty: 'Facile',
      tags: ['Petit-Déjeuner', 'Dessert', 'Sans-Gluten'],
    ),
    Recipe(
      id: '2',
      title: 'Bol d’énergie au Quinoa',
      image: 'assets/images/recipes/quinoa_bowl.png',
      description: 'Un bol riche en nutriments avec des légumes frais, du quinoa protéiné et de l\'avocat crémeux.',
      ingredients: ['1 tasse de Quinoa', '1 Avocat', '2 tasses d\'épinards', 'Vinaigrette au citron', 'Tomates cerises'],
      prepTime: '10 min',
      cookTime: '15 min',
      servings: '2 pers.',
      difficulty: 'Facile',
      tags: ['Déjeuner', 'Sain', 'Végétalien'],
    ),
    Recipe(
      id: '3',
      title: 'Gâteau au chocolat sans farine',
      image: 'assets/images/recipes/chocolate_cake.png',
      description: 'Un cœur chocolaté fondant et riche, réalisé sans aucune farine contenant du gluten.',
      ingredients: ['200g de chocolat noir', '100g de beurre', '3 Œufs', '50g de cacao en poudre'],
      prepTime: '15 min',
      cookTime: '12 min',
      servings: '4 pers.',
      difficulty: 'Facile',
      tags: ['Dessert', 'Sans-Gluten'],
    ),
    Recipe(
      id: '4',
      title: 'Zoodles au Pesto de Citron',
      image: 'assets/images/recipes/zoodles.png',
      description: 'Une alternative légère aux pâtes utilisant des nouilles de courgettes et un pesto maison.',
      ingredients: ['2 Grandes courgettes', 'Basilic frais', 'Pignons de pin', 'Parmesan', 'Huile d\'olive'],
      prepTime: '20 min',
      cookTime: '5 min',
      servings: '2 pers.',
      difficulty: 'Facile',
      tags: ['Dîner', 'Faible en glucides'],
    ),
    Recipe(
      id: '5',
      title: 'Pizza à la pâte de chou-fleur',
      image: 'assets/images/recipes/pizza.png',
      description: 'Le goût classique de la pizza avec une pâte croustillante faite de chou-fleur et de fromage.',
      ingredients: ['1 tête de chou-fleur', '1 Œuf', 'Mozzarella', 'Sauce tomate', 'Origan'],
      prepTime: '20 min',
      cookTime: '25 min',
      servings: '2 pers.',
      difficulty: 'Moyen',
      tags: ['Dîner', 'Sans-Gluten'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Recettes',
                style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: recipes.length,
                itemBuilder: (context, index) => _buildRecipeCard(context, recipes[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Recipe recipe) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RecipeDetailsScreen(recipe: recipe)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black12, 
              blurRadius: 10, 
              offset: const Offset(0, 5)
            )
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Image.asset(
                recipe.image, 
                height: 180, 
                width: double.infinity, 
                fit: BoxFit.cover
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title, 
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipe.description, 
                    style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13)
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Color(0xFF5ED3A3)),
                      const SizedBox(width: 4),
                      Text(recipe.prepTime, style: GoogleFonts.poppins(fontSize: 12)),
                      const SizedBox(width: 15),
                      const Icon(Icons.people_outline, size: 16, color: Color(0xFF5ED3A3)),
                      const SizedBox(width: 4),
                      Text(recipe.servings, style: GoogleFonts.poppins(fontSize: 12)),
                      const SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF9F4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          recipe.difficulty,
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF5ED3A3),
                            fontSize: 11,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}