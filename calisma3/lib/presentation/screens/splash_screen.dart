import 'package:calisma3/core/constants/paths.dart';
import 'package:calisma3/data/services/audio_player.dart';
import 'package:calisma3/presentation/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  final AudioPlayerService _audioPlayerService = AudioPlayerService();

  @override
  void initState() {
    super.initState();
    _initializeVideoAndNavigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeVideoAndNavigate() async {
    _controller = VideoPlayerController.asset(videoLogo);
    await _controller.initialize(); // Video yüklemesi tamamlandı
    setState(() {}); // Video başlatıldığında sayfayı güncelliyor
    _controller.play();
    await Future.delayed(const Duration(seconds: 2));

    await _audioPlayerService.playSound(audioSplash);
    _navigateToSignIn();
  }

  void _navigateToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
