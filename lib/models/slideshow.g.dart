// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slideshow.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slideshow _$SlideshowFromJson(Map<String, dynamic> json) => Slideshow(
      coverImagePath: json['coverImagePath'] as String?,
      coverSoundPath: json['coverSoundPath'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      slideshowName: json['slideshowName'] as String?,
    );

Map<String, dynamic> _$SlideshowToJson(Slideshow instance) => <String, dynamic>{
      'slideshowName': instance.slideshowName,
      'coverImagePath': instance.coverImagePath,
      'coverSoundPath': instance.coverSoundPath,
      'items': instance.items,
    };
