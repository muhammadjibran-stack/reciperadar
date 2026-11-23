class Recipe {
  final String id;
  final String name;
  final String category;
  final String area;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;

  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
  });
}

const List<Recipe> sampleRecipes = [
  Recipe(
    id: '1',
    name: 'Chicken Biryani',
    category: 'Rice',
    area: 'South Asian',
    imageUrl:
        'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=800',
    ingredients: [
      '2 cups Basmati rice',
      '500g chicken',
      '1 cup yogurt',
      'Biryani spices & onions',
    ],
    instructions:
        'Marinate chicken with yogurt and spices. Cook rice until partially done. Layer rice and chicken in a pot and steam until cooked.',
  ),
  Recipe(
    id: '2',
    name: 'Margherita Pizza',
    category: 'Main Course',
    area: 'Italian',
    imageUrl:
        'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800',
    ingredients: [
      '1 pizza dough',
      '1/2 cup tomato sauce',
      '150g mozzarella cheese',
      'Fresh basil leaves',
    ],
    instructions:
        'Roll out the dough, spread tomato sauce, add mozzarella cheese, and bake until golden and bubbly. Top with fresh basil.',
  ),
  Recipe(
    id: '3',
    name: 'Beef Burger',
    category: 'Fast Food',
    area: 'American',
    imageUrl:
        'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
    ingredients: [
      '2 burger buns',
      '250g minced beef',
      'Lettuce & tomato slices',
      'Cheese slice & sauce',
    ],
    instructions:
        'Shape beef into patties and pan-sear until cooked. Toast buns, assemble with lettuce, tomato, cheese, patty, and sauce.',
  ),
  Recipe(
    id: '4',
    name: 'Chocolate Pancakes',
    category: 'Dessert',
    area: 'American',
    imageUrl:
        'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800',
    ingredients: [
      '1 cup flour',
      '2 tbsp cocoa powder',
      '1 egg & 3/4 cup milk',
      '2 tbsp sugar & baking powder',
    ],
    instructions:
        'Whisk dry and wet ingredients into a smooth batter. Pour small rounds onto a hot greased pan and flip when bubbles form.',
  ),
];
