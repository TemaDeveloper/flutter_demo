import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';
import 'package:flutter_application_1/auth/login.dart';
import 'package:flutter_application_1/listModels/reusable_widgets.dart';

import 'package:flutter_application_1/recipe/provider.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';

//TODO: figure out a way to update
class LikeScreen extends StatefulWidget {
  const LikeScreen({super.key});

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  Future<void> _refreshLikes() async {
    Provider.of<RecipeProvider>(context)
        .recipes
        .where((r) => Provider.of<UserProvider>(context).likes.contains(r.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    final recipies = userProvider.isAnon
        ? []
        : recipeProvider.recipes
            .where((r) => userProvider.likes.contains(r.id))
            .toList();

    if (recipeProvider.isLoading) {
      return getPlatformSpecificLoading();
    }

    return !userProvider.isAnon
        ? (RefreshIndicator(
            onRefresh: _refreshLikes,
            child: GridView.builder(
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
                                      "https://via.placeholder.com/150",
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
                                    child: Icon(Icons.favorite,
                                        color: Colors.deepPurple),
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
                                              child: Text('No',
                                                  style: TextStyle(
                                                    color: Provider.of<
                                                                ThemeProvider>(
                                                            context,
                                                            listen: false)
                                                        .themeData
                                                        .colorScheme
                                                        .onPrimary,
                                                  )),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                'Yes',
                                                style: TextStyle(
                                                  color: Provider.of<
                                                              ThemeProvider>(
                                                          context,
                                                          listen: false)
                                                      .themeData
                                                      .colorScheme
                                                      .onPrimary,
                                                ),
                                              ),
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
            )))
        : Center(
            child: (Container(
              width: double.infinity,
              height: 200,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.login_rounded,
                    size: 50,
                    color: Provider.of<ThemeProvider>(context)
                        .themeData
                        .colorScheme
                        .onBackground,
                  ),
                  const Padding(
                      padding: EdgeInsets.fromLTRB(8, 20, 8, 0),
                      child: Text(
                          "Login to your account to save your favourite recipes")),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              (context),
                              CupertinoPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            color: Provider.of<ThemeProvider>(context,
                                    listen: false)
                                .themeData
                                .colorScheme
                                .onPrimary,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          );
  }
}
