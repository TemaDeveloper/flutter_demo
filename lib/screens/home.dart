import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';
import 'package:flutter_application_1/auth/login.dart';
import 'package:flutter_application_1/listModels/cuisine_card.dart';
import 'package:flutter_application_1/listModels/recipe_card.dart';
import 'package:flutter_application_1/listModels/spoonacular_recipe.api.dart';
import 'package:flutter_application_1/listModels/spoonacular_recipe.dart';
import 'package:flutter_application_1/recipe_detail.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/constants/constants.dart' as constants;
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> advices = constants.advices;
  List<CuisineCard>? cuisines;
  int selectedIdx = 0;

  bool _isLoading = true;
  List<SpoonacularRecipe>? _listRecipes;

  @override
  void initState() {
    super.initState();
    getRecipes('Italian');

    cuisines = [
      const CuisineCard(
          title: 'Italian', image: 'assets/images/img_italian.JPG'),
      const CuisineCard(
          title: 'American', image: 'assets/images/img_american.JPG'),
      const CuisineCard(
          title: 'European', image: 'assets/images/img_european.JPG'),
      const CuisineCard(
          title: 'Japanese', image: 'assets/images/img_japanese.JPG'),
      const CuisineCard(
          title: 'Chinese', image: 'assets/images/img_chinese.JPG'),
      const CuisineCard(title: 'Indian', image: 'assets/images/img_indian.JPG'),
      const CuisineCard(title: 'French', image: 'assets/images/img_french.JPG')
    ];
  }

  String getRandomAdvice() {
    var random = Random();
    if (advices.isNotEmpty) {
      int index = random.nextInt(advices.length);
      return advices[index];
    } else {
      return 'No advice available';
    }
  }

  Future<void> getRecipes(String cuisine) async {
    _listRecipes = await SpoonacularRecipeApi.getRecipeSpoon(cuisine);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usrProvider = Provider.of<UserProvider>(context);

    return CustomScrollView(
      slivers: <Widget>[
        // Sliver for horizontal list of cuisines

        SliverToBoxAdapter(
          child: SizedBox(
            height: 250,
            child: ListView.builder(
              itemCount: cuisines!.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            const TextSpan(
                              text: 'Welcome\nback,\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            if (usrProvider.name != null)
                              TextSpan(
                                text: usrProvider
                                    .name!, // The '!' is used for null check assertion
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  fontFamily: 'Poppins',
                                  color: Provider.of<ThemeProvider>(context,
                                          listen: false)
                                      .themeData
                                      .colorScheme
                                      .onPrimary,
                                ),
                              )
                            else
                              WidgetSpan(
                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()));
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets
                                            .zero, // Removes padding inside the button
                                        tapTargetSize: MaterialTapTargetSize
                                            .shrinkWrap, // Minimizes the touch target size
                                      ),
                                      child: const Text(
                                        "Login",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          fontFamily: 'Poppins',
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            const TextSpan(
                              text:
                                  '\n\nLook up for a bunch\nof different cuisines\nin CookeryDays',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                int adjustedIndex = index - 1;

                return GestureDetector(
                  onTap: () {
                    //Choosing a cuisine make a list
                    getRecipes(cuisines![adjustedIndex].title);
                    setState(() {
                      selectedIdx = adjustedIndex;
                    });
                  },
                  child: CuisineCard(
                    title: cuisines![adjustedIndex].title,
                    image: cuisines![adjustedIndex].image,
                    isSelected: selectedIdx == adjustedIndex,
                  ),
                );
              },
            ),
          ),
        ),
        // Sliver for recipe list
        SliverToBoxAdapter(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/ic_chef.png',
                            width: 60,
                            height: 60,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Text(
                            getRandomAdvice(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Text(
                    'With Love CookeryDays',
                    style: TextStyle(
                      color: Provider.of<ThemeProvider>(context, listen: false)
                          .themeData
                          .colorScheme
                          .onPrimary,
                      
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RecipeDetailPage(
                              recipeId: _listRecipes![index].recipeId,
                              imageUrl: _listRecipes![index].image,
                              title: _listRecipes![index].title,
                              rating: _listRecipes![index].rating,
                              cookTime: _listRecipes![index].totalTime,
                            ),
                          ),
                        );
                      },
                      child: RecipeCard(
                        recipeId: _listRecipes![index].recipeId,
                        userName: 'CookeryDays',
                        avatarUrl:
                            'https://www.creativefabrica.com/wp-content/uploads/2020/12/23/Chef-Hat-Flat-Icon-Bakery-Graphics-7312643-1-1-580x387.jpg',
                        title: _listRecipes![index].title,
                        cookTime: _listRecipes![index].totalTime,
                        rating: _listRecipes![index].rating.toString(),
                        thumbnailUrl: _listRecipes![index].image,
                      ),
                    );
            },
            childCount:
                (_isLoading || _listRecipes == null) ? 1 : _listRecipes!.length,
          ),
        ),
      ],
    );
  }
}
