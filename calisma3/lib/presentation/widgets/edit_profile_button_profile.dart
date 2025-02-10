import 'package:calisma3/core/constants/colors.dart';
import 'package:calisma3/core/constants/paths.dart';
import 'package:calisma3/data/services/audio_player.dart';
import 'package:calisma3/core/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:calisma3/presentation/screens/edit_profile.dart';

class EditProfileButtonProfile extends StatelessWidget {
  final BuildContext context;

  EditProfileButtonProfile({super.key, required this.context});
  final AudioPlayerService _audioPlayerService = AudioPlayerService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: vertical(1),
      child: MaterialButton(
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const EditProfile()));
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
              "Edit Profile",
              style: TextStyle(color: containerColor),
            ),
          )),
    );
  }
}
