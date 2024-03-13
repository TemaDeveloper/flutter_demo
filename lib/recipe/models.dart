class Recipe {
  String id;
  /// True means our.id == creator.id
  bool isOwned;
  /*--------------------------*/
  String title;
  String description;
  List<Ingredient> ingredients;
  String? previewImgUrl;

  Recipe({
    required this.id,
    required this.isOwned,
    required this.title,
    required this.description,
    required this.ingredients,
    this.previewImgUrl,
  });
}

class Ingredient {
  String name;
  String? imgUrl;

  Ingredient({required this.name, this.imgUrl});
}
