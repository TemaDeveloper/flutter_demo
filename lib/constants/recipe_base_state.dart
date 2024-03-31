import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class RecipeBaseState<T extends StatefulWidget> extends State<T> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final ingredientController = TextEditingController();
  final List<String> ingredients = [];
  final List<TextEditingController> stepControllers = [];
  final maxWords = 20;
  int wordCount = 0;

  @override
  void initState() {
    super.initState();
    descriptionController.addListener(onTextChanged);
  }

  void onTextChanged() {
    final text = descriptionController.text;
    final words = text
        .split(RegExp(r'\s+'))
        .where((element) => element.isNotEmpty)
        .toList();
    if (words.length > maxWords) {
      final truncated = words.sublist(0, maxWords).join(' ');
      descriptionController.value = TextEditingValue(
        text: truncated,
        selection: TextSelection.collapsed(offset: truncated.length),
      );
    }
    setState(() {
      wordCount = words.length > maxWords ? maxWords : words.length;
    });
  }

  void addIngredient() {
    if (ingredientController.text.isNotEmpty) {
      setState(() {
        ingredients.add(ingredientController.text);
        ingredientController.clear();
      });
    }
  }

  void deleteIngredient(String ingredient) {
    setState(() {
      ingredients.remove(ingredient);
    });
  }

  void addStep() {
    setState(() {
      stepControllers.add(TextEditingController());
    });
  }

  void removeStep(int index) {
    setState(() {
      stepControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.removeListener(onTextChanged);
    descriptionController.dispose();
    ingredientController.dispose();
    stepControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}





