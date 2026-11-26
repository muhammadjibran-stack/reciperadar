import 'dart:convert';

import 'package:http/http.dart' as http;

import 'recipe_model.dart';

class RecipeApi {
  static const String _baseUrl = 'www.themealdb.com';
  static const String _apiPath = '/api/json/v1/1';

  Future<List<Recipe>> searchRecipes(String query) async {
    final String cleanQuery = query.trim();
    final Uri url = Uri.https(
      _baseUrl,
      '$_apiPath/search.php',
      <String, String>{'s': cleanQuery},
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
    for (final Object? item in meals as List<dynamic>) {
      if (item is Map<String, dynamic>) {
        recipes.add(Recipe.fromJson(item));
      }
    }

    return recipes;
  }

  Future<Recipe> fetchRecipeById(String id) async {
    final Uri url = Uri.https(
      _baseUrl,
      '$_apiPath/lookup.php',
      <String, String>{'i': id.trim()},
    );

    final http.Response response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load recipe details (Status: ${response.statusCode})',
      );
    }

    final Map<String, dynamic> decoded =
        jsonDecode(response.body) as Map<String, dynamic>;
    final dynamic meals = decoded['meals'];

    if (meals is List<dynamic> && meals.isNotEmpty) {
      final Object? firstMeal = meals.first;
      if (firstMeal is Map<String, dynamic>) {
        return Recipe.fromJson(firstMeal);
      }
    }

    throw Exception('Recipe details were not found for id $id.');
  }
}
