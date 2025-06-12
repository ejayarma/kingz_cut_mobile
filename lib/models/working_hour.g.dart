// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'working_hour.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WorkingHourImpl _$$WorkingHourImplFromJson(Map<String, dynamic> json) =>
    _$WorkingHourImpl(
      dayName: json['dayName'] as String,
      shortName: json['shortName'] as String,
      openingTime: json['openingTime'] as String,
      closingTime: json['closingTime'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$$WorkingHourImplToJson(_$WorkingHourImpl instance) =>
    <String, dynamic>{
      'dayName': instance.dayName,
      'shortName': instance.shortName,
      'openingTime': instance.openingTime,
      'closingTime': instance.closingTime,
      'isActive': instance.isActive,
    };
