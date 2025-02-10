import 'package:calisma3/presentation/widgets/post_card.dart';
import 'package:calisma3/data/models/post_model.dart';
import 'package:calisma3/data/models/user_model.dart';
import 'package:calisma3/presentation/widgets/fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WonAuctions extends ConsumerStatefulWidget {
  const WonAuctions({super.key});

  @override
  ConsumerState<WonAuctions> createState() => WonAuctionsState();
}

class WonAuctionsState extends ConsumerState<WonAuctions> {
  List<PostModel> posts = [];
  List<PostModel> wonPosts = [];
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

  List<PostModel> _parseOffer() {
    for (var post in posts) {
      if (post.remainingTime == 0) {
        if (post.offer != null && post.offer != "0") {
          final parts = post.offer!.split(' \$');
          String postName = parts.first;
          if (usermodel.username == postName) {
            wonPosts.add(post);
          }
        }
      } else {
        print("Kardeşim sıkıntı burda");
      }
    }
    return wonPosts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final wonPosts = _parseOffer();

    if (wonPosts.isEmpty) {
      return const Center(child: Text("No Won Auctions Found"));
    }

    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        itemCount: wonPosts.length,
        itemBuilder: (context, index) {
          final post = wonPosts[index];
          return PostCard(post: post, user: usermodel);
        });
  }
}
