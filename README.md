# RecipeRadar

A Flutter recipe discovery app built with Material 3. Search real recipes, open full cooking details, and save favourites that remain available offline.

## Features

- Search recipes by dish name through TheMealDB public API.
- Browse results in a responsive grid and open a detail screen with ingredients and instructions.
- Toggle favourites from cards or the detail screen with an instant heart update.
- Manage favourite state with `provider` (`ChangeNotifierProvider`, `context.watch`, `context.read`).
- Save favourites locally with `shared_preferences` as a JSON list, so they survive a full app restart.
- Render the Favourites tab directly from local storage, with no API call required when offline.
- Fetch complete recipe details by ID when online if a saved favourite has missing details.
- Light/dark Material 3 themes that follow the system setting.
- Image loading indicators and clean broken-image fallbacks on cards and detail screens.
- Custom RecipeRadar app icon configured for Android, iOS, macOS, Windows, and web.

## Screenshots

Replace these placeholders with captures from the finished build:

| Home | Recipe detail | Favourites |
| --- | --- | --- |
| `docs/screenshots/home.png` | `docs/screenshots/detail.png` | `docs/screenshots/favourites.png` |

## State and persistence

- `lib/favourites_provider.dart` owns the in-memory favourite list and notifies listeners after every change.
- Each saved recipe is serialised with `id`, `name`, `image`, `category`, `area`, `ingredients`, and `instructions`.
- `loadFavourites()` is called when the root app widget is created, before the UI needs to display saved recipes.
- `RecipeCard` and `RecipeDetailScreen` read the provider directly instead of receiving favourite flags or callbacks through constructors.

## Setup and run

Requirements: Flutter SDK 3.41 or newer (Dart 3.11+) and a supported Android/iOS/web toolchain.

```bash
flutter pub get
flutter run
flutter run -d chrome
```

Useful checks:

```bash
flutter analyze
flutter test
```

## Release builds

Android APK:

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

Android App Bundle (recommended for store upload):

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

Web:

```bash
flutter build web --release
```

Output: `build/web`

## API credit

Recipe data is provided by [TheMealDB](https://www.themealdb.com/api.php), a free public recipe API. RecipeRadar is not affiliated with TheMealDB.

## Submission checklist

1. Commit and push the Week 4 changes to the GitHub repository.
2. Create a GitHub release and attach the release APK/AAB (and hosted web build if required).
3. Publish a short LinkedIn post with the app summary, screenshot, and repository/release link.
4. Submit the public GitHub/dashboard link in the internship submission form.

Manual review is still required for the screenshot captures, GitHub push/release, LinkedIn post, and dashboard link submission.
