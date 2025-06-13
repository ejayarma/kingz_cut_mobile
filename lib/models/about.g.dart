// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'about.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AboutImpl _$$AboutImplFromJson(Map<String, dynamic> json) => _$AboutImpl(
  name: json['name'] as String,
  description: json['description'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  location: json['location'] as String,
  website: json['website'] as String,
  facebook: json['facebook'] as String,
  tiktok: json['tiktok'] as String,
  instagram: json['instagram'] as String,
  x: json['x'] as String,
  youtube: json['youtube'] as String,
  whatsapp: json['whatsapp'] as String,
  hours: json['hours'] as String,
  workingHours:
      (json['working-hours'] as List<dynamic>)
          .map((e) => WorkingHour.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$$AboutImplToJson(_$AboutImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'email': instance.email,
      'phone': instance.phone,
      'location': instance.location,
      'website': instance.website,
      'facebook': instance.facebook,
      'tiktok': instance.tiktok,
      'instagram': instance.instagram,
      'x': instance.x,
      'youtube': instance.youtube,
      'whatsapp': instance.whatsapp,
      'hours': instance.hours,
      'working-hours': instance.workingHours,
    };
