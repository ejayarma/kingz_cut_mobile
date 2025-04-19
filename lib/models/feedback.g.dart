// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Feedback _$FeedbackFromJson(Map<String, dynamic> json) => Feedback(
      id: (json['id'] as num?)?.toInt(),
      user_id: (json['user_id'] as num?)?.toInt(),
      service_id: (json['service_id'] as num?)?.toInt(),
      feedback_type: json['feedback_type'] as String?,
      description: json['description'] as String?,
      rating: (json['rating'] as num?)?.toInt(),
      is_resolved: json['is_resolved'] as bool?,
      admin_response: json['admin_response'] as String?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$FeedbackToJson(Feedback instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'service_id': instance.service_id,
      'feedback_type': instance.feedback_type,
      'description': instance.description,
      'rating': instance.rating,
      'is_resolved': instance.is_resolved,
      'admin_response': instance.admin_response,
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
    };
