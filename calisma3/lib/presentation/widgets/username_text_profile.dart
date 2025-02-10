import 'package:calisma3/core/constants/colors.dart';
import 'package:flutter/material.dart';

class UsernameTextProfile extends StatelessWidget {
  const UsernameTextProfile({super.key, required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    return Text("@$username",
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: titleColor));
  }
}
