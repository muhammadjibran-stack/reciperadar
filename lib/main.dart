import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'favourites_provider.dart';
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
    return ChangeNotifierProvider<FavouritesProvider>(
      create: (_) => FavouritesProvider()..loadFavourites(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RecipeRadar',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        home: const MainNavigationScreen(),
      ),
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

  Widget _buildFavouritesTab(BuildContext context) {
    final List<Recipe> favouriteRecipes = context
        .watch<FavouritesProvider>()
        .favourites;
    final double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width >= 900 ? 4 : 2;

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: favouriteRecipes.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No favourites saved yet. Tap the heart on a recipe to add it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
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
                itemBuilder: (BuildContext context, int index) {
                  final Recipe recipe = favouriteRecipes[index];
                  return RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => RecipeDetailScreen(recipe: recipe),
                        ),
                      );
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
      const HomeScreen(),
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
