import 'dart:ui';

import 'package:flutter/material.dart';

class RecipeDetailPage extends StatefulWidget {
  final String imageUrl;
  final String title;
  final double rating;
  final String cookTime;
  final List<String> ingredients = ['Coke', 'Pizza', 'Bread'];

  RecipeDetailPage({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.cookTime,
  }) : super(key: key);

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetailPage> {
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
                      _iconWithText(Icons.star, 'Rating:\n${widget.rating}'),
                      _iconWithText(
                          Icons.schedule, 'Cook time:\n${widget.cookTime}'),
                      _iconWithText(Icons.kitchen,
                          'Products:\n${widget.ingredients.length.toString()}'),
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
                Container(
                  height: 100, // Adjust height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.ingredients.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 200, // Define a fixed width for each item
                        child: Card(
                          child: ListTile(
                            title: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(widget.ingredients[index]),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ),
    );
  }
}
