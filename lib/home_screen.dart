import 'package:flutter/material.dart';
import 'recipe_card.dart';
import 'recipe_detail_screen.dart';
import 'recipe_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width >= 900 ? 4 : 2;

    return Scaffold(
      appBar: AppBar(title: const Text('RecipeRadar')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: sampleRecipes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            final Recipe recipe = sampleRecipes[index];
            return RecipeCard(
              recipe: recipe,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
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
}
