import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';
import 'package:json_annotation/json_annotation.dart';

import 'items.dart';
part 'slideshow.g.dart';

@JsonSerializable()
class Slideshow extends Equatable {
  String? slideshowName;
  String? coverImagePath;
  String? coverSoundPath;
  List<Item>? items;
  static final logger = Logger();

  Slideshow({this.coverImagePath, this.coverSoundPath, this.items, this.slideshowName});

  factory Slideshow.fromJson(Map<String, dynamic> json) => _$SlideshowFromJson(json);

  Map<String, dynamic> toJson() => _$SlideshowToJson(this);

  factory Slideshow.fromString(String? source) {
    if (source == null) return Slideshow();
    Map<String, dynamic> map = json.decode(source) as Map<String, dynamic>;
    return Slideshow.fromJson(map);
  }

  @override
  String toString() {
    try {
      return jsonEncode(toJson());
    } catch (e) {
      logger.e('ERROR encoding to string $e');
      return '';
    }
  }

  @override
  List<Object?> get props => [slideshowName];
}
