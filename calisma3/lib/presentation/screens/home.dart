import 'package:calisma3/core/constants/paths.dart';
import 'package:calisma3/data/models/post_model.dart';
import 'package:calisma3/presentation/widgets/fetch_data.dart';
import 'package:calisma3/presentation/widgets/life_cycle_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:calisma3/data/services/audio_player.dart';
import 'package:calisma3/presentation/screens/dashboard.dart';
import 'package:calisma3/presentation/widgets/custom_drawer.dart';
import 'package:calisma3/presentation/screens/my_auctions.dart';
import 'package:calisma3/presentation/screens/profile.dart';
import 'package:calisma3/presentation/screens/won_auctions.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<Home> {
  int _currentIndex = 0;
  bool isMusicSwitched = false;
  bool isAudioSwitched = false;
  List<PostModel> posts = [];
  final PageController _pageController = PageController();
  final AudioPlayerService _audioPlayerService = AudioPlayerService();
  final LifecycleService _lifecycleService = LifecycleService();

  final List<Widget> list = [
    const Dashboard(),
    const WonAuctions(),
    const MyAuctions(),
    const Profile()
  ];

  final List<String> titles = [
    "Dashboard",
    "Won Auctions",
    "My Auctions",
    "Profile"
  ];

  @override
  void initState() {
    fetchPosts(ref, onPostsFetched);
    _lifecycleService.init();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayerService.dispose();
    _lifecycleService.dispose();
    super.dispose();
  }

  void onPostsFetched(List<PostModel> fetchedPosts) {
    posts = fetchedPosts;
    _lifecycleService.setPosts(posts);
  }

  void onTap(int index) async {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
    await _audioPlayerService.playSound(audioImage);
  }

  void _showSettingsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool tempIsMusicSwitched = isMusicSwitched;
        bool tempIsAudioSwitched = isAudioSwitched;
        return AlertDialog(
          title: const Text('Settings'),
          content: StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      "Music : ",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    Switch(
                      value: tempIsMusicSwitched,
                      onChanged: (value) async {
                        setState(() {
                          tempIsMusicSwitched = value;
                        });
                        await _audioPlayerService.playSound(audioAll);
                      },
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Audio : ",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    Switch(
                      value: tempIsAudioSwitched,
                      onChanged: (value) async {
                        await _audioPlayerService.playSound(audioAll);
                        setState(() {
                          tempIsAudioSwitched = value;
                        });
                      },
                    )
                  ],
                ),
              ],
            );
          }),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () async {
                setState(() {
                  isMusicSwitched = tempIsMusicSwitched;
                  isAudioSwitched = tempIsAudioSwitched;
                });
                Navigator.of(context).pop();
                await _audioPlayerService.playSound(audioImage);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          titles[_currentIndex],
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await _audioPlayerService.playSound(audioImage);
              _showSettingsPopup(context);
            },
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) async {
          await _audioPlayerService.playSound(audioImage);
          setState(() {
            _currentIndex = index;
          });
        },
        children: list,
      ),
      drawer: const CustomDrawer(),
      drawerScrimColor: Colors.transparent,
      onDrawerChanged: (isOpened) async {
        if (isOpened) {
          await _audioPlayerService.playSound(audioImage);
        }
      },
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(homeDeactiveSvg, width: 24, height: 24),
            activeIcon: SvgPicture.asset(homeActiveSvg, width: 24, height: 24),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon:
                SvgPicture.asset(wonAuctionsDeactiveSvg, width: 24, height: 24),
            activeIcon:
                SvgPicture.asset(wonAuctionsActiveSvg, width: 24, height: 24),
            label: "Won",
          ),
          BottomNavigationBarItem(
            icon:
                SvgPicture.asset(myAuctionsDeactiveSvg, width: 24, height: 24),
            activeIcon:
                SvgPicture.asset(myAuctionsActiveSvg, width: 24, height: 24),
            label: "My",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(profileDeactiveSvg, width: 24, height: 24),
            activeIcon:
                SvgPicture.asset(profileActiveSvg, width: 24, height: 24),
            label: "Profile",
          ),
        ],
        iconSize: 24.0,
      ),
    );
  }
}
