import 'package:flutter/material.dart';

class RecipeCard extends StatefulWidget {
  final String recipeId;
  final String userName;
  final String avatarUrl;
  final String title;
  final String rating;
  final String cookTime;
  final String thumbnailUrl;

  const RecipeCard({
    super.key,
    required this.recipeId,
    required this.userName,
    required this.avatarUrl,
    required this.title,
    required this.cookTime,
    required this.rating,
    required this.thumbnailUrl,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.thumbnailUrl,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 20, // Adjust as needed
              right: 20, // Adjust as needed
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.avatarUrl),
              ),
            ),
            Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildInfoContainer(Icons.star, widget.rating),
                    _buildInfoContainer(Icons.schedule, widget.cookTime),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              widget.title,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked
                    ? Colors.deepPurple
                    : Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                setState(() {
                  isLiked = !isLiked;
                });
              },
            ),
          ]),
        ),
        
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Expanded(
            child: Text(
              'Quick Description',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoContainer(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(right: 10, left: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.yellow, size: 18),
          const SizedBox(width: 7),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
