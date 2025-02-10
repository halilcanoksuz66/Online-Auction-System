import 'package:calisma3/core/constants/paths.dart';
import 'package:calisma3/data/services/audio_player.dart';
import 'package:calisma3/presentation/screens/auction.dart';
import 'package:calisma3/presentation/widgets/fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:calisma3/presentation/screens/create_post.dart';
import 'package:calisma3/presentation/widgets/post_card.dart';
import 'package:calisma3/data/models/post_model.dart';
import 'package:calisma3/data/models/user_model.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  List<PostModel> posts = [];
  UserModel userModel =
      UserModel(name: "", surname: "", username: "", email: "", password: "");

  @override
  void initState() {
    fetchPosts(ref, _onPostsFetched);
    fetchCurrentUser(ref, _onUserFetched);
    super.initState();
  }

  void _onPostsFetched(List<PostModel> fetchedPosts) {
    setState(() {
      posts = fetchedPosts;
    });
  }

  void _onUserFetched(UserModel fetchedUserModel) {
    setState(() {
      userModel = fetchedUserModel;
    });
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
          ),
          itemCount: posts.length,
          itemBuilder: (BuildContext context, int index) {
            return PostCard(
              user: userModel,
              post: posts[index],
              onImageTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Auction(
                              postModel: posts[index],
                              userModel: userModel,
                            )));
              },
            );
          },
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: IconButton(
            onPressed: () async {
              await _audioPlayerService.playSound(audioAll);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => CreatePost()));
            },
            icon: SvgPicture.asset(plusIconSvg),
          ),
        ),
      ],
    );
  }
}
