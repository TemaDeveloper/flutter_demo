import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/backend_proxy.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    return CircleAvatar(
      backgroundImage: user.avatarUrl != null
          ? NetworkImage(user.avatarUrl!)
          : null,
    );
  }
}