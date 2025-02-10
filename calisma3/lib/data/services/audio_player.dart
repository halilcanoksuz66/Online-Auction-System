import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSound(String path) async {
    await _audioPlayer.play(AssetSource(path));
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
