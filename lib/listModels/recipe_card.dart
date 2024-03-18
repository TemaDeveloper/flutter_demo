import 'package:flutter/material.dart';

class RecipeCard extends StatefulWidget {
  final int recipeId;
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start of the cross axis
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.avatarUrl),
              ),
              title: Text(
                widget.userName,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.thumbnailUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
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
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Text(
              widget.title,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Quick Description',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      // Add your styling here
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.deepPurple : Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    setState(() {
                      isLiked = !isLiked;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoContainer(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(right: 10),
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
