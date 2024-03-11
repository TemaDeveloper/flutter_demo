import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/login.dart';
import 'package:flutter_application_1/main.dart';
import 'package:rive/rive.dart';

import 'components/animated_btn.dart';
import 'package:flutter/cupertino.dart';

class OnbodingScreen extends StatefulWidget {
  const OnbodingScreen({super.key});

  @override
  State<OnbodingScreen> createState() => _OnbodingScreenState();
}

class _OnbodingScreenState extends State<OnbodingScreen> {
  late RiveAnimationController _btnAnimationController;

  bool isShowSignInDialog = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            left: 100,
            bottom: 100,
            child: Image.asset(
              "assets/Backgrounds/Spline.png",
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/RiveAssets/shapes.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          AnimatedPositioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 260),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    const SizedBox(
                      width: 260,
                      child: Column(
                        children: [
                          Text(
                            "CookeryDays",
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Create and find new recipes, they could be alcoholic and nonalcoholic cocktails. Moreover you can find here a plenty of meals and many more.",
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    Column(
                      children: [
                        AnimatedBtn(
                          btnAnimationController: _btnAnimationController,
                          title: 'Start',
                          press: () {
                            _btnAnimationController.isActive = true;
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );

                            Future.delayed(
                              const Duration(milliseconds: 800),
                              () {
                                setState(() {
                                  isShowSignInDialog = true;
                                });
                              },
                            );
                          },
                        ),
                        TextButton(
                          onPressed: () {

                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const HomePage()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Login as a guest',
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                          ),
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(""),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

