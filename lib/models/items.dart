import 'package:audioplayers/audioplayers.dart';

class Items {
  String? name;
  String? imagePath;
  String? soundPath;
  int? itemIndex;

  Items({this.imagePath, this.name, this.soundPath, this.itemIndex});

  @override
  String toString() {
    return 'Name: $name\n'
        'ImagePath: $imagePath\n'
        'SoundPath: $soundPath\n'
        'Index: $itemIndex\n';
  }
}
