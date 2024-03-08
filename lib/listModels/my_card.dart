import 'package:flutter/material.dart';
import 'dart:ui';

class MyCard extends StatelessWidget{
  final String title;
  final String image;

  MyCard({
    required this.title,
    required this.image
  });

  @override
  Widget build(BuildContext context){
     return Container(
      width: 200, // fixed width for horizontal scrolling
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // rounded corners
        ),
        elevation: 5,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                image,
                width: double.infinity, // width of the container
                height: double.infinity, // make image fill the container
                fit: BoxFit.cover,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.3), // Semi-transparent overlay
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}