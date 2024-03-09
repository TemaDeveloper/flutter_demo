class SpoonacularRecipe {
  final String title;
  final double rating;
  final String totalTime;
  final String image;
  final int recipeId;

  SpoonacularRecipe(
      {required this.recipeId,
      required this.title,
      required this.image,
      required this.rating,
      required this.totalTime});

  factory SpoonacularRecipe.fromJson(dynamic json) {
    return SpoonacularRecipe(
        recipeId: json['id'],
        title: json['title'] as String, // Adjusted to Spoonacular's field name
        image: json['image'] as String, // Adjusted to Spoonacular's field name
        rating:
            ((json['spoonacularScore'] as num).toDouble()*10).roundToDouble(), // Example conversion
        totalTime: json['readyInMinutes']
            .toString()); // Assuming 'readyInMinutes' is an integer
  }

  static List<SpoonacularRecipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return SpoonacularRecipe.fromJson(data);
    }).toList();
  }

  @override
  String toString() {
    return 'Recipe {recipeId: $recipeId, name: $title, image: $image, rating: $rating, totalTime: $totalTime}';
  }
}
