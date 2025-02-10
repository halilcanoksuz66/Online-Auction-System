import 'package:cached_network_image/cached_network_image.dart';
import 'package:calisma3/core/constants/paths.dart';
import 'package:calisma3/data/services/audio_player.dart';
import 'package:calisma3/data/repositories/profile_controller.dart';
import 'package:calisma3/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:calisma3/presentation/screens/sign_in.dart';
import 'package:calisma3/presentation/screens/dashboard.dart';
import 'package:calisma3/presentation/screens/my_auctions.dart';
import 'package:calisma3/presentation/screens/profile.dart';
import 'package:calisma3/presentation/screens/won_auctions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomDrawer extends ConsumerStatefulWidget {
  const CustomDrawer({super.key});

  @override
  ConsumerState<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends ConsumerState<CustomDrawer> {
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  late Future<UserModel> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = ref.read(profileControllerProvider).getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<UserModel>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userModel = snapshot.data!;
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: userModel.profilePhoto != null &&
                                  userModel.profilePhoto!.isNotEmpty
                              ? CachedNetworkImageProvider(
                                  userModel.profilePhoto!)
                              : const AssetImage('assets/default_profile.png')
                                  as ImageProvider, // Varsayılan bir profil fotoğrafı ekleyin
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          'Welcome, ${"${userModel.name}${userModel.surname}"}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 18.0),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.dashboard),
                    title: const Text('Dashboard'),
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Dashboard()),
                      );
                      await _audioPlayerService.playSound(audioAll);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.shopping_cart),
                    title: const Text('Won Auctions'),
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WonAuctions()),
                      );
                      await _audioPlayerService.playSound(audioAll);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.list),
                    title: const Text('My Auctions'),
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyAuctions()),
                      );
                      await _audioPlayerService.playSound(audioAll);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    onTap: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()),
                      );
                      await _audioPlayerService.playSound(audioAll);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Sign Out'),
                    onTap: () async {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                        (Route<dynamic> route) => false,
                      );
                      await _audioPlayerService.playSound(audioAll);
                    },
                  ),
                ],
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('An error occurred'));
            }
          }),
    );
  }
}
