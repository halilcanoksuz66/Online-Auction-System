import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image) async {
    final storageRef = _storage.ref();
    final imageRef =
        storageRef.child("images/${DateTime.now().millisecondsSinceEpoch}.jpg");

    final uploadTask = imageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}
