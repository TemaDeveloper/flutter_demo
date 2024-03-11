import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  /// false means logged in
  bool _isAnon = true;

  /// Not empty strings
  String? _email;
  String? _userName;
  String? _name;
  String? _avatarUrl;

  bool get isAnon => _isAnon;
  String? get name => _name;
  String? get avatarUrl => _avatarUrl;
  String? get email => _email;
  String? get username => _userName;

  Future<bool> setAll(
      {String? name, XFile? avatar}) async {
    final res = await authTryChange(name: name, avatar: avatar);
    if (!res.success) {
      return false;
    }

    _name = name;
    _avatarUrl = res.avatarUrl;
    notifyListeners();
    return true;
  }
}

const String _baseUrl = kDebugMode ? 'http://127.0.0.1:8090' : 'TODO';
PocketBase? _pb;

PocketBase getPb() {
  _pb ??= PocketBase(
      _baseUrl); // SAME AS: if (pb == null) { pb = PocketBase(url); }
  return _pb!;
}

String? getAvatarUrl() {
  final pb = getPb();
  final id = pb.authStore.model.id;
  final avatarName = pb.authStore.model.getDataValue("avatar");

  String? avatarUrl = avatarName == ""
      ? null
      : "$_baseUrl/api/files/_pb_users_auth_/$id/$avatarName";

  return avatarUrl;
}

class AuthResponse {
  final bool isLogged;
  final bool needsVerification;

  const AuthResponse({
    required this.isLogged,
    required this.needsVerification,
  });
}

// Calling it again, causes relogin(logout + login)
Future<AuthResponse> authEmailPass(
    String email, String password, UserProvider provider) async {
  final pb = getPb();
  pb.authStore.clear();

  await pb.collection('users').authWithPassword(
        email,
        password,
      );

  bool isVerified = pb.authStore.model.getDataValue("verified") as bool;
  bool isLogged = pb.authStore.isValid;

  if (!pb.authStore.isValid) {
    return AuthResponse(
      isLogged: isLogged,
      needsVerification: false,
    );
  }

  String? name = pb.authStore.model.getDataValue("name") == ""
      ? null
      : pb.authStore.model.getDataValue("name");


  String? userName = pb.authStore.model.getDataValue("username") == ""
      ? null
      : pb.authStore.model.getDataValue("username");

  provider._isAnon = false;
  provider._avatarUrl = getAvatarUrl();
  provider._name = name;
  provider._email = email == "" ? email : null;
  provider._userName = userName;

  return AuthResponse(
    isLogged: isLogged,
    needsVerification: !isVerified,
  );
}

void authAnon(UserProvider usrProvider) async {
  usrProvider
    .._isAnon = true
    .._avatarUrl = null
    .._name = null
    .._email = null
    .._userName = null;

  // well, it should be okay just in this case
  // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
  usrProvider.notifyListeners();
}

class ChangeResponse {
  final bool success;
  final String? name;
  final String? email;
  final String? avatarUrl;

  const ChangeResponse({
    required this.success,
    this.name,
    this.email,
    this.avatarUrl,
  });
}

/// null means no change
Future<ChangeResponse> authTryChange({
  String? name,
  String? lastName,
  XFile? avatar,
}) async {
  if (name == null && lastName == null && avatar == null) {
    return const ChangeResponse(success: false);
  }

  final pb = getPb();
  if (!pb.authStore.isValid) {
    return const ChangeResponse(success: false);
  }

  final body = <String, dynamic>{};

  if (name != null || lastName != null) {
    body["name"] = "${name ?? ""} ${lastName ?? ""}";
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
        ? await pb.collection('users').update(pb.authStore.model.id, body: body)
        : await pb
            .collection('users')
            .update(pb.authStore.model.id, body: body, files: [file]);

    return ChangeResponse(success: true, name: name, avatarUrl: getAvatarUrl());
  } catch (e) {
    return const ChangeResponse(success: false);
  }
}
