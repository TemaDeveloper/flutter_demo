import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecipeDetailPage extends StatefulWidget {
  final int recipeId;
  final String imageUrl;
  final String title;
  final double rating;
  final String cookTime;

  RecipeDetailPage({
    Key? key,
    required this.recipeId,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.cookTime,
  }) : super(key: key);

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetailPage> {
  List<String>? _ingredients;
  bool _isLoading = true;
  late int id;

  @override
  void initState() {
    super.initState();
    id = widget.recipeId;
    _fetchIngredients();
  }

  Future<void> _fetchIngredients() async {
    var url = Uri.https(
        'api.spoonacular.com', '/recipes/${widget.recipeId}/information', {
      'apiKey':
          '23ad611f1e2745e9925805b1ff79f2e8', // Replace with your Spoonacular API Key
    });

    try {
      final response = await http.get(url);
      final jsonResponse = json.decode(response.body);
      final ingredientsList = jsonResponse['extendedIngredients'] as List;
      setState(() {
        _ingredients = ingredientsList
            .map((ingredient) => ingredient['name'] as String)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      // Handle the exception
    }
  }

  // Future<void> getIngredients() async {
  //   try {
  //     _ingredients = await SpoonacularRecipeApi.getRecipeInfo(id);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   } catch (e) {
  //     // Handle the error
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Stack(children: [
                  //Background Image
                  Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                  ),
                  //Blured
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withOpacity(0),
                      ),
                    ),
                  ),
                  //Foreground Image
                  Positioned.fill(
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget.imageUrl,
                          width: 300,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _iconWithText(Icons.star, 'Quality:\n${widget.rating}'),
                      _iconWithText(
                          Icons.schedule, 'Cook time:\n${widget.cookTime}'),
                      _iconWithText(Icons.kitchen,
                          'Products:\n${_ingredients!.length.toString()}'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                _isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator()) //progress bar loading
                    : Container(
                        height: 100, // Adjust height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _ingredients!.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      _ingredients![index],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                            );
                          },
                        ),
                      ),
                      Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Steps',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Save recipe logic
                  },
                  child: const Text(
                    'Save Recipe',
                    style: TextStyle(color: Colors.deepPurple),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconWithText(IconData icon, String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Colors.yellow[600],
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
