import 'package:cached_network_image/cached_network_image.dart';
import 'package:calisma3/core/constants/colors.dart';
import 'package:calisma3/core/utils/sizes.dart';
import 'package:calisma3/data/models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileImageProfile extends StatelessWidget {
  const ProfileImageProfile({super.key, required this.userModel});

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: vertical(10),
      child: CircleAvatar(
        backgroundColor: profilePhotoCircleColor,
        radius: 70,
        child: CircleAvatar(
          radius: 68,
          backgroundImage: userModel.profilePhoto != null &&
                  userModel.profilePhoto!.isNotEmpty
              ? CachedNetworkImageProvider(userModel.profilePhoto!)
              : const AssetImage('assets/default_profile.png')
                  as ImageProvider, // Varsayılan bir profil fotoğrafı ekleyin
        ),
      ),
    );
  }
}
