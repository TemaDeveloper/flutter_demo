class Recipe {
  String id;
  User creator;

  /*--------------------------*/
  String title;
  String description;
  List<Ingredient> ingredients;
  List<CookingStep> steps;
  String? previewImgUrl;

  Recipe({
    required this.id,
    required this.creator,
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    this.previewImgUrl,
  });

  void prettyPrint() {
    print("Recipe: $title");
    print("Description: $description");
    print("Ingredients:");
    for (var i in ingredients) {
      print("  - ${i.name}");
    }
    print("Steps:");
    for (var s in steps) {
      print("  - ${s.text}");
    }
  }
}

/// Not to be confused with UserProvider
/// This is a representation of any user
class User {
  final String id;
  final String email;
  final String username;
  final String? name; /* e.g. Ivan Ivanov */
  final String? avatarUrl;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.name,
    this.avatarUrl,
  });
}

class Ingredient {
  String id;
  String name;
  String? imgUrl;

  Ingredient({required this.id, required this.name, this.imgUrl});
}

class CookingStep {
  String id;
  String text;

  CookingStep({required this.id, required this.text});
}
