import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';
import 'package:flutter_application_1/auth/signup.dart';
import 'package:flutter_application_1/main.dart';
import 'package:provider/provider.dart';

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
  final textFieldFocusNode = FocusNode();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool _obscured = true;
  LoginStatus _loginStatus = LoginStatus.none;

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

  void tryLoginEmailPass(BuildContext context) {
    setState(() {
      _loginStatus = LoginStatus.waiting;
    });

    final usrProvider = context.read<UserProvider>();
    authEmailPass(emailController.text, passController.text, usrProvider).then((resp) {
      setState(() {
        if (resp.isLogged) {
          if (resp.needsVerification) {
            _loginStatus = LoginStatus.requiresVerification;
          } else {
            _loginStatus = LoginStatus.success;
          }
        }
      });
    }).catchError((e) {
      // TODO: handle each error case apropiately
      print("Login error: $e");
      setState(() => _loginStatus = LoginStatus.error);
    });
  }

  @override
  Widget build(BuildContext context) {
    // flutter does not want us to push the Navigator in the build function
    //(callbacks do not count, since they are not triggered during build(render) phase)
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
      backgroundColor: Colors.white,
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
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 24.0, color: Colors.black),
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
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: passController,
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
                              ),
                            ),
                          ),
                          obscureText: _obscured,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => tryLoginEmailPass(context),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('or login with', style: TextStyle(fontSize: 16.0)),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Card(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20), // if you need this
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 70,
                            child: const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.facebook_rounded,
                                      size: 40, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text(
                                    'Facebook',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            // if you need this
                            side: const BorderSide(color: Colors.transparent),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 70,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset('assets/images/img_google.png',
                                      width: 30, height: 30),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Google',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
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
                        child: const Text(
                          'Sign up!',
                          style: TextStyle(
                              color: Colors.deepPurple,
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

class SecondRout extends StatelessWidget {
  final String emailHolder;
  const SecondRout({super.key, required this.emailHolder});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('The Verification Came to you email, $emailHolder !'),
      ),
      child: Center(
        child: CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Go Back!"),
        ),
      ),
    );
  }
}
