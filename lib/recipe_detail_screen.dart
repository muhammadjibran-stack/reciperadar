import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'favourites_provider.dart';
import 'recipe_api.dart';
import 'recipe_model.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Recipe _recipe;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;

    if (_recipe.instructions.isEmpty && _recipe.id.isNotEmpty) {
      unawaited(_loadFullDetails());
    }
  }

  Future<void> _loadFullDetails() async {
    try {
      final Recipe fullRecipe = await RecipeApi().fetchRecipeById(
        widget.recipe.id,
      );
      if (!mounted) {
        return;
      }

      setState(() {
        _recipe = fullRecipe;
      });

      final FavouritesProvider favouritesProvider = context
          .read<FavouritesProvider>();
      if (favouritesProvider.isFavourite(fullRecipe.id)) {
        await favouritesProvider.cacheRecipeDetails(fullRecipe);
      }
    } catch (_) {
      debugPrint('Full recipe details are unavailable right now.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFavourite = context.watch<FavouritesProvider>().isFavourite(
      _recipe.id,
    );
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_recipe.name),
        actions: [
          IconButton(
            onPressed: () {
              context.read<FavouritesProvider>().toggleFavourite(_recipe);
            },
            icon: Icon(
              isFavourite ? Icons.favorite : Icons.favorite_border,
              color: isFavourite ? Colors.red : null,
            ),
            tooltip: isFavourite
                ? 'Remove from favourites'
                : 'Add to favourites',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _recipe.imageUrl,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
                loadingBuilder: (
                  BuildContext context,
                  Widget child,
                  ImageChunkEvent? loadingProgress,
                ) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return SizedBox(
                    width: double.infinity,
                    height: 240,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                ) {
                  return Container(
                    width: double.infinity,
                    height: 240,
                    color: colorScheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 40,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _recipe.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(_recipe.category)),
                Chip(label: Text(_recipe.area)),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Ingredients',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ..._recipe.ingredients.map(
              (String item) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Instructions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              _recipe.instructions.isEmpty
                  ? 'Instructions are unavailable offline. Reconnect to load full details.'
                  : _recipe.instructions,
              style: const TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
