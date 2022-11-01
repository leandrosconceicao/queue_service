import 'package:just_audio/just_audio.dart';

class AudioService {
  static void playNotification() {
    final player = AudioPlayer();
    player.setAsset('audio/notification.mp3');
    player.play();
  }
}