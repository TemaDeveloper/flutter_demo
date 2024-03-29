import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';
import 'package:flutter_application_1/listModels/reusable_widgets.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class RecipeUpdate extends StatefulWidget {
  final String recipeId; // Assuming there's a unique identifier for recipes

  const RecipeUpdate({super.key, required this.recipeId});

  @override
  State<RecipeUpdate> createState() => _RecipeUpdateState();
}

class _RecipeUpdateState extends State<RecipeUpdate> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientController = TextEditingController();
  final List<String> _ingredients = [];
  final List<TextEditingController> _stepControllers = [];
  final int _maxWords = 20;
  int _wordCount = 0;
  String _descriptionText = '';

  @override
  void initState() {
    super.initState();
    _loadRecipeData();
    _descriptionController.addListener(_onTextChanged);
  }

  void _loadRecipeData() {
    // Load the recipe data for the given recipeId
    // This can include setting the text for _titleController, _descriptionController, etc.
    // and initializing the _ingredients and _stepControllers lists
  }

  void _addIngredient() {
    if (_ingredientController.text.isNotEmpty) {
      setState(() {
        _ingredients.add(_ingredientController.text);
        _ingredientController.clear();
      });
    }
  }

  void _deleteIngredient(String ingredient) {
    setState(() {
      _ingredients.remove(ingredient);
    });
  }

  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStep(int index) {
    setState(() {
      _stepControllers.removeAt(index);
    });
  }

  void _onTextChanged() {
    final text = _descriptionController.text;
    final words = text
        .split(RegExp(r'\s+'))
        .where((element) => element.isNotEmpty)
        .toList();

    if (words.length > _maxWords) {
      final truncated = words.sublist(0, _maxWords).join(' ');
      _descriptionController.value = TextEditingValue(
        text: truncated,
        selection: TextSelection.collapsed(offset: truncated.length),
      );
    }

  
    setState(() {
      _descriptionText = _descriptionController.text;
      _wordCount = words.length > _maxWords ? _maxWords : words.length;
    });
  }

  void _updateRecipe(BuildContext ctx) {
    final userProvider = Provider.of<UserProvider>(ctx, listen: false);
    // Update the recipe in the backend, potentially using usrPr.updateRecipe(...)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Provider.of<ThemeProvider>(context, listen: false)
              .themeData
              .colorScheme
              .onBackground, // Set the color of the AppBar icons
        ),
        title: const Text("Update Recipe"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20, 8, 10),
              child: GestureDetector(
                onTap: () {
                  // Implement image picking functionality
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.camera_alt,
                        size: 50,
                        color:
                            Provider.of<ThemeProvider>(context, listen: false)
                                .themeData
                                .colorScheme
                                .onBackground,
                      ),
                      const Text("Pick the Image for the recipe")
                    ],
                  ),
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Text('Common Info',
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold))),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    color: Provider.of<ThemeProvider>(context)
                        .themeData
                        .colorScheme
                        .onBackground,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: TextField(
                        controller: _titleController,
                        style: TextStyle(
                          color:
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .themeData
                                  .colorScheme
                                  .primary,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none,
                        )),
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Container(
                  decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context)
                          .themeData
                          .colorScheme
                          .onBackground,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: null,
                      style: TextStyle(
                        color:
                            Provider.of<ThemeProvider>(context, listen: false)
                                .themeData
                                .colorScheme
                                .primary,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Quick Description',
                        suffixText: '$_wordCount/$_maxWords',
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                )),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Ingredients',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 8, 8),
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                            color: Provider.of<ThemeProvider>(context)
                                .themeData
                                .colorScheme
                                .onBackground,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Center(
                            child: TextField(
                              style: TextStyle(
                                color: Provider.of<ThemeProvider>(context,
                                        listen: false)
                                    .themeData
                                    .colorScheme
                                    .primary,
                              ),
                              controller: _ingredientController,
                              decoration: const InputDecoration(
                                hintText: 'Ingredient',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      onPressed: _addIngredient,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 20),
                      ),
                      child: Icon(
                        Icons.add,
                        color:
                            Provider.of<ThemeProvider>(context, listen: false)
                                .themeData
                                .colorScheme
                                .onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _ingredients
                      .map((ingredient) => Chip(
                            label: Text(ingredient),
                            deleteIcon: Icon(
                              Icons.delete,
                              color: Provider.of<ThemeProvider>(context)
                                  .themeData
                                  .colorScheme
                                  .onBackground,
                            ),
                            onDeleted: () {
                              _deleteIngredient(ingredient);
                            },
                          ))
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Steps',
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: _addStep,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Add Step',
                          style: TextStyle(
                            color: Provider.of<ThemeProvider>(context,
                                    listen: false)
                                .themeData
                                .colorScheme
                                .onPrimary,
                          )),
                    ),
                  ),
                ],
              ),
            ),

            // Steps List
            for (int i = 0; i < _stepControllers.length; i++)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Step ${i + 1}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _removeStep(i),
                        ),
                      ],
                    ),
                    TextField(
                      controller: _stepControllers[i],
                      decoration: InputDecoration(
                        hoverColor:
                            Provider.of<ThemeProvider>(context, listen: false)
                                .themeData
                                .colorScheme
                                .onPrimary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ReusableButton(
          buttonText: 'Update Recipe',
          navigate: () {
            _updateRecipe(context);
          },
        )
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.removeListener(_onTextChanged);
    _descriptionController.dispose();
    _ingredientController.dispose();
    for (var controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
