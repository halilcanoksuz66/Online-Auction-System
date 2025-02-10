import 'package:calisma3/data/repositories/dashboard_controller.dart';
import 'package:calisma3/data/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void handleMenuSelection({
  required int value,
  required PostModel post,
  required BuildContext context,
  required WidgetRef ref,
}) {
  if (value == 2) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this post"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(dashboardControllerProvider).deletePost(post);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
