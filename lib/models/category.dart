import 'package:json_annotation/json_annotation.dart';

import 'agency.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final int? id;
  @JsonKey(name: 'agency_id')
  final int? agencyId;
  final String? name;
  final String? description;
  final Agency? agency;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  Category({
    this.id,
    this.agencyId,
    this.name,
    this.description,
    this.agency,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);


  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

