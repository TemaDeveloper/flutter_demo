import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/auth/login.dart';
import 'package:flutter_application_1/bottom_bar/bar.dart';
import 'package:flutter_application_1/listModels/recipe_card.dart';
import 'package:flutter_application_1/listModels/my_card.dart';

import 'package:flutter_application_1/onboding/bording_screen.dart';

import 'package:flutter_application_1/listModels/recipe.dart';
import 'package:flutter_application_1/listModels/recipe.api.dart';
import 'package:flutter_application_1/recipe_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: OnbodingScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  static const title = 'CookeryDays';
  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  var _currentIndex = 0;
  List<Recipe>? _recipes;
  bool _isLoading = true;
  late MyCard myCard1, myCard2, myCard3;
  List<MyCard> myCards = [];

  @override
  void initState() {
    super.initState();
    getRecipes();
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
  }

  //getting recipes from API
  Future<void> getRecipes() async {
    _recipes = await RecipeApi.getRecipe();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //home screen
    final List<Widget> bodies = [
      _isLoading
          ? const Center(
              child: CircularProgressIndicator()) //progress bar loading
          : ListView.builder(
              //if success fetch data
              itemCount: _recipes!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => RecipeDetailPage(
                    imageUrl:  _recipes![index].images,
                    title: _recipes![index].title, 
                    rating: _recipes![index].rating, 
                    cookTime: _recipes![index].totalTime,)));
                  },
                  child: RecipeCard(
                    title: _recipes![index].title,
                    cookTime: _recipes![index].totalTime,
                    rating: _recipes![index].rating.toString(),
                    thumbnailUrl: _recipes![index].images));
              },
            ),
      Center(child: Text('Likes')),
      Center(child: Text('Search')),
      SingleChildScrollView(
          //profile screen
          child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            //Profile Image

            const CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(''),
              backgroundColor: Colors.amber,
            ),

            //User Name
            Padding(
              padding: EdgeInsets.all(10),
              child: Text('Name',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            //User Email
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text('Email',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            ),

            //Button Edit
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Container(
                width: 200,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => LoginPage()));
                    },
                    child: Text('Update Profile',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.deepPurple))),
              ),
            ),

            //Title 'My Cards'
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: const Text('My Recipes',
                  style: TextStyle(fontSize: 24, color: Colors.black)),
            ),

            //List of Created Recipes
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                height: 300,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: myCards.length,
                    itemBuilder: (context, index) {
                      return MyCard(
                          title: myCards[index].title,
                          image: myCards[index].image);
                    }),
              ),
            ),
          ],
        ),
      )),
    ];

    // Removed MaterialApp widget here
    return Scaffold(
      appBar: AppBar(
        title: const Text(HomePage.title),
        automaticallyImplyLeading: false,
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
}
