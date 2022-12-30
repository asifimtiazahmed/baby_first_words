import 'items.dart';

class Slideshow {
  String? slideshowName;
  String? coverImagePath;
  String? coverSoundPath;
  List<Items>? items;

  Slideshow({this.coverImagePath, this.coverSoundPath, this.items, this.slideshowName});
}
