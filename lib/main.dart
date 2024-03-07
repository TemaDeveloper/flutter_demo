import 'package:flutter/material.dart';
import 'package:flutter_application_1/bottom_bar/bar.dart';
import 'package:flutter_application_1/listModels/cocktail_card.dart';

import 'package:flutter_application_1/onboding/bording_screen.dart';

import 'package:flutter_application_1/listModels/recipe.dart';
import 'package:flutter_application_1/listModels/recipe.api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OnbodingScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  static const title = 'CookeryDays';

  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;
  List<Recipe>? _recipes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getRecipes();
  }

   Future<void> getRecipes() async {
    _recipes = await RecipeApi.getRecipe();
    setState(() {
      _isLoading = false;
      print(_recipes);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bodies = [
      _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _recipes!.length,
                itemBuilder: (context, index) {
                  return CocktailCard(
                      title: _recipes![index].title,
                      cookTime: _recipes![index].totalTime,
                      rating: _recipes![index].rating.toString(),
                      thumbnailUrl: _recipes![index].images);
                },
              ),
      const Center(child: Text('Likes')),
      const Center(child: Text('Search')),
      const Center(child: Text('Profile')),
    ];

    // Removed MaterialApp widget here
    return Scaffold(
      appBar: AppBar(
        title: const Text(HomePage.title),
      ),
      body: _currentIndex < bodies.length ? bodies[_currentIndex] : const Center(child: Text('Page not found')),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavBarItem(icon: const Icon(Icons.home),            title: const Text("Home"),    selectedColor: Colors.purple),
          BottomNavBarItem(icon: const Icon(Icons.favorite_border), title: const Text("Likes"),   selectedColor: Colors.pink),
          BottomNavBarItem(icon: const Icon(Icons.search),          title: const Text("Search"),  selectedColor: Colors.orange),
          BottomNavBarItem(icon: const Icon(Icons.person),          title: const Text("Profile"), selectedColor: Colors.teal),
        ],
      ),
    );
  }
}
