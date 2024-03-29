import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/auth/varification.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/listModels/reusable_widgets.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final textFieldFocusNode = FocusNode();
  final myController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();
  bool _obscured = true;

  void _changeObscure() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 24.0,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Center(
              child: Column(children: <Widget>[
                const Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
                const Text('Create a new account to get a lot of recipes'),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ReusableTextField(
                      controller: emailController, hint: 'Email'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ReusableTextField(
                      controller: nameController, hint: 'Name'),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context)
                          .themeData
                          .colorScheme
                          .onBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          style: TextStyle(
                            color: Provider.of<ThemeProvider>(context,
                                    listen: false)
                                .themeData
                                .colorScheme
                                .primary,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Password',
                            suffixIcon: GestureDetector(
                              onTap: _changeObscure,
                              child: Icon(
                                _obscured
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                size: 24,
                                color: Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .themeData
                                    .colorScheme
                                    .primary,
                              ),
                            ),
                          ),
                          obscureText: _obscured,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ReusableButton(
                        buttonText: 'Sign Up',
                        navigate: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => VerifyEmailScreen(),
                            ),
                          );
                        },
                      )),
                ),
                const SizedBox(height: 20),
                const Text(
                  'or sign up with',
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ReusableCard(
                        cardTitle: "Facebook",
                        assetPath: 'assets/images/img_facebook.png',
                        cardColor: Colors.blue,
                        textColor: Colors.white,
                      ),
                      ReusableCard(
                          cardTitle: "Google",
                          assetPath: 'assets/images/img_google.png',
                          cardColor: Colors.white)
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Log in!',
                        style: TextStyle(
                          color:
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .themeData
                                  .colorScheme
                                  .onPrimary,
                        ),
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
