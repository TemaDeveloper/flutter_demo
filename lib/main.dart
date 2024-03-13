import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/login.dart';
import 'package:flutter_application_1/profile_update.dart';
import 'package:flutter_application_1/bottom_bar/bar.dart';
import 'package:flutter_application_1/onboding/bording_screen.dart';
import 'package:flutter_application_1/red_popup.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/likes.dart';
import 'package:flutter_application_1/screens/profile.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'auth/backend_proxy.dart';
import 'package:flutter_application_1/theme_provider.dart';

const String backendBaseUrl = kDebugMode ? 'http://127.0.0.1:8090' : 'TODO';
late PocketBase pb;

void main() {
  pb = PocketBase(backendBaseUrl);
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(isDarkMode: false),
    child: const MyApp(),
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
          ChangeNotifierProvider(create: (ctx) => UserProvider()),
          // ChangeNotifierProvider(create: (ctx) => RecipeProvider()),
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

enum Screens {
  home,
  likes,
  search,
  profile,
}

class _MyHomePageState extends State<HomePage> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final usrProvider = Provider.of<UserProvider>(context);
    // final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    // print(recipeProvider.selectedType);

    final List<Widget> bodies = [
      const HomeScreen(),
      const Center(
        child: Text("Search"),
      ),
      const LikeScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(HomePage.title),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
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
        onTap: (i) => setState(() {
          if (i == Screens.profile.index && usrProvider.isAnon) {
            final err = ErrorPopup(text: "You must be logged in to view your profile", duration: Durations.extralong4);
            err.show(context);
            return;
          }
          _currentIndex = i;
        }),
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
        final usrProvider = Provider.of<UserProvider>(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              children: <Widget>[
                usrProvider.isAnon
                    ? ListTile(
                        leading: const Icon(
                            Icons.person_add), // TODO: Tema find suitable icon
                        title: const Text('Login or Create Account'),
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                      )
                    : ListTile(
                        leading: const Icon(Icons.update),
                        title: const Text('Update Profile'),
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const UpdateProfile(),
                            ),
                          );
                        },
                      ),
                SwitchListTile(
                  title: const Text('Dark Theme'),
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
                usrProvider.isAnon
                    ? const SizedBox.shrink() 
                  : ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('Log Out'),
                  onTap: () {
                    usrProvider.logout();
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const OnbodingScreen(),
                      ),
                    );
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
