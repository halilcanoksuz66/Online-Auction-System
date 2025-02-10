import 'dart:io';
import 'package:calisma3/core/constants/paths.dart';
import 'package:calisma3/data/services/audio_player.dart';
import 'package:calisma3/data/repositories/dashboard_controller.dart';
import 'package:calisma3/data/repositories/profile_controller.dart';
import 'package:calisma3/presentation/screens/home.dart';
import 'package:calisma3/data/models/post_model.dart';
import 'package:calisma3/data/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CreatePost extends ConsumerStatefulWidget {
  CreatePost({super.key});
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  @override
  ConsumerState<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends ConsumerState<CreatePost> {
  File? _image;
  bool visible = false;
  late final PostModel postModel;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentTextController = TextEditingController();
  final StorageService _storageService = StorageService();

  void onPressed() async {
    if (_formKey.currentState!.validate() && _image != null) {
      final user = await ref.read(profileControllerProvider).getUser();
      final imageUrl = await _storageService.uploadImage(_image!);

      final postId = FirebaseFirestore.instance.collection('posts').doc().id;

      postModel = PostModel(
          id: postId,
          uid: user.uid,
          username: user.username,
          userImage: user.profilePhoto,
          timestamp: Timestamp.now(),
          contentText: _contentTextController.text,
          contentImage: imageUrl,
          remainingTime: 120);

      visible = true;
      await ref
          .read(dashboardControllerProvider)
          .storePostInfoToFirebase(postModel)
          .then((_) async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Home()),
          (route) => false,
        );
        await widget._audioPlayerService.playSound(audioAll);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        backgroundColor: Colors.purple,
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 40),
                TextFormField(
                  controller: _contentTextController,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    hintStyle: const TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Please enter your title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Content is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () async {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _image = File(pickedFile.path);
                      });
                    }
                  },
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: _image == null
                        ? const Center(
                            child: Text(
                              'Tap to select an image',
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    return MaterialButton(
                      onPressed: onPressed,
                      minWidth: double.infinity,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.deepOrange,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "Create",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Visibility(
                  visible: visible,
                  child: const CircularProgressIndicator(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
