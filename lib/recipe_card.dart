import 'package:flutter/material.dart';
import 'recipe_model.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isFavourite;
  final VoidCallback? onTap;
  final VoidCallback? onFavouriteToggle;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.isFavourite = false,
    this.onTap,
    this.onFavouriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  recipe.imageUrl,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 140,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 6.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      recipe.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onFavouriteToggle,
                    icon: Icon(
                      isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: isFavourite ? Colors.red : Colors.grey,
                    ),
                    tooltip: isFavourite
                        ? 'Remove from favourites'
                        : 'Add to favourites',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
