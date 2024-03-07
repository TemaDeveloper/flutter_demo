import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';

PocketBase? pb;

PocketBase getPb() {
  const url = kDebugMode ? 'http://127.0.0.1:8090' : 'TODO';
  pb ??= PocketBase(url); // SAME AS: if (pb == null) { pb = PocketBase(url); }
  return pb!;
}

Future<bool> authEmailPass(String email, String password) async {
  print("authenticating: $email, $password");
  final pb = getPb();
  final authData = await pb.collection('users').authWithPassword(
    email,
    password,
  );

  print(authData.meta);

  return pb.authStore.isValid;
}