import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:calisma3/data/models/post_model.dart';

class LifecycleService with WidgetsBindingObserver {
  List<PostModel> posts = [];

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  void setPosts(List<PostModel> posts) {
    this.posts = posts;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      for (var post in posts) {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(post.id)
            .update({'remainingTime': post.remainingTime})
            .then((_) => print("Counter updated on Firestore"))
            .catchError((error) => print("Error updating counter: $error"));
      }
    }
  }
}
