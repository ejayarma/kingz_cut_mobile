// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StaffRatingImpl _$$StaffRatingImplFromJson(Map<String, dynamic> json) =>
    _$StaffRatingImpl(
      id: json['id'] as String,
      value: (json['value'] as num?)?.toDouble(),
      staffId: json['staffId'] as String?,
      appointmentId: json['appointmentId'] as String?,
      customerId: json['customerId'] as String?,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$StaffRatingImplToJson(_$StaffRatingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'staffId': instance.staffId,
      'appointmentId': instance.appointmentId,
      'customerId': instance.customerId,
      'comment': instance.comment,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
