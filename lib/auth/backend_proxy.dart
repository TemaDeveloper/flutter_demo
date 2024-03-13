import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/listModels/my_card.dart';
import 'package:flutter_application_1/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


enum AuthResponse {
  incorrectPassOrEmail,
  needsVerification,
  otherError,
  sucsess,
}

class UserProvider extends ChangeNotifier {
  final List<MyCard> _myCards = [
    const MyCard(
        title: 'title1',
        image:
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg'),
    const MyCard(
        title: 'title2',
        image:
            'https://i0.wp.com/picjumbo.com/wp-content/uploads/silhouette-of-an-olive-tree-after-beautiful-purple-sunset-free-photo.jpg?w=600&quality=80'),
    const MyCard(
        title: 'title3',
        image:
            'https://i0.wp.com/picjumbo.com/wp-content/uploads/silhouette-of-an-olive-tree-after-beautiful-purple-sunset-free-photo.jpg?w=600&quality=80'),
  ];
  get myCards => _myCards;

  removeCard(MyCard card) {
    _myCards.remove(card);
    notifyListeners();
  }

  addCard(MyCard card) {
    _myCards.add(card);
    notifyListeners();
  }

  get id => pb.authStore.isValid ? pb.authStore.model.id : null;

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

    String? avatarUrl = avatarName == ""
        ? null
        : "$backendBaseUrl/api/files/pb_users_auth_/$id/$avatarName";

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
        await pb
            .collection('users')
            .update(pb.authStore.model.id, body: body);
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
