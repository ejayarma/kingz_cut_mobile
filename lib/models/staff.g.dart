// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffImpl _$$StaffImplFromJson(Map<String, dynamic> json) => _$StaffImpl(
      id: json['id'] as String,
      active: json['active'] as bool,
      email: json['email'] as String,
      rating: (json['rating'] as num?)?.toDouble(),
      imageUrl: json['image'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      role: json['role'] as String,
      serviceIds:
          (json['services'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$StaffImplToJson(_$StaffImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'active': instance.active,
      'email': instance.email,
      'rating': instance.rating,
      'image': instance.imageUrl,
      'name': instance.name,
      'phone': instance.phone,
      'role': instance.role,
      'services': instance.serviceIds,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'userId': instance.userId,
    };
