import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/add_recipe.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';
import 'package:flutter_application_1/avatar.dart';
import 'package:flutter_application_1/listModels/recipe_card.dart';
import 'package:flutter_application_1/recipe/provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usrProvider = Provider.of<UserProvider>(context);

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
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => RecipeAdd()));
                  },
                  child: const Text(
                    'Add Your Recipe',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.deepPurple),
                  ),
                ),
              ),
            ),

            //Title 'My Cards'
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text(
                'My Recipes',
                style: TextStyle(fontSize: 24),
              ),
            ),

            //List of Created Recipes
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: usrProvider.myCards.length,
                  itemBuilder: (context, index) {
                    final recipeProvider = Provider.of<RecipeProvider>(context);
                    final usrPrvdr = Provider.of<UserProvider>(context, listen: false);
                    final r = recipeProvider.recipes[0];
                    print(recipeProvider.recipes.length);
                    print("Printing 1st recipe");
                    print(r.id);
                    print(r.title);
                    print(r.description);
                    print(r.creator == usrPrvdr.id);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
