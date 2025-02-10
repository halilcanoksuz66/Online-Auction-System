import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:calisma3/data/repositories/dashboard_controller.dart';
import 'package:calisma3/data/repositories/profile_controller.dart';
import 'package:calisma3/data/models/post_model.dart';
import 'package:calisma3/data/models/user_model.dart';

class FetchDataCommon extends StatelessWidget {
  final Ref ref;
  const FetchDataCommon({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Future<void> fetchCurrentUser(
    WidgetRef ref, Function(UserModel) onUserFetched) async {
  try {
    UserModel fetchedUserModel =
        await ref.read(profileControllerProvider).getUser();
    onUserFetched(fetchedUserModel);
  } catch (error) {
    print("Error fetching data: $error");
    // Hata durumunda yapılacak işlemler
  }
}

Future<void> fetchPosts(
    WidgetRef ref, Function(List<PostModel>) onPostsFetched) async {
  try {
    List<PostModel> fetchedPosts =
        await ref.read(dashboardControllerProvider).fetchPosts();
    onPostsFetched(fetchedPosts);
  } catch (error) {
    print("Error fetching data: $error");
    // Hata durumunda yapılacak işlemler
  }
}
