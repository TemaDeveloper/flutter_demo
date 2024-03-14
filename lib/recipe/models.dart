class Recipe {
  String id;
  User creator;
  /// True means our.id == creator.id
  /*--------------------------*/
  String title;
  String description;
  List<Ingredient> ingredients;
  String? previewImgUrl;

  Recipe({
    required this.id,
    required this.creator,
    required this.title,
    required this.description,
    required this.ingredients,
    this.previewImgUrl,
  });
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
  String name;
  String? imgUrl;

  Ingredient({required this.name, this.imgUrl});
}
