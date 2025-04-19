import 'package:json_annotation/json_annotation.dart';

import 'agency.dart';
import 'media_data.dart';

part 'service_category.g.dart';

@JsonSerializable()
class ServiceCategory {
  final int id;
  @JsonKey(name: 'agency_id')
  final int agencyId;
  final String name;
  final String? description;
  @JsonKey(includeIfNull: false) // Don't include in JSON if null
  final MediaData? logo;
  final Agency? agency;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  ServiceCategory({
    required this.id,
    required this.agencyId,
    required this.name,
    this.description,
    this.logo,
    required this.agency,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      _$ServiceCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceCategoryToJson(this);
}
