import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = kDebugMode ? 'http://127.0.0.1:8090' : 'TODO';
PocketBase? _pb;

UserData? _user;

class UserData {
  String? username;
  String? name;
  String? email;
  String? avatarUrl;
}

PocketBase getPb() {
  _pb ??= PocketBase(
      _baseUrl); // SAME AS: if (pb == null) { pb = PocketBase(url); }
  return _pb!;
}

UserData? getUser() {
  return _user;
}

class AuthResponse {
  final bool isLogged;
  final bool needsVerification;
  final String? avatar;

  const AuthResponse({
    required this.isLogged,
    required this.needsVerification,
    required this.avatar,
  });
}

// Calling it again, causes relogin(logout + login)
Future<AuthResponse> authEmailPass(String email, String password) async {
  final pb = getPb();
  pb.authStore.clear();

  await pb.collection('users').authWithPassword(
        email,
        password,
      );

  bool isVerified = pb.authStore.model.getDataValue("verified") as bool;
  bool isLogged = pb.authStore.isValid;
  final id = pb.authStore.model.id;

  final avatarName = pb.authStore.model.getDataValue("avatar");
  String? avatarUrl = avatarName == ""
      ? null
      : "$_baseUrl/api/files/_pb_users_auth_/$id/$avatarName";

  _user = UserData()
    ..username = pb.authStore.model.getDataValue("username") as String?
    ..name = pb.authStore.model.getDataValue("name") as String?
    ..email = pb.authStore.model.getDataValue("email") as String?
    ..avatarUrl = avatarUrl;

  return AuthResponse(
    isLogged: isLogged,
    needsVerification: !isVerified,
    avatar: avatarUrl,
  );
}

Future<bool> authTryChange({
  String? name,
  String? lastName,
  XFile? avatar,
}) async {
  final pb = getPb();
  if (!pb.authStore.isValid) {
    return false;
  }

  final body = <String, dynamic>{};

  if (name != null || lastName != null) {
    body["name"] = "${name ?? ""} ${lastName ?? ""}";
  }

  try {
    if (avatar != null) {
      var file = http.MultipartFile.fromBytes(
        'avatar',
        await File(avatar.path).readAsBytes(),
        filename: avatar.name,
      );
      await pb
          .collection('users')
          .update(pb.authStore.model.id, body: body, files: [file]);
    } else {
      await pb.collection('users').update(pb.authStore.model.id, body: body);
    }
    return true;
  } catch (e) {
    return false;
  }
}
