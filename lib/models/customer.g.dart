// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomerImpl _$$CustomerImplFromJson(Map<String, dynamic> json) =>
    _$CustomerImpl(
      id: json['id'] as String,
      active: json['active'] as bool,
      email: json['email'] as String,
      fcmToken: json['fcmToken'] as String?,
      imageUrl: json['image'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CustomerImplToJson(_$CustomerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'active': instance.active,
      'email': instance.email,
      'fcmToken': instance.fcmToken,
      'image': instance.imageUrl,
      'name': instance.name,
      'phone': instance.phone,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
