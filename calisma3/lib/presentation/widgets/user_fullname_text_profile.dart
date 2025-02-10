import 'package:calisma3/core/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:calisma3/core/constants/colors.dart';

class UserFullNameTextProfile extends StatelessWidget {
  final String name;
  final String surname;

  const UserFullNameTextProfile(
      {super.key, required this.name, required this.surname});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: vertical(10),
      child: Text("$name $surname",
          style: const TextStyle(fontSize: 24, color: titleColor)),
    );
  }
}
