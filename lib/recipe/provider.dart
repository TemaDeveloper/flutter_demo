import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/recipe/cuisine_types.dart';
import 'package:flutter_application_1/recipe/models.dart';

class RecipeProvider extends ChangeNotifier {
  RecipeProvider() {
    refreshRecipies();
  }

  CuisineTypes _selectedType = CuisineTypes.all;
  CuisineTypes get selectedType => _selectedType;
  set selectedType(CuisineTypes type) {
    _selectedType = type;
    _currentPage = 1; // Maybe change this behavior
    updateRecipeList(_currentPage);
  }

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  int _currentPage = 1;
  int get currentPage => _currentPage;
  set currentPage(int page) {
    _currentPage = page;
    updateRecipeList(_currentPage);
  }

  List<Recipe> _recipes = [];
  List<Recipe> get recipes => _recipes;

  updateRecipeList(int page) async {
    _currentPage = page;
    _isLoading = true;
    await refreshRecipies();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshRecipies() async {
    /*
  Response:   flutter: [{"id":"gijrn4k41fz5tdm","created":"2024-03-13 05:59:14.653Z","updated"
              :"2024-03-13 05:59:14.653Z","collectionId":"6v3drfijw7f02fy","collectionName":"r
              ecipies","expand":{},"creator":"someIdForSometh","description":"Chicken & noodle
              s","ingridients":["oke8do7l58l2l8l","93isr8ketu84ssv"],"preview":"","title":"Chi
              cken & noodles"}, {"id":"9snjkrvgiw9i9s4","created":"2024-03-13 05:59:43.924Z","
              updated":"2024-03-13 05:59:43.924Z","collectionId":"6v3drfijw7f02fy","collection
              Name":"recipies","expand":{},"creator":"someIdForSometh","description":"Salad","
              ingridients":["obv20z7upcpy5am","9h2dca13cvhbepp"],"preview":"","title":"Salad"}
              ]
    */
    final resp = await pb
        .collection("recipies")
        .getFullList()
        // .getList(page: curentPage, perPage: 10, sort: "...")
        .then(
          (r) => Future.wait(
            r.map(
              (recipe) async => Recipe(
                id: recipe.getDataValue("id"),
                isOwned: pb.authStore.isValid
                    ? recipe.getDataValue("creator") == pb.authStore.model.id
                    : false,
                title: recipe.getDataValue("title"),
                description: recipe.getDataValue("description"),
                previewImgUrl: recipe.getDataValue("preview") == ""
                    ? null
                    : recipe.getDataValue("preview"),
                ingredients: await Future.wait(
                  recipe.getListValue("ingridients").map(
                    (ingId) async {
                      final resp =
                          await pb.collection("ingridients").getOne(ingId);
                      final url = resp.getDataValue("imgUrl");

                      return Ingredient(
                        name: resp.getDataValue("name"),
                        imgUrl: url == "" ? null : url,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );

    _recipes = resp;
    print("Recipes: $_recipes");
  }
}
