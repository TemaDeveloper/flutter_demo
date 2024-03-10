import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

PocketBase? pb;

const String _baseUrl = kDebugMode ? 'http://127.0.0.1:8090' : 'TODO';

PocketBase getPb() {
  pb ??= PocketBase(_baseUrl); // SAME AS: if (pb == null) { pb = PocketBase(url); }
  return pb!;
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
  String? avatarUrl = avatarName == "" ? null : "$_baseUrl/api/files/_pb_users_auth_/$id/$avatarName";

  return AuthResponse(
    isLogged: isLogged,
    needsVerification: !isVerified,
    avatar: avatarUrl,
  );
}
