import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:baby_f_words/managers/assets.dart';
import 'package:baby_f_words/managers/audio_cache_manager.dart';
import 'package:baby_f_words/managers/firebase_storage_manager.dart';
import 'package:logger/logger.dart';

class GameAudioManager {
  final AudioPlayer _voicePlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final Logger _logger = Logger();
  final FirebaseStorageManager _storageManager = FirebaseStorageManager();
  final AudioCacheManager _cacheManager = AudioCacheManager.instance;
  final String slideshowName;

  GameAudioManager({required this.slideshowName});

  Future<void> _playSource(AudioPlayer player, Source source) async {
    await player.stop();
    await player.play(source, mode: PlayerMode.lowLatency);
  }

  Future<void> _playPathOrUrl(AudioPlayer player, String location) async {
    if (location.isEmpty) return;

    if (File(location).existsSync()) {
      await _playSource(player, DeviceFileSource(location));
      return;
    }

    final localPath = await _cacheManager.getLocalAudioPath(location);
    if (File(localPath).existsSync()) {
      await _playSource(player, DeviceFileSource(localPath));
    } else if (localPath.startsWith('http://') || localPath.startsWith('https://')) {
      await _playSource(player, UrlSource(localPath));
    } else if (location.startsWith('http://') || location.startsWith('https://')) {
      await _playSource(player, UrlSource(location));
    }
  }

  Future<void> playWellDone() async {
    try {
      final storagePath = '$slideshowName/game/well_done.mp3';
      final url = await _storageManager.getDownloadUrl(storagePath).catchError((_) => storagePath);
      await _playPathOrUrl(_voicePlayer, url);
    } catch (e, stack) {
      _logger.e("Error playing well done sound", error: e, stackTrace: stack);
    }
  }

  Future<void> playTryAgain() async {
    try {
      await playWrongSfx();
      final storagePath = '$slideshowName/game/try_again.mp3';
      final url = await _storageManager.getDownloadUrl(storagePath).catchError((_) => storagePath);
      await _playPathOrUrl(_voicePlayer, url);
    } catch (e, stack) {
      _logger.e("Error playing try again sound", error: e, stackTrace: stack);
    }
  }

  Future<void> playFindThe() async {
    try {
      final storagePath = '$slideshowName/game/find_the.mp3';
      final url = await _storageManager.getDownloadUrl(storagePath).catchError((_) => storagePath);
      await _playPathOrUrl(_voicePlayer, url);
    } catch (e, stack) {
      _logger.e("Error playing find the sound", error: e, stackTrace: stack);
    }
  }

  Future<void> playSuccessHarp() async {
    try {
      await _playSource(_sfxPlayer, AssetSource(Assets.successHarp));
    } catch (e, stack) {
      _logger.e("Error playing success harp sound", error: e, stackTrace: stack);
    }
  }

  Future<void> playWrongSfx() async {
    try {
      await _playSource(_sfxPlayer, AssetSource(Assets.sfxWrong));
    } catch (e, stack) {
      _logger.e("Error playing wrong SFX sound", error: e, stackTrace: stack);
    }
  }

  Future<void> playSound(String urlOrPath) async {
    try {
      await _playPathOrUrl(_voicePlayer, urlOrPath);
    } catch (e, stack) {
      _logger.e("Error playing sound: $urlOrPath", error: e, stackTrace: stack);
    }
  }

  void dispose() {
    _voicePlayer.dispose();
    _sfxPlayer.dispose();
  }
}
