import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/avatar.dart';
import 'package:flutter_application_1/profile_update.dart';
import 'package:flutter_application_1/bottom_bar/bar.dart';
import 'package:flutter_application_1/listModels/cuisine_card.dart';
import 'package:flutter_application_1/listModels/recipe_card.dart';
import 'package:flutter_application_1/listModels/my_card.dart';

import 'package:flutter_application_1/onboding/bording_screen.dart';
import 'package:flutter_application_1/listModels/spoonacular_recipe.dart';
import 'package:flutter_application_1/listModels/spoonacular_recipe.api.dart';

import 'package:flutter_application_1/recipe_detail.dart';
import 'package:provider/provider.dart';

import 'auth/backend_proxy.dart';
import 'package:flutter_application_1/theme_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(isDarkMode: false),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      builder: (context, child) {
        return MaterialApp(
          theme: themeProvider.currentTheme,
          home: const OnbodingScreen(),
        );
      });
    
  
  }
}

class HomePage extends StatefulWidget {
  static const title = 'CookeryDays';

  const HomePage({super.key});
  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  var _currentIndex = 0;
  List<SpoonacularRecipe>? _listRecipes;
  bool _isLoading = true;
  late MyCard myCard1, myCard2, myCard3;
  late CuisineCard italianCard,
      americanCard,
      europeanCard,
      japaneseCard,
      chineseCard,
      indianCard,
      frenchCard;
  List<MyCard> myCards = [];
  List<CuisineCard> cuisines = [];
  int selectedIdx = 0;

  @override
  void initState() {
    super.initState();
    getRecipes('Italian');

    italianCard =
        CuisineCard(title: 'Italian', image: 'assets/images/img_italian.JPG');
    americanCard =
        CuisineCard(title: 'American', image: 'assets/images/img_american.JPG');
    europeanCard =
        CuisineCard(title: 'European', image: 'assets/images/img_european.JPG');
    japaneseCard =
        CuisineCard(title: 'Japanese', image: 'assets/images/img_japanese.JPG');
    chineseCard =
        CuisineCard(title: 'Chinese', image: 'assets/images/img_chinese.JPG');
    indianCard =
        CuisineCard(title: 'Indian', image: 'assets/images/img_indian.JPG');
    frenchCard =
        CuisineCard(title: 'French', image: 'assets/images/img_french.JPG');

    myCard1 = MyCard(
        title: 'title1',
        image:
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg');
    myCard2 = MyCard(
        title: 'title2',
        image:
            'https://i0.wp.com/picjumbo.com/wp-content/uploads/silhouette-of-an-olive-tree-after-beautiful-purple-sunset-free-photo.jpg?w=600&quality=80');
    myCard3 = MyCard(
        title: 'title3',
        image:
            'https://i0.wp.com/picjumbo.com/wp-content/uploads/silhouette-of-an-olive-tree-after-beautiful-purple-sunset-free-photo.jpg?w=600&quality=80');

    myCards = [myCard1, myCard2, myCard3];
    cuisines = [
      italianCard,
      americanCard,
      europeanCard,
      japaneseCard,
      chineseCard,
      indianCard,
      frenchCard
    ];
  }

  //getting recipes from API
  Future<void> getRecipes(String cuisine) async {
    _listRecipes = await SpoonacularRecipeApi.getRecipeSpoon(cuisine);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usrProvider = Provider.of<UserProvider>(context);

    //home screen
    final List<Widget> bodies = [
      CustomScrollView(
        slivers: <Widget>[
          // Sliver for horizontal list of cuisines

          SliverToBoxAdapter(
            child: SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: cuisines.length + 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'Welcome\nback,',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              if (usrProvider.name != null)
                                TextSpan(
                                  text:
                                      '\n${usrProvider.name!}\n', // The '!' is used for null check assertion
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    fontFamily: 'Poppins',
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              const TextSpan(
                                text:
                                    '\nLook up for a bunch\nof different cuisines\nin CookeryDays',
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
                      getRecipes(cuisines[adjustedIndex].title);
                      setState(() {
                        selectedIdx = adjustedIndex;
                      });
                    },
                    child: CuisineCard(
                      title: cuisines[adjustedIndex].title,
                      image: cuisines[adjustedIndex].image,
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
                  cuisines[selectedIdx].title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
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
              childCount: (_isLoading || _listRecipes == null)
                  ? 1
                  : _listRecipes!.length,
            ),
          ),
        ],
      ),
      const Center(
        child: Text('Likes'),
      ),
      const Center(
        child: Text('Search'),
      ),
      // TODO: make sure anon user is not allowed to access this page/or redirect to login/signup
      SingleChildScrollView(
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
                      //Go to AdditionRecipe page
                    },
                    child: Text('Add Your Recipe',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.deepPurple))),
              ),
            ),

              //Title 'My Cards'
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Text('My Recipes',
                    style: TextStyle(fontSize: 24),),
              ),

              //List of Created Recipes
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: myCards.length,
                    itemBuilder: (context, index) {
                      return MyCard(
                          title: myCards[index].title,
                          image: myCards[index].image);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    // profile screen
    if (_currentIndex == 3 && context.read<UserProvider>().isAnon) {
      /// TODO: TEMA ebi
      print("TEMA: explain to user that this is not how things are done!!!");
    }

    // Removed MaterialApp widget here

    return Scaffold(
      appBar: AppBar(
        title: const Text(HomePage.title),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog();
            },
          ),
        ],
      ),
      body: _currentIndex < bodies.length
          ? bodies[_currentIndex]
          : const Center(child: Text('Page not found')),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              selectedColor: Colors.purple),
          BottomNavBarItem(
              icon: const Icon(Icons.favorite_border),
              title: const Text("Likes"),
              selectedColor: Colors.pink),
          BottomNavBarItem(
              icon: const Icon(Icons.search),
              title: const Text("Search"),
              selectedColor: Colors.orange),
          BottomNavBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
              selectedColor: Colors.teal),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.update),
                  title: Text('Update Profile'),
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => UpdateProfile()));
                  },
                ),
                SwitchListTile(
                  title: Text('Dark Theme'),
                  secondary: Icon(
                      themeProvider.currentTheme == ThemeData.light()
                          ? Icons.wb_sunny
                          : Icons.nights_stay), // Sun or moon icon
                  value: themeProvider.currentTheme ==
                      ThemeData
                          .dark(), // Your condition to check if dark theme is enabled
                  onChanged: (bool value) {
                    themeProvider.toggleTheme();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Log Out'),
                  onTap: () {
                    // TODO: Implement log out action
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
