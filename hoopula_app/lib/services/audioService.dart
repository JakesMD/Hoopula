import 'package:just_audio/just_audio.dart';

/// The sevice that controls the audio.
class AudioService {
  final AudioPlayer _player = AudioPlayer();

  /// Plays the audio from the soundId.
  Future<void> play(String soundId) async {
    try {
      await _player.setAsset('assets/audio/$soundId.mp3');
      await _player.play();
    } catch (error) {}
  }

  /// Disposes the [AudioPlayer].
  Future<void> dispose() async {
    try {
      await _player.dispose();
    } catch (error) {}
  }
}
