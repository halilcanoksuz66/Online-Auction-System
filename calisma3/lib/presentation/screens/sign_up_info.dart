import 'package:calisma3/data/services/audio_player.dart';
import 'package:calisma3/core/constants/colors.dart';
import 'package:calisma3/core/constants/paths.dart';
import 'package:calisma3/core/utils/sizes.dart';
import 'package:calisma3/data/repositories/auth_controller.dart';
import 'package:calisma3/presentation/screens/home.dart';
import 'package:calisma3/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUpInfo extends StatefulWidget {
  const SignUpInfo({super.key, required this.email, required this.password});
  final String email;
  final String password;

  @override
  State<SignUpInfo> createState() => _SignUpInfoState();
}

class _SignUpInfoState extends State<SignUpInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //* Wallpaper
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(signUpInfoImage), fit: BoxFit.cover)),
          ),

          //* Sign up box
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //^ SignUpInfo text
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: vertical(10),
                        child: const Text("Sign Up Info",
                            style: TextStyle(color: titleColor, fontSize: 24)),
                      ),
                      //^ Name texformfield
                      Padding(
                        padding: vertical(5),
                        child: TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Name',
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: borderColor),
                                  borderRadius: BorderRadius.circular(4))),
                        ),
                      ),
                      //^ Surname textformfield
                      Padding(
                        padding: vertical(5),
                        child: TextFormField(
                          controller: _surnameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Surname is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Surname',
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: borderColor),
                                  borderRadius: BorderRadius.circular(4))),
                        ),
                      ),
                      //^ Username textformfield
                      Padding(
                        padding: vertical(5),
                        child: TextFormField(
                          controller: _usernameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Username is required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: borderColor),
                                  borderRadius: BorderRadius.circular(4))),
                        ),
                      ),

                      //^ Continue button
                      Consumer(
                        builder: (context, ref, child) {
                          return Padding(
                            padding: vertical(10),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  UserModel userModel = UserModel(
                                      name: _nameController.text,
                                      surname: _surnameController.text,
                                      username: _usernameController.text,
                                      email: widget.email,
                                      password: widget.password);
                                  ref
                                      .read(authControllerProvider)
                                      .storeUserInfoToFirebase(userModel)
                                      .then((value) async {
                                    await _audioPlayerService
                                        .playSound(audioImage);
                                    return Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const Home()),
                                        (route) => false);
                                  });
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              color: continueButtonColor,
                              child: Padding(
                                padding: vertical(10),
                                child: const Text(
                                  "Continue",
                                  style: TextStyle(color: containerColor),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
