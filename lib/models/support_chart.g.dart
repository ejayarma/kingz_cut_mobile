// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_chart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportChat _$SupportChatFromJson(Map<String, dynamic> json) => SupportChat(
      id: (json['id'] as num?)?.toInt(),
      user_id: (json['user_id'] as num?)?.toInt(),
      message: json['message'] as String?,
      is_user_message: json['is_user_message'] as bool?,
      is_read: json['is_read'] as bool?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$SupportChatToJson(SupportChat instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'message': instance.message,
      'is_user_message': instance.is_user_message,
      'is_read': instance.is_read,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
    };
