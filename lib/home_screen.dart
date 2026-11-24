import 'package:flutter/material.dart';
import 'recipe_api.dart';
import 'recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'recipe_model.dart';

class HomeScreen extends StatefulWidget {
  final Set<String> favouriteIds;
  final ValueChanged<String> onToggleFavourite;
  final ValueChanged<Recipe> onRecipesLoaded;

  const HomeScreen({
    super.key,
    required this.favouriteIds,
    required this.onToggleFavourite,
    required this.onRecipesLoaded,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeApi _recipeApi = RecipeApi();
  final TextEditingController _searchController = TextEditingController(
    text: 'chicken',
  );

  late Future<List<Recipe>> _recipesFuture;
  String _currentQuery = 'chicken';

  @override
  void initState() {
    super.initState();
    _recipesFuture = _fetchAndCacheRecipes(_currentQuery);
  }

  Future<List<Recipe>> _fetchAndCacheRecipes(String query) async {
    final String finalQuery = query.trim().isEmpty ? 'chicken' : query.trim();
    final List<Recipe> results = await _recipeApi.searchRecipes(finalQuery);
    for (final Recipe recipe in results) {
      widget.onRecipesLoaded(recipe);
    }
    return results;
  }

  void _runSearch() {
    final String query = _searchController.text.trim();
    setState(() {
      _currentQuery = query.isEmpty ? 'chicken' : query;
      _recipesFuture = _fetchAndCacheRecipes(_currentQuery);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width >= 900 ? 4 : 2;

    return Scaffold(
      appBar: AppBar(title: const Text('RecipeRadar')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _runSearch(),
                    decoration: InputDecoration(
                      hintText: 'Search dish name (press search)...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _runSearch,
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Recipe>>(
              future: _recipesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Could not load recipes. Check your internet connection.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _runSearch,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final List<Recipe> recipes = snapshot.data ?? <Recipe>[];
                if (recipes.isEmpty) {
                  return const Center(
                    child: Text(
                      'No recipes found',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    itemCount: recipes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final Recipe recipe = recipes[index];
                      final bool isFav = widget.favouriteIds.contains(
                        recipe.id,
                      );

                      return RecipeCard(
                        recipe: recipe,
                        isFavourite: isFav,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailScreen(
                                recipe: recipe,
                                isFavourite: widget.favouriteIds.contains(
                                  recipe.id,
                                ),
                                onFavouriteToggle: () {
                                  widget.onToggleFavourite(recipe.id);
                                },
                              ),
                            ),
                          );
                        },
                        onFavouriteToggle: () {
                          widget.onToggleFavourite(recipe.id);
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
