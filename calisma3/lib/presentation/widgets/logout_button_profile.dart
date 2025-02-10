import 'package:calisma3/core/constants/colors.dart';
import 'package:calisma3/core/constants/paths.dart';
import 'package:calisma3/data/services/audio_player.dart';
import 'package:calisma3/core/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calisma3/data/repositories/auth_controller.dart';
import 'package:calisma3/presentation/screens/sign_in.dart';

class LogoutButtonProfile extends StatelessWidget {
  final WidgetRef ref;
  final BuildContext context;
  final AudioPlayerService _audioPlayerService = AudioPlayerService();

  LogoutButtonProfile({super.key, required this.ref, required this.context});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: () async {
          ref.read(authControllerProvider).signOut();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const SignIn()),
            (route) => false,
          );
          await _audioPlayerService.playSound(audioImage);
        },
        color: profilePhotoCircleColor,
        elevation: 0,
        minWidth: 200,
        height: 50,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: borderColor)),
        child: Padding(
          padding: vertical(10),
          child: const Text(
            "Logout",
            style: TextStyle(color: containerColor),
          ),
        ));
  }
}
