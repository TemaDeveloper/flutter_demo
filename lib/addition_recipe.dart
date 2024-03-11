import 'package:flutter/material.dart';

class AdditionRecipe extends StatefulWidget {
  @override
  _AdditionRecipeState createState() => _AdditionRecipeState();
}

class _AdditionRecipeState extends State<AdditionRecipe> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientController = TextEditingController();
  List<String> _ingredients = [];
  List<TextEditingController> _stepControllers = [];

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
    _descriptionController.dispose();
    _ingredientController.dispose();
    _stepControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Addition Recipe")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 20, 8, 10),
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
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Quick Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  )),
            ),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Ingredients',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ingredientController,
                      decoration: InputDecoration(
                        hintText: 'Ingredient',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      onPressed: _addIngredient,
                      child: Icon(Icons.add),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _ingredients
                      .map((ingredient) => Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(ingredient,
                                    style: TextStyle(color: Colors.black)),
                                IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                  ),
                                  onPressed: () =>
                                      _deleteIngredient(ingredient),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
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
                      child: Text('Add Step'),
                    ),
                  ),
                ],
              ),
            ),

            // Steps List
            for (int i = 0; i < _stepControllers.length; i++)
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Step ${i + 1}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.clear),
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
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              // Implement submission functionality
            },
            child: Text('Submit'),
          ),
        ),
      ),
    );
  }
}
