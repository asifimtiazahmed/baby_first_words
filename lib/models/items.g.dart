// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      imagePath: json['imagePath'] as String?,
      name: json['name'] as String?,
      soundPath: json['soundPath'] as String?,
      itemIndex: json['itemIndex'] as int?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'name': instance.name,
      'imagePath': instance.imagePath,
      'soundPath': instance.soundPath,
      'itemIndex': instance.itemIndex,
    };
