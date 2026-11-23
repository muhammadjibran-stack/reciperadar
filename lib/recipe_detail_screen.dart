import 'package:flutter/material.dart';
import 'recipe_model.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final bool isFavourite;
  final VoidCallback? onFavouriteToggle;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    this.isFavourite = false,
    this.onFavouriteToggle,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late bool _isFav;

  @override
  void initState() {
    super.initState();
    _isFav = widget.isFavourite;
  }

  void _handleToggleFavourite() {
    setState(() {
      _isFav = !_isFav;
    });
    widget.onFavouriteToggle?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
        actions: [
          IconButton(
            onPressed: _handleToggleFavourite,
            icon: Icon(
              _isFav ? Icons.favorite : Icons.favorite_border,
              color: _isFav ? Colors.red : null,
            ),
            tooltip: _isFav ? 'Remove from favourites' : 'Add to favourites',
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
                widget.recipe.imageUrl,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 240,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 40),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.recipe.name,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(widget.recipe.category)),
                Chip(label: Text(widget.recipe.area)),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 18, fontWeight: .bold),
            ),
            const SizedBox(height: 8),
            ...widget.recipe.ingredients.map(
              (item) => Padding(
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
            const Text(
              'Instructions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.recipe.instructions,
              style: const TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
