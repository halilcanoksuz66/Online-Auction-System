import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calisma3/core/constants/colors.dart';
import 'package:calisma3/data/models/user_model.dart';
import 'package:calisma3/core/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhotoEditprofile extends StatefulWidget {
  final File? image;
  final UserModel usermodel;
  final Function(File?) onImageChanged;
  const ProfilePhotoEditprofile(
      {super.key,
      this.image,
      required this.usermodel,
      required this.onImageChanged});

  @override
  State<ProfilePhotoEditprofile> createState() =>
      _ProfilePhotoEditprofileState();
}

class _ProfilePhotoEditprofileState extends State<ProfilePhotoEditprofile> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        widget.onImageChanged(_image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _pickImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print(_image == null ? "Image is null" : "Image is not null");
            return Padding(
              padding: vertical(10),
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  backgroundColor: profilePhotoCircleColor,
                  radius: 70,
                  child: CircleAvatar(
                    radius: 68,
                    backgroundImage: _image == null
                        ? CachedNetworkImageProvider(
                            widget.usermodel.profilePhoto!)
                        : FileImage(_image!) as ImageProvider,
                  ),
                ),
              ),
            );
          } else {
            return CircularProgressIndicator(); // Bekleme sırasında bir yükleme göstergesi gösterin
          }
        });
  }
}
