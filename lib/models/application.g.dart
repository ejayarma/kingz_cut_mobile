// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application(
      id: (json['id'] as num?)?.toInt(),
      user_id: (json['user_id'] as num?)?.toInt(),
      service_id: (json['service_id'] as num?)?.toInt(),
      status: json['status'] as String?,
      submitted_documents:
          (json['submitted_documents'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      rejection_reason: json['rejection_reason'] as String?,
      submission_date: json['submission_date'] == null
          ? null
          : DateTime.parse(json['submission_date'] as String),
      processing_date: json['processing_date'] == null
          ? null
          : DateTime.parse(json['processing_date'] as String),
      completion_date: json['completion_date'] == null
          ? null
          : DateTime.parse(json['completion_date'] as String),
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ApplicationToJson(Application instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'service_id': instance.service_id,
      'status': instance.status,
      'submitted_documents': instance.submitted_documents,
      'rejection_reason': instance.rejection_reason,
      'submission_date': instance.submission_date?.toIso8601String(),
      'processing_date': instance.processing_date?.toIso8601String(),
      'completion_date': instance.completion_date?.toIso8601String(),
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
    };
