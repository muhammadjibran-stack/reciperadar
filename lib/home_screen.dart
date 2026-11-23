import 'package:flutter/material.dart';
import 'recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'recipe_model.dart';

class HomeScreen extends StatefulWidget {
  final Set<String> favouriteIds;
  final ValueChanged<String> onToggleFavourite;

  const HomeScreen({
    super.key,
    required this.favouriteIds,
    required this.onToggleFavourite,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';

  List<Recipe> get _filteredRecipes {
    final String query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return sampleRecipes;
    }
    return sampleRecipes.where((recipe) {
      return recipe.name.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width >= 900 ? 4 : 2;
    final List<Recipe> recipesToShow = _filteredRecipes;

    return Scaffold(
      appBar: AppBar(title: const Text('RecipeRadar')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 4.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search recipes by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: recipesToShow.isEmpty
                ? const Center(
                    child: Text(
                      'No recipes found',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      itemCount: recipesToShow.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final Recipe recipe = recipesToShow[index];
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
                  ),
          ),
        ],
      ),
    );
  }
}
