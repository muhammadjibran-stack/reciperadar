import 'dart:convert';
import 'package:http/http.dart' as http;
import 'recipe_model.dart';

class RecipeApi {
  Future<List<Recipe>> searchRecipes(String query) async {
    final String cleanQuery = query.trim();
    final Uri url = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/search.php?s=$cleanQuery',
    );

    final http.Response response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load recipes (Status: ${response.statusCode})',
      );
    }

    final Map<String, dynamic> decoded =
        jsonDecode(response.body) as Map<String, dynamic>;
    final dynamic meals = decoded['meals'];

    if (meals == null) {
      return <Recipe>[];
    }

    final List<Recipe> recipes = <Recipe>[];
    for (final dynamic item in (meals as List<dynamic>)) {
      if (item is Map<String, dynamic>) {
        recipes.add(Recipe.fromJson(item));
      }
    }

    return recipes;
  }
}
