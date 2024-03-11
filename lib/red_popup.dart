import 'package:flutter/material.dart';

class ErrorPopup {
  final String text;
  final Duration duration;
  final Color color;
  final Color textColor;

  ErrorPopup({
    required this.text,
    required this.duration,
    this.color = Colors.red,
    this.textColor = Colors.white,
  });

  void show(BuildContext context) {
    final snackBar = SnackBar(
      content: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: Text(text, style: TextStyle(color: textColor)),
      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
