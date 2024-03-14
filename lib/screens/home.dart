import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';
import 'package:flutter_application_1/auth/login.dart';
import 'package:flutter_application_1/listModels/cuisine_card.dart';
import 'package:flutter_application_1/listModels/recipe_card.dart';
import 'package:flutter_application_1/listModels/spoonacular_recipe.api.dart';
import 'package:flutter_application_1/listModels/spoonacular_recipe.dart';
import 'package:flutter_application_1/recipe_detail.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SpoonacularRecipe>? _listRecipes;
  List<CuisineCard>? cuisines;
  int selectedIdx = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getRecipes('Italian');

    // TOOD: Am I missing something here?
    // late CuisineCard italianCard,
    //     americanCard,
    //     europeanCard,
    //     japaneseCard,
    //     chineseCard,
    //     indianCard,
    //     frenchCard;

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
                  return SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: 'Welcome\nback,\n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            if (usrProvider.name != null)
                              TextSpan(
                                text:
                                    '${usrProvider.name!}', // The '!' is used for null check assertion
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  fontFamily: 'Poppins',
                                  color: Colors.deepPurple,
                                ),
                              )
                            else
                              WidgetSpan(
                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, CupertinoPageRoute(builder: (context) => LoginPage()));
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
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                cuisines![selectedIdx].title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
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
