// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceCategoryImpl _$$ServiceCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceCategoryImpl(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ServiceCategoryImplToJson(
        _$ServiceCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
