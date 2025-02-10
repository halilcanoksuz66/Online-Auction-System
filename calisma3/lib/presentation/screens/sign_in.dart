import 'dart:async';

import 'package:calisma3/core/constants/colors.dart';
import 'package:calisma3/core/constants/paths.dart';
import 'package:calisma3/data/services/audio_player.dart';
import 'package:calisma3/data/repositories/auth_controller.dart';
import 'package:calisma3/presentation/screens/sign_up.dart';
import 'package:calisma3/presentation/screens/home.dart';
import 'package:calisma3/core/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  final _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');
    final rememberMe = email != null && password != null;

    if (rememberMe) {
      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        _rememberMe = rememberMe;
      });
    }
  }

  Future<void> _validateAndSignIn(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authControllerProvider)
          .signInWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
              rememberMe: _rememberMe)
          .then((value) async {
        await _audioPlayerService.playSound(audioImage);

        return Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => const Home()), (route) => false);
      });
    }
  }

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
                    image: AssetImage(signInImage), fit: BoxFit.cover)),
          ),

          //* Sign in box
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
                        //^ Sign in text
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: vertical(10),
                          child: const Text("Sign In",
                              style:
                                  TextStyle(color: titleColor, fontSize: 24)),
                        ),
                        //^ Email texformfield
                        Padding(
                          padding: vertical(5),
                          child: TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email is required';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: borderColor),
                                    borderRadius: BorderRadius.circular(4))),
                          ),
                        ),
                        //^ Password textformfield
                        Padding(
                          padding: vertical(5),
                          child: TextFormField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: borderColor),
                                    borderRadius: BorderRadius.circular(4))),
                          ),
                        ),
                        //^ Sign in button
                        Consumer(builder: (context, ref, child) {
                          return Padding(
                            padding: vertical(10),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: () => _validateAndSignIn(context, ref),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              color: signInButtonColor,
                              child: Padding(
                                padding: vertical(10),
                                child: const Text("Sign In",
                                    style: TextStyle(color: containerColor)),
                              ),
                            ),
                          );
                        }),
                        //^ Remember Me
                        Row(
                          children: [
                            Checkbox(
                                value: _rememberMe,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                }),
                            const Text(
                              "Remember Me",
                              style: TextStyle(color: titleColor),
                            )
                          ],
                        ),

                        //^ Don't haven't an account Sign Up text and textButton
                        Padding(
                          padding: vertical(10),
                          child: Row(
                            children: [
                              const Text(
                                "Don't haven't an account",
                                style: TextStyle(
                                    color: textButtonTextColor, fontSize: 14),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const SignUp()));
                                  await _audioPlayerService
                                      .playSound(audioImage);
                                },
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: signInButtonColor, fontSize: 12),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
