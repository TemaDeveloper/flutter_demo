import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/auth/signup.dart';
import 'package:flutter_application_1/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final textFieldFocusNode = FocusNode();
  final myController = TextEditingController();
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
                      })),
            ),
            Center(
              child: Column(children: <Widget>[
                const Text('Hello Again!', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
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
                            controller: myController,
                            decoration: const InputDecoration(
                                border: InputBorder.none, hintText: 'Email')),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
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
                                )),
                          ),
                          obscureText: _obscured,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      )),
                ),
                const SizedBox(height: 20),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                            width: double.infinity,
                            height: 64,
                            child: ElevatedButton(
                              
                              child: const Text('Login',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => HomePage()));
                              },
                            )))),
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
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.facebook_rounded,
                                      size: 50, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Log in with Facebook', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))
                                ],
                              ),
                            )),
                      ),
                      Card(
                         color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          // if you need this
                          side: const BorderSide(color: Colors.transparent),
                        ),
                        child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 70,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.gamepad_rounded,
                                      size: 50, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Log in with Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))
                                ],
                              ),
                            )),
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
                        child: const Text('Sign up!',
                            style: TextStyle(color: Colors.red)))
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
