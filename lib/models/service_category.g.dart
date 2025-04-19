// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceCategory _$ServiceCategoryFromJson(Map<String, dynamic> json) =>
    ServiceCategory(
      id: (json['id'] as num).toInt(),
      agencyId: (json['agency_id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      logo: json['logo'] == null
          ? null
          : MediaData.fromJson(json['logo'] as Map<String, dynamic>),
      agency: json['agency'] == null
          ? null
          : Agency.fromJson(json['agency'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ServiceCategoryToJson(ServiceCategory instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'agency_id': instance.agencyId,
    'name': instance.name,
    'description': instance.description,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('logo', instance.logo);
  val['agency'] = instance.agency;
  val['created_at'] = instance.createdAt.toIso8601String();
  val['updated_at'] = instance.updatedAt.toIso8601String();
  return val;
}
