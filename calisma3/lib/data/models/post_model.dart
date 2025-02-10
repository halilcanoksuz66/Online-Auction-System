import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  String username;
  String contentImage;
  int remainingTime;
  String? uid;
  String? userImage;
  String? contentText;
  Timestamp? timestamp;
  String? offer;
  final StreamController remainingTimeStreamController;

  PostModel({
    required this.id,
    required this.username,
    required this.contentImage,
    required this.remainingTime,
    this.offer,
    this.uid,
    this.userImage,
    this.timestamp,
    this.contentText,
  }) : remainingTimeStreamController = StreamController<int>.broadcast() {
    startCountdown(); // Countdown'u başlat
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (remainingTime > 0) {
        remainingTime--;
        remainingTimeStreamController.add(remainingTime);
      } else {
        timer.cancel();
        remainingTimeStreamController.close();

        // Firestore'da postu güncelle
        await updatePostInFirestore();
      }
    });
  }

  Future<void> updatePostInFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(id).update({
        'remainingTime': remainingTime,
        // Diğer güncellenmesi gereken alanlar varsa buraya ekleyin
      });
    } catch (e) {
      print('Error updating post: $e');
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'username': username,
      'userImage': userImage,
      'timestamp': timestamp,
      'contentText': contentText,
      'contentImage': contentImage,
      'remainingTime': remainingTime,
      'offer': offer
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      uid: map['uid'] as String?,
      userImage: map['userImage'] as String?,
      timestamp: map['timestamp'] as Timestamp?,
      contentText: map['contentText'] as String?,
      username: map['username'] as String,
      id: map['id'] as String,
      contentImage: map['contentImage'] as String,
      remainingTime: map['remainingTime'] as int,
      offer: map['offer'] as String?,
    );
  }
}
