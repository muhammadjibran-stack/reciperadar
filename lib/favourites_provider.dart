import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'recipe_model.dart';

class FavouritesProvider extends ChangeNotifier {
  static const String _storageKey = 'saved_favourites_json';

  List<Recipe> _favourites = <Recipe>[];
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  List<Recipe> get favourites => List<Recipe>.unmodifiable(_favourites);

  bool isFavourite(String recipeId) {
    return _favourites.any((Recipe recipe) => recipe.id == recipeId);
  }

  Future<void> loadFavourites() async {
    final List<Recipe> loadedRecipes = <Recipe>[];

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? rawJson = prefs.getString(_storageKey);

      if (rawJson != null && rawJson.isNotEmpty) {
        final Object? decodedList = jsonDecode(rawJson);
        if (decodedList is List<dynamic>) {
          for (final Object? item in decodedList) {
            if (item is Map<String, dynamic>) {
              final Recipe recipe = Recipe.fromStorageJson(item);
              if (recipe.id.isNotEmpty) {
                loadedRecipes.add(recipe);
              }
            }
          }
        }
      }
    } catch (_) {
      loadedRecipes.clear();
    }

    _favourites = loadedRecipes;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> toggleFavourite(Recipe recipe) async {
    final int existingIndex = _favourites.indexWhere(
      (Recipe saved) => saved.id == recipe.id,
    );

    if (existingIndex >= 0) {
      _favourites.removeAt(existingIndex);
    } else {
      _favourites.add(recipe);
    }

    notifyListeners();
    await _saveFavourites();
  }

  Future<void> cacheRecipeDetails(Recipe recipe) async {
    final int existingIndex = _favourites.indexWhere(
      (Recipe saved) => saved.id == recipe.id,
    );
    if (existingIndex < 0) {
      return;
    }

    _favourites[existingIndex] = recipe;
    notifyListeners();
    await _saveFavourites();
  }

  Future<void> _saveFavourites() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> encodedList = _favourites
          .map((Recipe recipe) => recipe.toStorageJson())
          .toList();
      await prefs.setString(_storageKey, jsonEncode(encodedList));
    } catch (_) {
      debugPrint('Favourites could not be persisted on this device.');
    }
  }
}
