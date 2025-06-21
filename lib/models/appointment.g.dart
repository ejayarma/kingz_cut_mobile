// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentImpl _$$AppointmentImplFromJson(Map<String, dynamic> json) =>
    _$AppointmentImpl(
      id: json['id'] as String?,
      customerId: json['customerId'] as String,
      reviewed: json['reviewed'] as bool? ?? false,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      staffId: json['staffId'] as String,
      status: $enumDecodeNullable(_$AppointmentStatusEnumMap, json['status']) ??
          AppointmentStatus.pending,
      serviceIds: (json['serviceIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
      totalTimeframe: (json['totalTimeframe'] as num?)?.toInt(),
      bookingType:
          $enumDecodeNullable(_$BookingTypeEnumMap, json['bookingType']),
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'reviewed': instance.reviewed,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'staffId': instance.staffId,
      'status': _$AppointmentStatusEnumMap[instance.status]!,
      'serviceIds': instance.serviceIds,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'totalPrice': instance.totalPrice,
      'totalTimeframe': instance.totalTimeframe,
      'bookingType': _$BookingTypeEnumMap[instance.bookingType],
    };

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.pending: 'pending',
  AppointmentStatus.confirmed: 'confirmed',
  AppointmentStatus.cancelled: 'cancelled',
  AppointmentStatus.completed: 'completed',
  AppointmentStatus.noShow: 'noShow',
};

const _$BookingTypeEnumMap = {
  BookingType.homeService: 'homeService',
  BookingType.walkInService: 'walkInService',
};
