enum GlutenStatus {
  safe,
  mayContain,
  contains,
  unknown
}

class Product {
  final String barcode;
  final String name;
  final String brands;
  final String imageUrl;
  final String ingredientsText;
  final List<String> allergensTags;
  final List<String> ingredientsTags;
  final GlutenStatus status;

  Product({
    required this.barcode,
    required this.name,
    required this.brands,
    required this.imageUrl,
    required this.ingredientsText,
    required this.allergensTags,
    required this.ingredientsTags,
    required this.status,
  });

  // Factory for API response
  factory Product.fromJson(Map<String, dynamic> json) {
    // Check if it's from local storage (simplified structure) or API (nested)
    if (json.containsKey('saved_status')) {
      return Product.fromLocalJson(json);
    }
    
    // 1. Basic Fields (API)
    final barcode = json['code'] ?? '';
    final product = json['product'] ?? {};
    final name = product['product_name'] ?? 'Nom inconnu';
    final brands = product['brands'] ?? 'Marque inconnue';
    final imageUrl = product['image_front_url'] ?? '';
    final ingredientsText = product['ingredients_text_fr'] ?? product['ingredients_text'] ?? '';
    
    // 2. Tags parsing
    final allergens = List<String>.from(product['allergens_tags'] ?? []);
    final ingredients = List<String>.from(product['ingredients_tags'] ?? []);

    // 3. Logic Analysis
    final status = _analyzeGluten(allergens, ingredients, ingredientsText);

    return Product(
      barcode: barcode,
      name: name,
      brands: brands,
      imageUrl: imageUrl,
      ingredientsText: ingredientsText,
      allergensTags: allergens,
      ingredientsTags: ingredients,
      status: status,
    );
  }

  // Factory for Local Storage
  factory Product.fromLocalJson(Map<String, dynamic> json) {
    return Product(
      barcode: json['barcode'] ?? '',
      name: json['name'] ?? '',
      brands: json['brands'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      ingredientsText: json['ingredientsText'] ?? '',
      allergensTags: List<String>.from(json['allergensTags'] ?? []),
      ingredientsTags: List<String>.from(json['ingredientsTags'] ?? []),
      status: GlutenStatus.values[json['saved_status'] ?? 0],
    );
  }

  // To JSON for Local Storage
  Map<String, dynamic> toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'brands': brands,
      'imageUrl': imageUrl,
      'ingredientsText': ingredientsText,
      'allergensTags': allergensTags,
      'ingredientsTags': ingredientsTags,
      'saved_status': status.index,
    };
  }

  static GlutenStatus _analyzeGluten(List<String> allergens, List<String> ingredients, String text) {
    // A. Check explicit allergens tags (Standardized by OFF)
    // "en:gluten", "fr:gluten"
    for (var tag in allergens) {
      if (tag.contains('gluten') || tag.contains('blé') || tag.contains('wheat') || tag.contains('orge') || tag.contains('seigle')) {
        return GlutenStatus.contains;
      }
    }

    // B. Check Keywords in Text (Fallback)
    final lowerText = text.toLowerCase();
    if (lowerText.contains('gluten') || 
        lowerText.contains('blé') || 
        lowerText.contains('froment') || 
        lowerText.contains('orge') || 
        lowerText.contains('seigle') || 
        lowerText.contains('kamut') ||
        lowerText.contains('épeautre')) {
      return GlutenStatus.contains;
    }

    // C. Check "Traces"
    // Usually handled separately, but let's check basic trace warning if available or generic text
    if (lowerText.contains('peut contenir') && (lowerText.contains('gluten') || lowerText.contains('blé'))) {
      return GlutenStatus.mayContain;
    }

    // D. Safe
    return GlutenStatus.safe;
  }
}
