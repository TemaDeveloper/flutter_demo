import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

abstract class RecipeBaseState<T extends StatefulWidget> extends State<T> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final ingredientController = TextEditingController();
  final List<String> ingredients = [];
  final List<TextEditingController> stepControllers = [];
  final maxWords = 20;
  int wordCount = 0;
  XFile? imageFile;

  void setImageFile(XFile? file) {
    setState(() {
      imageFile = file;
    });
  }

  Future<XFile?> pickImage({required ImageSource source}) async {
    final ImagePicker imagePicker = ImagePicker();
    try {
      final XFile? selectedImage = await imagePicker.pickImage(source: source);
      return selectedImage;
    } catch (e) {
      print('Error occurred while picking the image: $e');
      return null;
    }
  }

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

  Widget buildImagePickerContainer() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () async {
          final XFile? pickedFile =
              await pickImage(source: ImageSource.gallery);
          setImageFile(pickedFile);
        },
        child: imageFile != null
            ? Image.file(
                File(imageFile!.path),
                fit: BoxFit.fill,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.camera_alt,
                    size: 50,
                    color: Provider.of<ThemeProvider>(context, listen: false)
                        .themeData
                        .colorScheme
                        .onBackground,
                  ),
                  const Text("Pick the Image for the recipe")
                ],
              ),
      ),
    );
  }
}
