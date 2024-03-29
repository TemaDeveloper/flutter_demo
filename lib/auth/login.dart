import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';
import 'package:flutter_application_1/auth/signup.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/listModels/reusable_widgets.dart';

enum LoginStatus {
  none, // find good name for starting state
  waiting,
  success,
  requiresVerification,
  error,
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final textFieldFocusNode = FocusNode();

  LoginStatus _loginStatus = LoginStatus.none;
  bool _obscured = true;

  void tryLoginEmailPass(BuildContext context) {
    setState(() {
      _loginStatus = LoginStatus.waiting;
    });

    final usrProvider = context.read<UserProvider>();
    usrProvider
        .loginEmailPass(emailController.text, passController.text)
        .then((resp) {
      setState(() {
        switch (resp) {
          case AuthResponse.sucsess:
            _loginStatus = LoginStatus.success;
            break;
          case AuthResponse.needsVerification:
            _loginStatus = LoginStatus.requiresVerification;
            break;
          case AuthResponse.incorrectPassOrEmail:
            _loginStatus = LoginStatus.error;
            break;
          case AuthResponse.otherError:
            _loginStatus = LoginStatus.error;
            break;
        }
      });
    }).catchError((e) {
      // TODO: handle each error case apropiately
      print("Login error: $e");
      setState(() => _loginStatus = LoginStatus.error);
    });
  }

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
   
    if (_loginStatus == LoginStatus.success) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
      );
    }
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
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 24.0,
                    color: Provider.of<ThemeProvider>(context)
                        .themeData
                        .colorScheme
                        .onBackground,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Center(
              child: Column(
                children: <Widget>[
                  const Text('Hello Again!',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins")),
                  const Text('Welcome back, we missed you tones'),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: ReusableTextField(
                        controller: emailController, hint: 'Email'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            controller: passController,
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
                        buttonText: 'Login',
                        navigate: () {
                          tryLoginEmailPass(context);
                        }
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('or login with', style: TextStyle(fontSize: 16.0)),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ReusableCard(
                            cardTitle: 'Facebook',
                            assetPath: 'assets/images/img_facebook.png',
                            cardColor: Colors.blue,
                            textColor: Colors.white,),
                        ReusableCard(
                            cardTitle: 'Google',
                            assetPath: 'assets/images/img_google.png',
                            cardColor: Colors.white,
                            textColor: Colors.black,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text('Doesn`t have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const SignUpPage()));
                        },
                        child: Text(
                          'Sign up!',
                          style: TextStyle(
                              color: Provider.of<ThemeProvider>(context,
                                      listen: false)
                                  .themeData
                                  .colorScheme
                                  .onPrimary,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

