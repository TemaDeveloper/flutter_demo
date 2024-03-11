import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = kDebugMode ? 'http://127.0.0.1:8090' : 'TODO';

enum AuthResponse {
  incorrectPassOrEmail,
  needsVerification,
  otherError,
  sucsess,
}

class UserProvider extends ChangeNotifier {
  final PocketBase _pb = PocketBase(_baseUrl);

  /// false means logged in
  bool _isAnon = true;
  bool get isAnon => _isAnon;

  bool get needsVerification {
    if (!_pb.authStore.isValid) {
      return false;
    }
    return !_pb.authStore.model.getDataValue("verified") as bool;
  }

  /// Not empty strings
  String? get email {
    if (!_pb.authStore.isValid || _isAnon) {
      return null;
    }
    final em = _pb.authStore.model.getDataValue("email");

    return em == "" ? null : em;
  }

  String? get username {
    if (!_pb.authStore.isValid || _isAnon) {
      return null;
    }
    final un = _pb.authStore.model.getDataValue("username");
    return un == "" ? null : un;
  }

  String? get name {
    if (!_pb.authStore.isValid || _isAnon) {
      return null;
    }
    final nm = _pb.authStore.model.getDataValue("name");
    return nm == "" ? null : nm;
  }

  String? get avatarUrl {
    if (!_pb.authStore.isValid) {
      return null;
    }

    final id = _pb.authStore.model.id;
    final avatarName = _pb.authStore.model.getDataValue("avatar");

    String? avatarUrl = avatarName == ""
        ? null
        : "$_baseUrl/api/files/_pb_users_auth_/$id/$avatarName";

    return avatarUrl;
  }



  Future<bool> setAll({String? name, XFile? avatar}) async {
    if (name == null && avatar == null) {
      return false;
    }

    if (!_pb.authStore.isValid) {
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

      (file == null)
          ? await _pb
              .collection('users')
              .update(_pb.authStore.model.id, body: body)
          : await _pb
              .collection('users')
              .update(_pb.authStore.model.id, body: body, files: [file]);

    } catch (e) {
      print("AuthStore.setAll error: $e");
      return false;
    }

    notifyListeners();
    return true;
  }



  void logout() {
    if (_isAnon || !_pb.authStore.isValid) {
      return;
    }

    _pb.authStore.clear();
  }



  Future<AuthResponse> loginEmailPass(
      String loginEmailOrUserName, String password) async {
    if (!_isAnon && _pb.authStore.isValid) {
      final isVerified = _pb.authStore.model.getDataValue("verified") as bool;
      return isVerified ? AuthResponse.sucsess : AuthResponse.needsVerification;
    }

    if (loginEmailOrUserName == '' || password == '') {
      return AuthResponse.incorrectPassOrEmail;
    }

    await _pb.collection('users').authWithPassword(
          loginEmailOrUserName,
          password,
        );

    // TODO: more sophisticated checking of errors
    // maybe we need to clear store
    if (!_pb.authStore.isValid) {
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
    if (!_isAnon && _pb.authStore.isValid) {
      _pb.authStore.clear();
    }

    _isAnon = true;
    notifyListeners();
  }
}
