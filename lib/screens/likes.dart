import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';

import 'package:flutter_application_1/recipe/provider.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    if (recipeProvider.isLoading) {
      return const CircularProgressIndicator();
    }

    final recipies = recipeProvider.recipes
        .where((r) => userProvider.likes.contains(r.id))
        .toList();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3, // Adjust this for proper aspect ratio
      ),
      itemCount: recipies.length,
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
                          recipies[index].previewImgUrl ??
                              "Some url", // TODO: handle null case
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
                            child:
                                Icon(Icons.favorite, color: Colors.deepPurple),
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
                                          final id = recipies[index].id;
                                          userProvider.dislike(id);
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
                    recipies[index].title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
