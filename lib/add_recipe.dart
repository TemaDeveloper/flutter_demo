import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';
import 'package:provider/provider.dart';

class RecipeAdd extends StatefulWidget {
  const RecipeAdd({super.key});
  // RecipeAdd({super.key}) {
  //   throw UnimplementedError("Well, just fetching for now");
  // }

  @override
  State<RecipeAdd> createState() => _RecipeAddState();
}

class _RecipeAddState extends State<RecipeAdd> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientController = TextEditingController();

  final int _maxWords = 20;
  int _wordCount = 0;
  String _descriptionText = '';

  final List<String> _ingredients = [];
  final List<TextEditingController> _stepControllers = [];

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _descriptionController.text;
    final words = text
        .split(RegExp(r'\s+'))
        .where((element) => element.isNotEmpty)
        .toList();

    if (words.length > _maxWords) {
      // Truncate the words to the max limit and update the text
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

  void _addRecipe(BuildContext ctx) {
    final usrPr = Provider.of<UserProvider>(ctx, listen: false);


    usrPr.addRecipie(
      title: _titleController.text,
      description: _descriptionController.text,
      ingredients: _ingredients.map( (ing) => IngredientInfo(name: ing) ).toList(),
      steps: _stepControllers.map( (step) => CookingStepInfo(text: step.text) ).toList()
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Addition Recipe")),
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.camera_alt, size: 50),
                      Text("Pick the Image for the recipe")
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
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none,
                        )),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: null,
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
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _ingredientController,
                          decoration: const InputDecoration(
                            hintText: 'Ingredient',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  )),
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
                      child: const Icon(Icons.add),
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
                      child: const Text('Add Step'),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Enter Step ${i + 1} details',
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
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () => _addRecipe(context),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Submit'),
          ),
        ),
      ),
    );
  }
}
