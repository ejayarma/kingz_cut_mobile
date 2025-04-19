// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Agency _$AgencyFromJson(Map<String, dynamic> json) => Agency(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      contactEmail: json['contact_email'] as String,
      contactPhone: json['contact_phone'] as String,
      address: json['address'] as String,
      status: json['status'] as String,
      logo: json['logo'] == null
          ? null
          : MediaData.fromJson(json['logo'] as Map<String, dynamic>),
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

Map<String, dynamic> _$AgencyToJson(Agency instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description,
      'contact_email': instance.contactEmail,
      'contact_phone': instance.contactPhone,
      'address': instance.address,
      'status': instance.status,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'logo': instance.logo,
    };
