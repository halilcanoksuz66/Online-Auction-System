import 'dart:io';

import 'package:calisma3/data/models/post_model.dart';
import 'package:calisma3/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storage paketi
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepository(
    firebaseFirestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    firebaseStorage: FirebaseStorage.instance)); // Firebase Storage'ı ekliyoruz

class ProfileRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth auth;
  final FirebaseStorage firebaseStorage;

  ProfileRepository(
      {required this.firebaseFirestore,
      required this.auth,
      required this.firebaseStorage});

  Future<UserModel> getUser() async {
    try {
      return await firebaseFirestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) {
        return UserModel.fromMap(value.data()!);
      });
    } catch (e) {
      throw Exception("Kullanıcı verisi alınamadı");
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    try {
      final docRef = firebaseFirestore.collection("users").doc(userModel.uid);
      await docRef.set(userModel.toMap());
    } catch (e) {
      throw Exception("Kullanıcı güncellenemedi");
    }
  }

  Future<String> uploadProfilePhoto(File file) async {
    try {
      final ref = firebaseStorage
          .ref()
          .child('profile_photos/${auth.currentUser!.uid}.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Profil fotoğrafı yüklenemedi");
    }
  }

  Future<void> deleteUser() async {
    try {
      return await firebaseFirestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .delete();
    } catch (e) {
      throw Exception("Kullanıcı silinemedi");
    }
  }

  Future<void> updatePost(PostModel postModel) async {
    try {
      final docRef = firebaseFirestore.collection("posts").doc(postModel.id);
      await docRef.set(postModel.toMap());
    } catch (e) {
      throw Exception("Post güncellenemedi");
    }
  }
}
