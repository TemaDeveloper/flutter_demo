import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/login.dart';
import 'package:flutter_application_1/profile_update.dart';
import 'package:flutter_application_1/bottom_bar/bar.dart';
import 'package:flutter_application_1/onboding/bording_screen.dart';
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/likes.dart';
import 'package:flutter_application_1/screens/profile.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';
import 'auth/backend_proxy.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'recipe/provider.dart';
import 'package:flutter/services.dart';

const String backendBaseUrl = kDebugMode ? 'http://127.0.0.1:8090' : 'TODO';
late PocketBase pb;

void main() {
  pb = PocketBase(backendBaseUrl);
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure the plugin services are initialized
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(catppuccin.mocha),
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => UserProvider()),
          ChangeNotifierProvider(create: (ctx) => RecipeProvider()),
        ],
        builder: (context, child) {
          return MaterialApp(
            theme: Provider.of<ThemeProvider>(context).themeData,
            home: const OnbodingScreen(),
          );
        });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const title = 'CookeryDays';

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
                          Icons.person_add,
                        ), // TODO: Tema find suitable icon
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
                      themeProvider.currentFlavor == catppuccin.latte
                          ? Icons.wb_sunny
                          : Icons.nights_stay),
                  value: themeProvider.currentFlavor == catppuccin.mocha,
                  onChanged: (bool value) {
                    // If value is true, set to dark theme, otherwise set to light theme
                    themeProvider
                        .setFlavor(value ? catppuccin.mocha : catppuccin.latte);
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> bodies = [
      const HomeScreen(),
      const LikeScreen(),
      const Center(
        child: Text("Search"),
      ),
      const ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(HomePage.title),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings,
                  color: Provider.of<ThemeProvider>(context, listen: false)
                      .themeData
                      .colorScheme
                      .onBackground),
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
            _currentIndex = i;
          }),
          items: [
            BottomNavBarItem(
                icon: const Icon(Icons.home),
                title: const Text("Home"),
                unselectedColor: Provider.of<ThemeProvider>(context)
                    .themeData
                    .colorScheme
                    .onBackground,
                selectedColor: Provider.of<ThemeProvider>(context)
                    .themeData
                    .colorScheme
                    .onPrimary),
            BottomNavBarItem(
                icon: const Icon(Icons.favorite_border),
                title: const Text("Likes"),
                unselectedColor: Provider.of<ThemeProvider>(context)
                    .themeData
                    .colorScheme
                    .onBackground,
                selectedColor: Colors.pink),
            BottomNavBarItem(
                icon: const Icon(Icons.search),
                title: const Text("Search"),
                unselectedColor: Provider.of<ThemeProvider>(context)
                    .themeData
                    .colorScheme
                    .onBackground,
                selectedColor: Colors.orange),
            BottomNavBarItem(
                icon: const Icon(Icons.person),
                title: const Text("Profile"),
                unselectedColor: Provider.of<ThemeProvider>(context)
                    .themeData
                    .colorScheme
                    .onBackground,
                selectedColor: Colors.teal),
          ],
        ),
      ),
    );
  }
}
