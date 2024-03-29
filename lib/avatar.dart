import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/backend_proxy.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return CircleAvatar(
      radius: 90,
      backgroundImage: user.avatarUrl != null
          ? NetworkImage(user.avatarUrl!)
          : const NetworkImage(
              'https://magipik.com/_next/image?url=https%3A%2F%2Fmedia.magipik.com%2Fsample%2Fdata%2Fpreview%2Fflat-back-and-white-chef-hat-icon-113071.png&w=1500&q=75'),
    );
  }
}
