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
            _buildProfileHeader(context, usrProvider), 
            _buildLoginOrRecipeCreationButton(context, usrProvider),
            _buildListOrPopupText(context, usrProvider, recipeProvider)
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProvider usrProvider) {
    return Column(
      children: [
        const AvatarWidget(),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(usrProvider.name ?? 'noName',
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        ),
        //User Email
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Text(usrProvider.email ?? 'NoEmail',
              style: const TextStyle(fontSize: 16)),
        )
      ],
    );
  }

  Widget _buildLoginOrRecipeCreationButton(
      BuildContext context, UserProvider usrProvider) {
    return Padding(
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
    );
  }

  Widget _buildListOrPopupText(BuildContext context, UserProvider usrProvider,
      RecipeProvider recipeProvider) {
    return !usrProvider.isAnon
        ? (recipeProvider.isLoading
            ? getPlatformSpecificLoading()
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
                                  title: r.title, image: r.previewImgUrl));
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
          );
  }

  
}
