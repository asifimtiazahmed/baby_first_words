import 'package:firebase_storage/firebase_storage.dart';

enum FirebaseStorageFolders {
  images,
  sounds,
}

extension FirebaseStorageFoldersExt on FirebaseStorageFolders {
  String get pathName {
    switch (this) {
      case FirebaseStorageFolders.images:
        return 'images';
      case FirebaseStorageFolders.sounds:
        return 'sounds';
    }
  }
}

class FirebaseStorageManager {
  final _storage = FirebaseStorage.instance;

  // MARK: - Functions
  Future<List<String>> getListOfFilesAtPath({required List<String> pathComponents}) async {
    final path = pathComponents.join('/');
    var pathItems = <String>[];

    try {
      final results = await _storage.ref(path).listAll();
      for (var reference in results.items) {
        pathItems.add(reference.fullPath);
      }

      return pathItems;
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<List<String>> generateFileList() async {
    var result = await _storage.ref().listAll();
    List<String> folderList = result.prefixes.map((e) => e.fullPath).toList();
    return folderList;
  }

  Future<String> getDownloadUrl(String fileLocationInStorage) async {
    String baseUrl = 'gs://baby-first-words.appspot.com/';
    return await _storage.refFromURL(baseUrl + fileLocationInStorage).getDownloadURL();
  }
}
