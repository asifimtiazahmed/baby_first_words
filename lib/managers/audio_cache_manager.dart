import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class AudioCacheManager {
  static final AudioCacheManager instance = AudioCacheManager._internal();
  AudioCacheManager._internal();

  final Logger _logger = Logger();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Directory? _cacheDir;

  Future<Directory> get cacheDir async {
    if (_cacheDir != null) return _cacheDir!;
    final docsDir = await getApplicationDocumentsDirectory();
    _cacheDir = Directory('${docsDir.path}/audio_cache');
    if (!await _cacheDir!.exists()) {
      await _cacheDir!.create(recursive: true);
    }
    return _cacheDir!;
  }

  /// Extracts a clean local filename from a URL or storage path
  String _getFileName(String pathOrUrl) {
    String cleanName = pathOrUrl.split('?').first;
    cleanName = cleanName.split('/').last;
    cleanName = cleanName
        .replaceAll(RegExp(r'^gs://baby-first-words\.appspot\.com/'), '')
        .replaceAll(RegExp(r'[^\w\.-]'), '_');
    if (!cleanName.endsWith('.mp3') && !cleanName.endsWith('.wav')) {
      cleanName += '.mp3';
    }
    return cleanName;
  }

  /// Downloads and caches an audio file if not already cached locally.
  /// Returns the local file path.
  Future<String> getLocalAudioPath(String fileLocationOrUrl) async {
    if (fileLocationOrUrl.isEmpty) return '';

    // 1. If it's already a local file path that exists on disk right now
    if (!fileLocationOrUrl.startsWith('http') &&
        !fileLocationOrUrl.startsWith('gs://') &&
        File(fileLocationOrUrl).existsSync()) {
      return fileLocationOrUrl;
    }

    try {
      final dir = await cacheDir;
      final fileName = _getFileName(fileLocationOrUrl);
      final localFile = File('${dir.path}/$fileName');

      // 2. Check if file is already cached in the current audio_cache directory
      if (await localFile.exists() && (await localFile.length()) > 0) {
        return localFile.path;
      }

      // 3. If fileLocationOrUrl is an old/dead local path from a previous simulator run, check if its basename exists in current cacheDir
      if ((fileLocationOrUrl.startsWith('/') || fileLocationOrUrl.startsWith('file:')) && !fileLocationOrUrl.startsWith('http')) {
        final baseName = fileLocationOrUrl.split('/').last.split('?').first;
        final candidate = File('${dir.path}/$baseName');
        if (await candidate.exists() && (await candidate.length()) > 0) {
          return candidate.path;
        }
        _logger.w("Dead local file path cannot be fetched from storage: $fileLocationOrUrl");
        return '';
      }

      _logger.i("Downloading audio for caching: $fileLocationOrUrl -> ${localFile.path}");

      if (fileLocationOrUrl.startsWith('http://') || fileLocationOrUrl.startsWith('https://')) {
        final response = await http.get(Uri.parse(fileLocationOrUrl));
        if (response.statusCode == 200) {
          await localFile.writeAsBytes(response.bodyBytes);
          return localFile.path;
        }
      } else if (fileLocationOrUrl.startsWith('gs://') || !fileLocationOrUrl.contains('/')) {
        final ref = fileLocationOrUrl.startsWith('gs://')
            ? _storage.refFromURL(fileLocationOrUrl)
            : _storage.ref(fileLocationOrUrl);

        final downloadUrl = await ref.getDownloadURL();
        final response = await http.get(Uri.parse(downloadUrl));
        if (response.statusCode == 200) {
          await localFile.writeAsBytes(response.bodyBytes);
          return localFile.path;
        }
      }
    } catch (e, stack) {
      _logger.e("Error caching audio $fileLocationOrUrl", error: e, stackTrace: stack);
    }

    return fileLocationOrUrl.startsWith('http') ? fileLocationOrUrl : '';
  }

  /// Synchronously returns local file path if cached, or null if not cached yet
  Future<String?> getCachedPathIfExists(String fileLocationOrUrl) async {
    try {
      final dir = await cacheDir;
      final fileName = _getFileName(fileLocationOrUrl);
      final localFile = File('${dir.path}/$fileName');
      if (await localFile.exists() && (await localFile.length()) > 0) {
        return localFile.path;
      }
    } catch (_) {}
    return null;
  }
}
