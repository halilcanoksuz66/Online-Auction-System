import 'package:cached_network_image/cached_network_image.dart';
import 'package:calisma3/presentation/widgets/handle_menu_selection_dashboard.dart';
import 'package:calisma3/data/models/post_model.dart';
import 'package:calisma3/data/models/user_model.dart';
import 'package:calisma3/core/utils/date_time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;
  final UserModel user;
  final VoidCallback? onImageTap;

  const PostCard({
    super.key,
    required this.post,
    this.onImageTap,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: MaterialButton(
        onPressed: onImageTap,
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 15),
                CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(post.userImage!),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.username),
                    Text(formatTimestamp(post.timestamp)),
                  ],
                ),
                const Spacer(),
                PopupMenuButton(
                  onSelected: (value) => handleMenuSelection(
                      context: context, post: post, ref: ref, value: value),
                  itemBuilder: (context) {
                    if (post.uid == user.uid) {
                      return [
                        const PopupMenuItem(
                          value: 1,
                          child: Text("About us"),
                        ),
                        const PopupMenuItem(
                          value: 2,
                          child: Text("Delete"),
                        ),
                      ];
                    } else {
                      return [
                        const PopupMenuItem(
                          value: 1,
                          child: Text("About us"),
                        ),
                      ];
                    }
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                post.contentText!,
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: CachedNetworkImage(
                imageUrl: post.contentImage,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
