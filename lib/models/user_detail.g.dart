// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entity _$EntityFromJson(Map<String, dynamic> json) => Entity(
      type: json['type'] as String?,
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$EntityToJson(Entity instance) => <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'name': instance.name,
    };

UserDetail _$UserDetailFromJson(Map<String, dynamic> json) => UserDetail(
      id: (json['id'] as num?)?.toInt(),
      mustChangePassword: json['must_change_password'] as bool?,
      status: json['status'] as String?,
      name: json['name'] as String?,
      firstName: json['first_name'] as String?,
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String?,
      username: json['username'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      entity: json['entity'] == null
          ? null
          : Entity.fromJson(json['entity'] as Map<String, dynamic>),
      token: json['token'] as String?,
      requiresOtp: json['requires_otp'] as bool?,
      profilePicture: json['profile_picture'] == null
          ? null
          : MediaData.fromJson(json['profile_picture'] as Map<String, dynamic>),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserDetailToJson(UserDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'must_change_password': instance.mustChangePassword,
      'status': instance.status,
      'name': instance.name,
      'first_name': instance.firstName,
      'middle_name': instance.middleName,
      'last_name': instance.lastName,
      'username': instance.username,
      'phone': instance.phone,
      'email': instance.email,
      'entity': instance.entity,
      'token': instance.token,
      'requires_otp': instance.requiresOtp,
      'profile_picture': instance.profilePicture,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
