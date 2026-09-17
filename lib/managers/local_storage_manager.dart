import 'dart:async';

import 'package:baby_f_words/models/slideshow.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recase/recase.dart';

enum Status { success, failure }

class StorageManager {
  final logger = Logger();

  writeSlideshow(Slideshow slideshow) async {
    final prefs = await SharedPreferences.getInstance();
    String keyValue = slideshow.slideshowName!.paramCase;
    logger.i('Writing slideshow $keyValue to memory');
    final slideshowString = slideshow.toString();
    await prefs.setString(keyValue, slideshowString);
  }

  Future<Slideshow> readSlideshow({required String slideshowName}) async {
    Slideshow result = Slideshow();
    final prefs = await SharedPreferences.getInstance();
    String keyValue = slideshowName.paramCase;
    logger.i('Attempting to read $keyValue slideshow from memory');
    try {
      String? slideshowString = prefs.getString(keyValue);
      if (slideshowString != null) {
        result = Slideshow.fromString(slideshowString);
      }
    } catch (e) {
      logger.e('Error reading slideshow $e');
    }
    return result;
  }

  Future<Status> eraseSlideshow({required String slideshowName}) async {
    final prefs = await SharedPreferences.getInstance();
    String keyValue = slideshowName.paramCase;
    logger.i('Verifying slideshow $keyValue is stored in memory');
    try {
      String? slideshowString = prefs.getString(keyValue);
      if (slideshowString != null) {
        logger.i('Erasing the slideshow $slideshowName');
        await prefs.remove(keyValue);
        return Status.success;
      } else {
        logger.e('slideshow $slideshowName not found');
        return Status.failure;
      }
    } catch (e) {
      logger.e('Error erasing slideshow $e');
      return Status.failure;
    }
  }
}
