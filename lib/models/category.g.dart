// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: (json['id'] as num?)?.toInt(),
      agencyId: (json['agency_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      agency: json['agency'] == null
          ? null
          : Agency.fromJson(json['agency'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'agency_id': instance.agencyId,
      'name': instance.name,
      'description': instance.description,
      'agency': instance.agency,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
