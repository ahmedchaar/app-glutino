class Recipe {
  final String id;
  final String title;
  final String image;
  final String description;
  final List<String> ingredients;
  final String prepTime;
  final String cookTime;
  final String servings;
  final String difficulty;
  final List<String> tags;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.ingredients,
    this.prepTime = '15 min',
    this.cookTime = '50 min',
    this.servings = '8',
    this.difficulty = 'Facile',
    this.tags = const ['Petit-Déjeuner', 'Dessert'],
  });
}