<!-- # reciperadar

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference. -->

<!-- # RecipeRadar (Week 1)

Flutter recipe app built with hardcoded sample recipes, HomeScreen grid, RecipeCard widget, and RecipeDetailScreen. -->

<!-- # RecipeRadar

Flutter recipe app built for the App Developer internship (Week 2: Navigation, Search & Favourites).

## Week 2 Features

- Tap any recipe card to open `RecipeDetailScreen` with the selected recipe.
- Search recipes live by name using a top search bar, clear to show all recipes, or show a message when no match is found.
- Toggle favourites with the heart icon and switch between **Home** and **Favourites** using a bottom navigation bar.

## Run Locally

```bash
flutter pub get
flutter run -d chrome
``` -->

# RecipeRadar

Flutter recipe app built for the App Developer internship (Week 3: Real Recipes from a Public API).

## Week 3 Features

- Fetched real recipes from TheMealDB public API using the `http` package.
- Parsed JSON into `Recipe` models with ingredients (`strIngredient1`–`strIngredient20`) using `FutureBuilder`.
- Added search submission, empty-state handling, error handling with a Retry button, recipe detail navigation, and favourites.

## Run Locally

flutter pub get
flutter run -d chrome
