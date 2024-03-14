import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/recipe/cuisine_types.dart';
import 'package:flutter_application_1/recipe/models.dart';

class RecipeProvider extends ChangeNotifier {
  RecipeProvider() {
    updateRecipeList(0);
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
    userGet(String id, String property) async => await pb
        .collection("users")
        .getFirstListItem('id="$id"')
        .then((r) => r.getStringValue(property))
        .catchError((e) => print("Getting $property of user $id"));

    final resp = await pb
        .collection("recipies")
        .getFullList()
        // .getList(page: curentPage, perPage: 10, sort: "...")
        .then((r) {
      return Future.wait(
        r.map((recipe) async {
          final creatorId = recipe.getDataValue("creator");
          final name = await userGet(creatorId, "name");
          final avatarName = await userGet(creatorId, "avatar");
          print("Recipe id: ${recipe.getDataValue("id")}");
          return Recipe(
            id: recipe.getDataValue("id"),
            creator: User(
              id: creatorId,
              username: await userGet(creatorId, "username"),
              email: await userGet(creatorId, "email"),
              name: name == "" ? null : name,
              avatarUrl: avatarName == ""
                  ? null
                  : avatarNameToUrl(creatorId, avatarName),
            ),
            title: recipe.getDataValue("title"),
            description: recipe.getDataValue("description"),
            previewImgUrl: recipe.getDataValue("preview") == ""
                ? null
                : recipe.getDataValue("preview"),
            ingredients: await Future.wait(
              recipe.getListValue("ingridients").map(
                (ingId) async {
                  final resp = await pb.collection("ingridients").getOne(ingId);
                  final url = resp.getDataValue("imgUrl");

                  return Ingredient(
                    name: resp.getDataValue("name"),
                    imgUrl: url == "" ? null : url,
                  );
                },
              ),
            ),
          );
        }),
      );
    });

    _recipes = resp;
    // print("Recipes: $_recipes");
  }
}
