import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

enum AuthResponse {
  incorrectPassOrEmail,
  needsVerification,
  otherError,
  sucsess,
}


String avatarNameToUrl(String id, String name) =>
    "$backendBaseUrl/api/files/_pb_users_auth_/$id/$name";

class IngredientCreateInfo {
  final String name;
  final XFile? img;
  const IngredientCreateInfo({required this.name, this.img});
}

class CookingStepCreateInfo {
  final String text;
  const CookingStepCreateInfo({required this.text});
}

class UserProvider extends ChangeNotifier {

  /*-----------------------------------------------------------------------*/
  /*--------------------------------LIKES----------------------------------*/
  /*-----------------------------------------------------------------------*/
  List<String> get likes => pb.authStore.model.getListValue<String>("liked");

  void like(String id) {
    var liked = likes;
    liked = liked.contains(id) ? liked : liked
      ..add(id);
    pb
        .collection('users')
        .update(pb.authStore.model.id, body: {"liked": liked})
        .catchError((e) => print("UserProvider.like error: $e"))
        .then((_) => notifyListeners());
  }

  void dislike(String id) async {
    var liked = likes;
    liked = !liked.contains(id) ? liked : liked
      ..remove(id);
    pb
        .collection('users')
        .update(pb.authStore.model.id, body: {"liked": liked})
        .catchError((e) => print("UserProvider.dislike error: $e"))
        .then((_) => notifyListeners());
  }

  /*-----------------------------------------------------------------------*/
  /*-----------------------------AddRecipie--------------------------------*/
  /*-----------------------------------------------------------------------*/
  Future<bool> addRecipie({
    required String title,
    required String description,
    // XFile? previewImg,
    // required List<IngredientCreateInfo> ingredients,
    // required List<CookingStepCreateInfo> steps,
  }) async {
    pb.collection('recipies').create(body: {
      title: title,
      description: description,
    }).catchError( (e) => print("UserProvider.addRecipie error: $e") );
    return true;
  }

  /*-----------------------------------------------------------------------*/
  /*-----------------------------PROPERTIES--------------------------------*/
  /*-----------------------------------------------------------------------*/
  String? get id => pb.authStore.isValid || _isAnon ? pb.authStore.model.id : null;

  /// false means logged in
  bool _isAnon = true;
  bool get isAnon => _isAnon;

  bool get needsVerification {
    if (!pb.authStore.isValid) {
      return false;
    }
    return !pb.authStore.model.getDataValue("verified");
  }

  /// Not empty strings
  String? get email {
    if (!pb.authStore.isValid || _isAnon) {
      return null;
    }
    final em = pb.authStore.model.getDataValue("email");

    return em == "" ? null : em;
  }

  String? get username {
    if (!pb.authStore.isValid || _isAnon) {
      return null;
    }
    final un = pb.authStore.model.getDataValue("username");
    return un == "" ? null : un;
  }

  String? get name {
    if (!pb.authStore.isValid || _isAnon) {
      return null;
    }
    final nm = pb.authStore.model.getDataValue("name");
    return nm == "" ? null : nm;
  }

  String? get avatarUrl {
    if (!pb.authStore.isValid) {
      return null;
    }

    final id = pb.authStore.model.id;
    final avatarName = pb.authStore.model.getDataValue("avatar");

    String? avatarUrl =
        avatarName == "" ? null : avatarNameToUrl(id, avatarName);

    return avatarUrl;
  }

  Future<bool> setAll({String? name, XFile? avatar}) async {
    if (name == null && avatar == null) {
      return false;
    }

    if (!pb.authStore.isValid) {
      return false;
    }

    final body = <String, dynamic>{};

    if (name != null) {
      body["name"] = name;
    }

    try {
      http.MultipartFile? file;
      if (avatar != null) {
        file = http.MultipartFile.fromBytes(
          'avatar',
          await File(avatar.path).readAsBytes(),
          filename: avatar.name,
        );
      }

      final avatarName = pb.authStore.model.getDataValue("avatar") as String;

      if (file == null) {
        await pb.collection('users').update(pb.authStore.model.id, body: body);
      } else if (avatarName != avatar!.name) {
        await pb
            .collection('users')
            .update(pb.authStore.model.id, body: body, files: [file]);
      }
    } catch (e) {
      print("AuthStore.setAll error: $e");
      return false;
    }

    notifyListeners();
    return true;
  }

  void logout() {
    if (_isAnon || !pb.authStore.isValid) {
      return;
    }

    pb.authStore.clear();
  }

  Future<AuthResponse> loginEmailPass(
      String loginEmailOrUserName, String password) async {
    if (!_isAnon && pb.authStore.isValid) {
      final isVerified = pb.authStore.model.getDataValue("verified") as bool;
      return isVerified ? AuthResponse.sucsess : AuthResponse.needsVerification;
    }

    if (loginEmailOrUserName == '' || password == '') {
      return AuthResponse.incorrectPassOrEmail;
    }

    await pb.collection('users').authWithPassword(
          loginEmailOrUserName,
          password,
        );

    // TODO: more sophisticated checking of errors
    // maybe we need to clear store
    if (!pb.authStore.isValid) {
      return AuthResponse.incorrectPassOrEmail;
    }

    _isAnon = false;
    notifyListeners();

    if (needsVerification) {
      return AuthResponse.needsVerification;
    }

    return AuthResponse.sucsess;
  }

  Future<void> loginAnon() async {
    if (!_isAnon && pb.authStore.isValid) {
      pb.authStore.clear();
    }

    _isAnon = true;
    notifyListeners();
  }
}
