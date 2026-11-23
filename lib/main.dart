import 'package:flutter/material.dart';
import 'home_screen.dart';

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
      home: const HomeScreen(),
    );
  }
}
