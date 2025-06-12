// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppConfigImpl _$$AppConfigImplFromJson(Map<String, dynamic> json) =>
    _$AppConfigImpl(
      userType: $enumDecode(_$UserTypeEnumMap, json['userType']),
      hasOnboarded: json['hasOnboarded'] as bool,
    );

Map<String, dynamic> _$$AppConfigImplToJson(_$AppConfigImpl instance) =>
    <String, dynamic>{
      'userType': _$UserTypeEnumMap[instance.userType]!,
      'hasOnboarded': instance.hasOnboarded,
    };

const _$UserTypeEnumMap = {
  UserType.customer: 'customer',
  UserType.barber: 'barber',
};
