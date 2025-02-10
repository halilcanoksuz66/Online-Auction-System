import 'package:calisma3/presentation/widgets/post_card.dart';
import 'package:calisma3/data/models/post_model.dart';
import 'package:calisma3/data/models/user_model.dart';
import 'package:calisma3/presentation/widgets/fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyAuctions extends ConsumerStatefulWidget {
  const MyAuctions({super.key});

  @override
  ConsumerState<MyAuctions> createState() => _MyAuctionsState();
}

class _MyAuctionsState extends ConsumerState<MyAuctions> {
  List<PostModel> posts = [];
  UserModel usermodel =
      UserModel(name: "", surname: "", username: "", email: "", password: "");

  @override
  void initState() {
    super.initState();
    fetchPosts(ref, _onPostsFetched);
    fetchCurrentUser(ref, _onUserFetched);
  }

  void _onPostsFetched(List<PostModel> fetchedPosts) {
    setState(() {
      posts = fetchedPosts;
    });
  }

  void _onUserFetched(UserModel fetchedUserModel) {
    setState(() {
      usermodel = fetchedUserModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final userPosts = posts.where((post) => post.uid == usermodel.uid).toList();

    if (userPosts.isEmpty) {
      return const Center(child: Text("No Auctions Found"));
    }

    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        itemCount: userPosts.length,
        itemBuilder: (context, index) {
          final post = userPosts[index];
          return PostCard(post: post, user: usermodel);
        });
  }
}
