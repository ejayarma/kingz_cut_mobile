import 'package:kingz_cut_mobile/models/media_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agency.g.dart';

@JsonSerializable()
class Agency {
  final int id;
  final String code;
  final String name;
  final String description;
  @JsonKey(name: 'contact_email')
  final String contactEmail;
  @JsonKey(name: 'contact_phone')
  final String contactPhone;
  final String address;
  final String status;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;
  final MediaData? logo;

  Agency({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.contactEmail,
    required this.contactPhone,
    required this.address,
    required this.status,
    required this.logo,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Agency.fromJson(Map<String, dynamic> json) => _$AgencyFromJson(json);
  Map<String, dynamic> toJson() => _$AgencyToJson(this);
}
