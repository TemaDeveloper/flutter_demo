import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/onboding/bording_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final textFieldFocusNode = FocusNode();
  final myController = TextEditingController();
  bool _obscured = true;

  void _changeObscure() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
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
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const OnbodingScreen()));
                      })),
            ),
            Center(
              child: Column(children: <Widget>[
                const Text('Welcome!',
                    style:
                        TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const Text('Create a new account to get a lot of recipes'),
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
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12)),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: 'Name')),
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
                              child: const Text('Signup',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {},
                            )))),
                const SizedBox(height: 20),
                const Text('or sign up with', style: TextStyle(fontSize: 16.0)),
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
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(
                              color: Colors.transparent), // if you need this
                        ),
                        child: const SizedBox(
                            width: double.infinity,
                            height: 70,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.facebook_rounded,
                                      size: 50, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Sign up with Facebook',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))
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
                        child: const SizedBox(
                            width: double.infinity,
                            height: 70,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.gamepad_rounded,
                                      size: 50, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Sign up with Google',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white))
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
                    const Text('Already have an account?'),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Log in!',
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