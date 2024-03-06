import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/barDesign/BottomNavBar.dart';
import 'package:flutter_application_1/listModels/cocktail_card.dart';

import 'package:flutter_application_1/onboding/OnBodingScreen.dart';

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
      home: OnbodingScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static const title = 'CookeryDays';
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
            ? Center(child: CircularProgressIndicator())
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
      Center(child: Text('Likes')),
      Center(child: Text('Search')),
      Center(child: Text('Profile')),
    ];

    // Removed MaterialApp widget here
    return Scaffold(
      appBar: AppBar(
        title: Text(MyHomePage.title),
      ),
      body: _currentIndex < bodies.length ? bodies[_currentIndex] : Center(child: Text('Page not found')),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavBarItem(icon: Icon(Icons.home), title: Text("Home"), selectedColor: Colors.purple),
          BottomNavBarItem(icon: Icon(Icons.favorite_border), title: Text("Likes"), selectedColor: Colors.pink),
          BottomNavBarItem(icon: Icon(Icons.search), title: Text("Search"), selectedColor: Colors.orange),
          BottomNavBarItem(icon: Icon(Icons.person), title: Text("Profile"), selectedColor: Colors.teal),
        ],
      ),
    );
  }
}
