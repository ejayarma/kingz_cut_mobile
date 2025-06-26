// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


Map<String, dynamic> _$CreateNotificationRequestToJson(
        CreateNotificationRequest instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'message': instance.message,
      'title': instance.title,
      'type': instance.type,
    };

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      uid: json['uid'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: json['type'] as String? ?? 'general',
      read: json['read'] as bool? ?? false,
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'title': instance.title,
      'message': instance.message,
      'type': instance.type,
      'read': instance.read,
      'readAt': instance.readAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$NotificationsResponseImpl _$$NotificationsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationsResponseImpl(
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$NotificationsResponseImplToJson(
        _$NotificationsResponseImpl instance) =>
    <String, dynamic>{
      'notifications': instance.notifications,
    };

_$CreateNotificationRequestImpl _$$CreateNotificationRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateNotificationRequestImpl(
      uid: json['uid'] as String,
      message: json['message'] as String,
      title: json['title'] as String?,
      type: json['type'] as String? ?? 'general',
    );

Map<String, dynamic> _$$CreateNotificationRequestImplToJson(
        _$CreateNotificationRequestImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'message': instance.message,
      'title': instance.title,
      'type': instance.type,
    };
