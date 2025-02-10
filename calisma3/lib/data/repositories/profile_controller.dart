import 'dart:io';

import 'package:calisma3/data/repositories/profile_repository.dart';
import 'package:calisma3/data/models/post_model.dart';
import 'package:calisma3/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileControllerProvider = Provider((ref) =>
    ProfileController(profileRepository: ref.read(profileRepositoryProvider)));

class ProfileController {
  final ProfileRepository profileRepository;

  ProfileController({required this.profileRepository});

  Future<UserModel> getUser() async {
    return await profileRepository.getUser();
  }

  Future<void> updateUser(UserModel userModel, List<PostModel> posts,
      {File? profilePhoto}) async {
    if (profilePhoto != null) {
      final downloadUrl =
          await profileRepository.uploadProfilePhoto(profilePhoto);
      userModel.profilePhoto = downloadUrl;
    }
    await profileRepository.updateUser(userModel);
    for (var post in posts) {
      if (post.uid == userModel.uid) {
        post.userImage = userModel.profilePhoto;
        post.username = userModel.username;
        await profileRepository.updatePost(post);
      }
    }
  }

  Future<void> deleteUser() async {
    return await profileRepository.deleteUser();
  }

  Future<void> updatePost(PostModel postModel) async {
    return await profileRepository.updatePost(postModel);
  }
}
