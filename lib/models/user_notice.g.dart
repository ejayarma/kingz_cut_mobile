// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserNotice _$UserNoticeFromJson(Map<String, dynamic> json) => UserNotice(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      message: json['message'] as String?,
      type: json['type'] as String?,
      priority: json['priority'] as String?,
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserNoticeToJson(UserNotice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'priority': instance.priority,
      'read_at': instance.readAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
