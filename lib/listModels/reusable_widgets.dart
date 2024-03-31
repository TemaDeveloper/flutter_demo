import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';

class ReusableTextField extends StatelessWidget {
  const ReusableTextField({
    super.key,
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Provider.of<ThemeProvider>(context)
              .themeData
              .colorScheme
              .onBackground,
          borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: controller,
            style: TextStyle(
              color: Provider.of<ThemeProvider>(context, listen: false)
                  .themeData
                  .colorScheme
                  .primary,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
            ),
          ),
        ),
      ),
    );
  }
}

class ReusableButton extends StatelessWidget {
  const ReusableButton({
    super.key,
    required this.buttonText,
    required this.navigate,
  });

  final Function navigate;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 16,
              color: Provider.of<ThemeProvider>(context, listen: false)
                  .themeData
                  .colorScheme
                  .onPrimary,
              fontWeight: FontWeight.normal),
        ),
        onPressed: () {
          navigate();
        },
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    super.key,
    required this.assetPath,
    required this.cardColor,
  });

  final String assetPath;
  final Color cardColor;

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: 48,
      height: 48,
      decoration: ShapeDecoration(
        shape: const CircleBorder(),
        color: cardColor,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          //Do smth
        },
        child: Image.asset(assetPath),
      ),
    );
  }
}

Widget getPlatformSpecificLoading() {
  if (Platform.isIOS) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: const CupertinoActivityIndicator(),
    );
  } else {
    return const CircularProgressIndicator();
  }
}


