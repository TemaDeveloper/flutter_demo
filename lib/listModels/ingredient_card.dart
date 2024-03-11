import 'package:flutter/material.dart';

class IngredientCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  IngredientCard({required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0, // Optional: adds shadow under the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment
            .stretch, // To stretch the image to fit the card's width
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(10)), // Rounded corners for the top of the image
            child: Image.network(
              imageUrl,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Icon(Icons.error);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.0, // Adjust font size as necessary
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
