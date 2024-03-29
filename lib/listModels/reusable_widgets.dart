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
  const ReusableCard(
      {super.key,
      required this.cardTitle,
      required this.assetPath,
      required this.cardColor,
      this.textColor = Colors.black});

  final String assetPath;
  final Color cardColor;
  final String cardTitle;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.transparent),
      ),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 70,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  textColor,
                  BlendMode.srcIn,
                ),
                child: Image.asset(assetPath, width: 30, height: 30),
              ),
              const SizedBox(width: 10),
              Text(
                cardTitle,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: textColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
