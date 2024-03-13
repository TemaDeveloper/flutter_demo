import 'package:flutter/material.dart';
import 'dart:math';

class Recipe {
  final String title;
  final String imageUrl;

  Recipe({required this.title, required this.imageUrl});
}

class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  Random random = Random();

  
  List<Recipe>? recipes;
  

 

  @override
  void initState() {
    super.initState();
    recipes = [
    Recipe(
        title: 'Recipe 1',
        imageUrl:
            'https://hips.hearstapps.com/hmg-prod/images/goulash-vertical-64de8d216ea51.jpg'),
    Recipe(
        title: 'Recipe 2',
        imageUrl:
            'https://hips.hearstapps.com/hmg-prod/images/goulash-vertical-64de8d216ea51.jpg'),
    Recipe(
        title: 'Recipe 3',
        imageUrl:
            'https://hips.hearstapps.com/hmg-prod/images/goulash-vertical-64de8d216ea51.jpg'),
    Recipe(
        title: 'Recipe 4',
        imageUrl:
            'https://hips.hearstapps.com/hmg-prod/images/goulash-vertical-64de8d216ea51.jpg'),
  ];
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3, // Adjust this for proper aspect ratio
      ),
      itemCount: recipes!.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            //Go to RecipeDetails Screen
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          recipes![index].imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20, 
                            child: Icon(Icons.favorite, color: Colors.deepPurple),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Remove Recipe'),
                                  content: const Text(
                                      'Are you sure that you want to remove this recipe from loved ones?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('No'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        setState(() {
                                          recipes!.removeAt(index);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    recipes![index].title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )));
      },
    );
  }
}
