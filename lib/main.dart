import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'recipe_model.dart';

void main() {
  runApp(const RecipeRadarApp());
}

class RecipeRadarApp extends StatelessWidget {
  const RecipeRadarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RecipeRadar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  final Set<String> _favouriteIds = <String>{};
  final Map<String, Recipe> _knownRecipes = <String, Recipe>{};

  void _cacheRecipe(Recipe recipe) {
    _knownRecipes[recipe.id] = recipe;
  }

  void _toggleFavourite(String recipeId) {
    setState(() {
      if (_favouriteIds.contains(recipeId)) {
        _favouriteIds.remove(recipeId);
      } else {
        _favouriteIds.add(recipeId);
      }
    });
  }

  Widget _buildFavouritesTab(BuildContext context) {
    final List<Recipe> favouriteRecipes = _favouriteIds
        .map((id) => _knownRecipes[id])
        .whereType<Recipe>()
        .toList();

    final double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width >= 900 ? 4 : 2;

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: favouriteRecipes.isEmpty
          ? const Center(
              child: Text(
                'No favourite recipes yet.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: favouriteRecipes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final Recipe recipe = favouriteRecipes[index];
                  return RecipeCard(
                    recipe: recipe,
                    isFavourite: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecipeDetailScreen(
                            recipe: recipe,
                            isFavourite: _favouriteIds.contains(recipe.id),
                            onFavouriteToggle: () {
                              _toggleFavourite(recipe.id);
                            },
                          ),
                        ),
                      );
                    },
                    onFavouriteToggle: () {
                      _toggleFavourite(recipe.id);
                    },
                  );
                },
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = <Widget>[
      HomeScreen(
        favouriteIds: _favouriteIds,
        onToggleFavourite: _toggleFavourite,
        onRecipesLoaded: _cacheRecipe,
      ),
      _buildFavouritesTab(context),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}
