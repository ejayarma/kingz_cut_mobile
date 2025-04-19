// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaData _$MediaDataFromJson(Map<String, dynamic> json) => MediaData(
      name: json['name'] as String,
      fileName: json['file_name'] as String,
      size: (json['size'] as num).toInt(),
      humanReadableSize: json['human_readable_size'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$MediaDataToJson(MediaData instance) => <String, dynamic>{
      'name': instance.name,
      'file_name': instance.fileName,
      'size': instance.size,
      'human_readable_size': instance.humanReadableSize,
      'url': instance.url,
    };
