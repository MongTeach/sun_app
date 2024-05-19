import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  final VoidCallback onProfilePressed;

  const ProfileMenu({
    Key? key,
    required this.onProfilePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.account_circle),
      onPressed: onProfilePressed,
    );
  }
}
