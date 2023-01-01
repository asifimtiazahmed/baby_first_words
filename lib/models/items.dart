import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';
part 'items.g.dart';

@JsonSerializable()
class Item extends Equatable {
  String? name;
  String? imagePath;
  String? soundPath;
  int? itemIndex;

  static final logger = Logger();

  Item({this.imagePath, this.name, this.soundPath, this.itemIndex});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);

  factory Item.fromString(String? source) {
    if (source == null) return Item();
    Map<String, dynamic> map = json.decode(source) as Map<String, dynamic>;
    return Item.fromJson(map);
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
  List<Object?> get props => [name];
}
