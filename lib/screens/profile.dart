import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_recipe.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';
import 'package:flutter_application_1/auth/login.dart';
import 'package:flutter_application_1/avatar.dart';
import 'package:flutter_application_1/listModels/my_card.dart';
import 'package:flutter_application_1/listModels/reusable_widgets.dart';
import 'package:flutter_application_1/recipe/provider.dart';
import 'package:flutter_application_1/recipe_update.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usrProvider = Provider.of<UserProvider>(context);
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return SingleChildScrollView(
      //profile screen
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            //Profile Image
            const AvatarWidget(),
            //User Name
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(usrProvider.name ?? 'noName',
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            //User Email
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text(usrProvider.email ?? 'NoEmail',
                  style: const TextStyle(fontSize: 16)),
            ),

            //Button Edit
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: ReusableButton(
                buttonText: usrProvider.isAnon ? 'Login' : 'Add Your Recipe',
                navigate: usrProvider.isAnon
                    ? () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const LoginPage()));
                      }
                    : () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const RecipeAdd()));
                      },
              ),
            ),

            !usrProvider.isAnon
                ? (recipeProvider.isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              height: 300,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                //Filter recipes by UID when user logged in
                                itemCount: recipeProvider.recipes.length,
                                // TODO: check if we created it
                                itemBuilder: (context, index) {
                                  final r = recipeProvider.recipes[index];
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => RecipeUpdate(
                                              recipeId: r.id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: MyCard(
                                          title: r.title,
                                          image: r.previewImgUrl));
                                },
                              ),
                            ),
                          ),
                        ],
                      ))
                : const Text(
                    'Login or Create a new Account to post your recipes and observing other\'s ones',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
      ),
    );
  }
}
