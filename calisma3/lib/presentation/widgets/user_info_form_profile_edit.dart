import 'package:calisma3/core/constants/colors.dart';
import 'package:calisma3/core/utils/sizes.dart';
import 'package:flutter/material.dart';

class UserInfoFormProfileedit extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  const UserInfoFormProfileedit(
      {super.key,
      required this.nameController,
      required this.lastNameController,
      required this.usernameController,
      required this.emailController,
      required this.passwordController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: vertical(10),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: horizontal(5),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: borderColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      hintText: 'Ad',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: horizontal(5),
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: borderColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      hintText: 'Soyad',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: vertical(10),
          child: Padding(
            padding: horizontal(5),
            child: TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: borderColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                hintText: 'Kullanıcı Adı',
              ),
            ),
          ),
        ),
        Padding(
          padding: vertical(10),
          child: Center(
            child: Padding(
              padding: horizontal(5),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  hintText: 'E-posta',
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: vertical(10),
          child: Center(
            child: Padding(
              padding: horizontal(5),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: borderColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  hintText: 'Şifre',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
