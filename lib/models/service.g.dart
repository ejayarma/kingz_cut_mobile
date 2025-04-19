// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
      id: (json['id'] as num?)?.toInt(),
      categoryId: (json['category_id'] as num?)?.toInt(),
      code: json['code'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      amount: json['amount'] as String?,
      status: json['status'] as String?,
      category: json['category'] == null
          ? null
          : ServiceCategory.fromJson(json['category'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'id': instance.id,
      'category_id': instance.categoryId,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'amount': instance.amount,
      'status': instance.status,
      'category': instance.category,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
