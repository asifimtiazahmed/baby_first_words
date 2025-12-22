import 'package:audioplayers/audioplayers.dart';
import 'package:baby_f_words/managers/assets.dart';
import 'package:baby_f_words/managers/firebase_storage_manager.dart';
import 'package:logger/logger.dart';

class GameAudioManager {
  final AudioPlayer _player = AudioPlayer();
  final Logger _logger = Logger();
  final FirebaseStorageManager _storageManager = FirebaseStorageManager();
  final String slideshowName;

  GameAudioManager({required this.slideshowName});

  Future<void> playWellDone() async {
    try {
      await _player.stop();
      final url = await _storageManager.getDownloadUrl('$slideshowName/game/well_done.mp3');
      await _player.play(UrlSource(url));
    } catch (e, stack) {
      _logger.e("Error playing well done sound", error: e, stackTrace: stack);
    }
  }

  Future<void> playTryAgain() async {
    try {
      await _player.stop();
      final url = await _storageManager.getDownloadUrl('$slideshowName/game/try_again.mp3');
      await _player.play(UrlSource(url));
    } catch (e, stack) {
      _logger.e("Error playing try again sound", error: e, stackTrace: stack);
    }
  }

  Future<void> playFindThe() async {
    try {
      await _player.stop();
      final url = await _storageManager.getDownloadUrl('$slideshowName/game/find_the.mp3');
      await _player.play(UrlSource(url));
    } catch (e, stack) {
      _logger.e("Error playing find the sound", error: e, stackTrace: stack);
    }
  }

  Future<void> playSuccessHarp() async {
    try {
      await _player.stop();
      await _player.play(AssetSource(Assets.successHarp));
    } catch (e, stack) {
      _logger.e("Error playing success harp sound", error: e, stackTrace: stack);
    }
  }

  Future<void> playSound(String url) async {
    try {
      await _player.stop();
      await _player.play(UrlSource(url));
    } catch (e, stack) {
      _logger.e("Error playing sound: $url", error: e, stackTrace: stack);
    }
  }

  void dispose() {
    _player.dispose();
  }
}
