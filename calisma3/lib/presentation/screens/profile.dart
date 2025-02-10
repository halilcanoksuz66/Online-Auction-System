import 'package:calisma3/data/repositories/profile_controller.dart';
import 'package:calisma3/presentation/widgets/delete_user_button_profile.dart';
import 'package:calisma3/presentation/widgets/edit_profile_button_profile.dart';
import 'package:calisma3/presentation/widgets/logout_button_profile.dart';
import 'package:calisma3/presentation/widgets/profile_image_profile.dart';
import 'package:calisma3/presentation/widgets/user_fullname_text_profile.dart';
import 'package:calisma3/presentation/widgets/username_text_profile.dart';
import 'package:calisma3/data/models/user_model.dart';
import 'package:calisma3/core/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends ConsumerState<Profile> {
  late Future<UserModel> _userFuture;
  @override
  void initState() {
    super.initState();
    _userFuture = ref.read(profileControllerProvider).getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Profile fotoğrafı taşmasın diyerekten safearea oluşturuyorum.
        child: Padding(
          padding: paddingAll(15),
          child: FutureBuilder<UserModel>(
            future: _userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('An error occurred'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              }

              final userModel = snapshot.data!;
              return Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfileImageProfile(userModel: userModel),
                    UsernameTextProfile(username: userModel.username),
                    UserFullNameTextProfile(
                        name: userModel.name, surname: userModel.surname),
                    EditProfileButtonProfile(context: context),
                    LogoutButtonProfile(ref: ref, context: context),
                    DeleteUserButtonProfile(ref: ref, context: context),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
