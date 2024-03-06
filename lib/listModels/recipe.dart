class Recipe {
  final String title;
  final double rating;
  final String totalTime;
  final String images;

  Recipe({required this.title, required this.images, required this.rating, required this.totalTime});

  factory Recipe.fromJson(dynamic json) {
    return Recipe(
        title: json['name'] as String,
        images: json['images'][0]['hostedLargeUrl'] as String,
        rating: json['rating'] as double,
        totalTime: json['totalTime'] as String);
  }

  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Recipe {name: $title, image: $images, rating: $rating, totalTime: $totalTime}';
  }
}