import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/backend_proxy.dart';
import 'package:flutter_application_1/avatar.dart';
import 'package:flutter_application_1/listModels/reusable_widgets.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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

  bool? _changeSucsess;
  XFile? _image;

  void updateCb(BuildContext ctx) {
    strOrNull(String str) => str == '' ? null : str;
    final usrProvider = Provider.of<UserProvider>(ctx, listen: false);
    usrProvider
        .setAll(name: strOrNull(_nameController.text), avatar: _image)
        .then((r) => setState(() => _changeSucsess = r))
        .catchError((e) => setState(() => _changeSucsess = false));
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
        iconTheme: IconThemeData(
          color: Provider.of<ThemeProvider>(context, listen: false)
              .themeData
              .colorScheme
              .onBackground, // Set the color of the AppBar icons
        ),
        title: const Text('Update Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const AvatarWidget(),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => _handleImageSelection(context).then((file) {
                final usrProvider =
                    Provider.of<UserProvider>(context, listen: false);
                usrProvider.setAll(avatar: file);
                setState(() => _image = file);
              }).catchError((e) => print("Image selection Error: $e")),
              child: Text('Change Profile Avatar',
                  style: TextStyle(
                    color: Provider.of<ThemeProvider>(context)
                        .themeData
                        .colorScheme
                        .onBackground,
                  )),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ReusableTextField(
                      controller: _emailController, hint: 'Email'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ReusableTextField(
                      controller: _nameController, hint: 'Name'),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: ReusableButton(
            buttonText: 'Update Profile',
            navigate: () {
              updateCb(context);
            }),
      ),
    );
  }
}
