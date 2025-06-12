// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffImpl _$$StaffImplFromJson(Map<String, dynamic> json) => _$StaffImpl(
      active: json['active'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      email: json['email'] as String,
      id: json['id'] as String,
      imageUrl: json['image'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      serviceIds:
          (json['services'] as List<dynamic>).map((e) => e as String).toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      url: json['url'] as String?,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$StaffImplToJson(_$StaffImpl instance) =>
    <String, dynamic>{
      'active': instance.active,
      'createdAt': instance.createdAt.toIso8601String(),
      'email': instance.email,
      'id': instance.id,
      'image': instance.imageUrl,
      'name': instance.name,
      'phone': instance.phone,
      'role': instance.role,
      'services': instance.serviceIds,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'url': instance.url,
      'userId': instance.userId,
    };
