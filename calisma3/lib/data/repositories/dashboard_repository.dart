import 'package:calisma3/data/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRepositoryProvider = Provider((ref) => DashboardRepository(
    firebaseFirestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance));

class DashboardRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth auth;
  DashboardRepository({required this.firebaseFirestore, required this.auth});

  Future<void> storePostInfoToFirebase(PostModel postModel) async {
    postModel.userImage ??=
        "https://static.vecteezy.com/system/resources/previews/036/280/650/original/default-avatar-profile-icon-social-media-user-image-gray-avatar-icon-blank-profile-silhouette-illustration-vector.jpg";
    postModel.uid = auth.currentUser!.uid;
    await firebaseFirestore
        .collection("posts")
        .doc(postModel.id)
        .set(postModel.toMap());
  }

  Future<List<PostModel>> fetchPosts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("posts").get();

    List<PostModel> fetchedPosts = [];
    for (var doc in querySnapshot.docs) {
      fetchedPosts.add(PostModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    return fetchedPosts;
  }

  Future<void> deletePost(PostModel postModel) async {
    await firebaseFirestore.collection("posts").doc(postModel.id).delete();
  }
}
