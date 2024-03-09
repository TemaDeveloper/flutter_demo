import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/listModels/spoonacular_recipe.dart';


class SpoonacularRecipeApi {
  static Future<List<SpoonacularRecipe>> getRecipeSpoon() async{
    var spoonacularUri = Uri.https('api.spoonacular.com', '/recipes/complexSearch', {
      "apiKey": "23ad611f1e2745e9925805b1ff79f2e8", 
      "addRecipeInformation": "true", 
      "number": "30", 
      "sort": "popularity", 
      "maxReadyTime": "20"
    });
    final spoonacularResponse = await http.get(spoonacularUri);
    Map spoonacularData = jsonDecode(spoonacularResponse.body);
    List _tempSpoonacular = [];

    for(var i in spoonacularData['results']){
      _tempSpoonacular.add(i);
    }
    return SpoonacularRecipe.recipesFromSnapshot(_tempSpoonacular);
  }
}
