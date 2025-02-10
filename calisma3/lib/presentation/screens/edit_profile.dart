import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calisma3/presentation/widgets/user_info_form_profile_edit.dart';
import 'package:calisma3/data/services/audio_player.dart';
import 'package:calisma3/core/constants/colors.dart';
import 'package:calisma3/core/constants/paths.dart';
import 'package:calisma3/core/utils/sizes.dart';
import 'package:calisma3/data/repositories/profile_controller.dart';
import 'package:calisma3/presentation/screens/home.dart';
import 'package:calisma3/data/models/post_model.dart';
import 'package:calisma3/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  File? _image;
  List<PostModel> posts = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    fetchPosts();
  }

  Future<void> _loadUserData() async {
    final userModel = await ref.read(profileControllerProvider).getUser();
    setState(() {
      _nameController.text = userModel.name;
      _lastNameController.text = userModel.surname;
      _userNameController.text = userModel.username;
      _emailController.text = userModel.email;
      _passwordController.text = userModel.password;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> fetchPosts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("posts").get();

    List<PostModel> fetchedPosts = [];
    for (var doc in querySnapshot.docs) {
      fetchedPosts.add(PostModel.fromMap(doc.data() as Map<String, dynamic>));
    }

    setState(() {
      posts = fetchedPosts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Düzenle")),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<UserModel>(
        future: ref.read(profileControllerProvider).getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Bir hata oluştu'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Veri bulunamadı'));
          }

          final userModel = snapshot.data!;
          return Padding(
            padding: paddingAll(15),
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: vertical(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //^ Profile Photo
                      Padding(
                        padding: vertical(10),
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            backgroundColor: profilePhotoCircleColor,
                            radius: 70,
                            child: CircleAvatar(
                              radius: 68,
                              backgroundImage: _image == null
                                  ? CachedNetworkImageProvider(
                                      userModel.profilePhoto!)
                                  : FileImage(_image!) as ImageProvider,
                            ),
                          ),
                        ),
                      ),
                      //^ TextformField's
                      UserInfoFormProfileedit(
                        nameController: _nameController,
                        lastNameController: _lastNameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        usernameController: _userNameController,
                      ),
                      //^ Save Button
                      Padding(
                        padding: vertical(10),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              userModel.name = _nameController.text;
                              userModel.surname = _lastNameController.text;
                              userModel.email = _emailController.text;
                              userModel.username = _userNameController.text;
                              userModel.password = _passwordController.text;

                              try {
                                await ref
                                    .read(profileControllerProvider)
                                    .updateUser(
                                      userModel,
                                      posts,
                                      profilePhoto: _image,
                                    );

                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Profil başarıyla güncellendi'),
                                  ),
                                );
                                Navigator.pushAndRemoveUntil(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Home()),
                                  (route) => false,
                                );
                                await _audioPlayerService.playSound(audioImage);
                              } catch (e, stackTrace) {
                                if (kDebugMode) {
                                  print('Hata: $e');
                                }
                                if (kDebugMode) {
                                  print('Hata izi: $stackTrace');
                                }
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Profil güncellenirken hata oluştu: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          color: profilePhotoCircleColor,
                          child: Padding(
                            padding: vertical(10),
                            child: const Text(
                              "Kaydet",
                              style: TextStyle(color: containerColor),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
