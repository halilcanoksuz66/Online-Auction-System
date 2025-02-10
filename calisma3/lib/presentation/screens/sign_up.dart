import 'package:calisma3/data/services/audio_player.dart';
import 'package:calisma3/core/constants/colors.dart';
import 'package:calisma3/core/constants/paths.dart';
import 'package:calisma3/core/utils/sizes.dart';
import 'package:calisma3/data/repositories/auth_controller.dart';
import 'package:calisma3/presentation/screens/sign_in.dart';
import 'package:calisma3/presentation/screens/sign_up_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AudioPlayerService _audioPlayerService = AudioPlayerService();

  Future<void> _validateAndSignUp(BuildContext context, WidgetRef ref) async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(authControllerProvider).signUpWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );
        await _audioPlayerService.playSound(audioImage);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SignUpInfo(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          ),
        );
      } catch (e) {
        if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This email is already registered'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred!'),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter values correctly'),
        ),
      );
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
                    image: AssetImage(signUpImage), fit: BoxFit.cover)),
          ),

          //* Sign up box
          AspectRatio(
            aspectRatio: 0.90,
            child: Container(
              padding: paddingAll(15),
              decoration: const BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Form(
                autovalidateMode: AutovalidateMode
                    .onUserInteraction, // Sadece kullanıcı alanla etkileşime girdiği zaman form kullanılacak.
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //^ Sign up text
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: vertical(10),
                        child: const Text("Sign Up",
                            style: TextStyle(color: titleColor, fontSize: 24)),
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
                      //^ PasswordAgain textformfield
                      Padding(
                        padding: vertical(5),
                        child: TextFormField(
                          controller: _passwordAgainController,
                          validator: (value) {
                            if (value! != _passwordController.text) {
                              return 'passwords do not match';
                            }
                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              labelText: 'Password Again',
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: borderColor),
                                  borderRadius: BorderRadius.circular(4))),
                        ),
                      ),

                      //^ Sign up button
                      Consumer(
                        builder: (context, ref, child) {
                          return Padding(
                            padding: vertical(10),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: () => _validateAndSignUp(context, ref),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              color: continueButtonColor,
                              child: Padding(
                                padding: vertical(10),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(color: containerColor),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      //^ Do you have an account? Sign Up text and textButton
                      Padding(
                        padding: vertical(10),
                        child: Row(
                          children: [
                            const Text(
                              "Do you have an account?",
                              style: TextStyle(
                                  color: textButtonTextColor, fontSize: 14),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SignIn()));
                                await _audioPlayerService.playSound(audioImage);
                              },
                              child: const Text(
                                "Sign In",
                                style: TextStyle(
                                    color: signInButtonColor, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      )
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
