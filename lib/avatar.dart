import 'package:flutter/material.dart';
import 'auth/backend_proxy.dart';

Widget avatarWidgetCreate() {
  final userData = getUser();


  if (userData == null || userData.avatarUrl == null || userData.avatarUrl == "") {
    return const CircleAvatar(
      radius: 60,
      backgroundColor: Color(0xFFFF0000), // red
    );
  }

  return CircleAvatar(
    radius: 60,
    foregroundImage: NetworkImage(userData.avatarUrl!),
  );
}
