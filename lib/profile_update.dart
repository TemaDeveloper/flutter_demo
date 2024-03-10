import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';
import 'package:flutter_application_1/avatar.dart';
import 'package:image_picker/image_picker.dart';

Future<XFile?> _handleImageSelection(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  XFile? image;

  // Check platform
  if (kIsWeb || Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    // Pick image file on desktop or web
    image = await picker.pickImage(source: ImageSource.gallery);
  } else {
    // For mobile platforms, show option to pick from gallery or take a new picture
    final option = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take Picture'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );

    if (option != null) {
      image = await picker.pickImage(source: option);
    }
  }

  if (image != null) {
    // Process the selected image
    print('Selected image path: ${image.path}');
    // For example, you can display the image using Image.file(File(image.path))
  }

  return image;
}

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

// NOTE: changing email, requires a verification email to be sent(we will avoid this for now)
class _UpdateProfileState extends State<UpdateProfile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  bool? _changeSucsess;
  XFile? _image;

  void updateCb() {
    strOrNull(String str) => str == '' ? null : str;

    authTryChange(
      name: strOrNull(_nameController.text),
      lastName: strOrNull(_surnameController.text),
    ).then((sucsess) {
      setState(() => _changeSucsess = sucsess);
    }).catchError((e) {
      print("update profile callback, GOT ERROR: $e");
      setState(() => _changeSucsess = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_changeSucsess == true) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.of(context).pop(),
      );
    }

    if (_changeSucsess == false) {
      print(
          "TODO: add a red box with white latters saying: go fuck your self you've got an error");
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.of(context).pop(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            avatarWidgetCreate(),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () async {
                _handleImageSelection(context).then((file) {
                  if (file != null) {
                    authTryChangeAvatar(file);
                  }
                }).catchError((e) => print("Image Picking, GOT ERROR: $e"));
              },
              child: const Text('Change Profile Avatar'),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _surnameController,
                    decoration: const InputDecoration(
                      labelText: 'Surname',
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: updateCb,
              child: const Text('Update Profile'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
