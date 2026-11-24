class Recipe {
  final String id;
  final String name;
  final String category;
  final String area;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;

  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final List<String> parsedIngredients = <String>[];

    for (int i = 1; i <= 20; i++) {
      final dynamic ingredientValue = json['strIngredient$i'];
      if (ingredientValue != null) {
        final String text = ingredientValue.toString().trim();
        if (text.isNotEmpty) {
          parsedIngredients.add(text);
        }
      }
    }

    return Recipe(
      id: (json['idMeal'] ?? '').toString(),
      name: (json['strMeal'] ?? 'Unknown Recipe').toString(),
      category: (json['strCategory'] ?? 'General').toString(),
      area: (json['strArea'] ?? 'International').toString(),
      imageUrl: (json['strMealThumb'] ?? '').toString(),
      ingredients: parsedIngredients,
      instructions: (json['strInstructions'] ?? '').toString(),
    );
  }
}
