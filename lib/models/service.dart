import 'package:json_annotation/json_annotation.dart';
import 'service_category.dart';
part 'service.g.dart';

@JsonSerializable()
class Service {
  final int? id;
  @JsonKey(name: 'category_id')
  final int? categoryId;
  final String? code;
  final String? name;
  final String? description;
  final String? amount;
  final String? status;
  final ServiceCategory? category;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;

  Service({
    this.id,
    this.categoryId,
    this.code,
    this.name,
    this.description,
    this.amount,
    this.status,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}