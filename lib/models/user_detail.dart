// ignore_for_file: non_constant_identifier_names

import 'package:kingz_cut_mobile/models/media_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_detail.g.dart';

@JsonSerializable()
class Entity {
  final String? type;
  final int? id; // Make id nullable by adding ?
  final String? name;

  Entity({
    this.type,
    this.id, // Remove required since it's nullable
    this.name,
  });

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);
  Map<String, dynamic> toJson() => _$EntityToJson(this);
}

@JsonSerializable()
class UserDetail {
  final int? id;
  @JsonKey(name: 'must_change_password')
  final bool? mustChangePassword;
  final String? status;
  final String? name;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'middle_name')
  final String? middleName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final String? username;
  final String? phone;
  final String? email;
  final Entity? entity;
  final String? token;
  @JsonKey(name: 'requires_otp')
  final bool? requiresOtp;
  @JsonKey(name: 'profile_picture')
  final MediaData? profilePicture;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  UserDetail({
    this.id,
    this.mustChangePassword,
    this.status,
    this.name,
    this.firstName,
    this.middleName,
    this.lastName,
    this.username,
    this.phone,
    this.email,
    this.entity,
    this.token,
    this.requiresOtp,
    this.profilePicture,
    this.createdAt,
    this.updatedAt,
  });

  String get fullName {
    return '${firstName!} ${lastName!}';
  }

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    // If the response contains a 'data' wrapper
    Map<String, dynamic> data = {};
    Map<String, dynamic> userData = {};

    if (json.containsKey('data')) {
      data = json['data'] as Map<String, dynamic>;
    }
    if (data.containsKey('user')) {
      userData = data['user'] as Map<String, dynamic>;
    }
    return _$UserDetailFromJson({...json, ...data, ...userData});

    // Fallback for direct user data
    // return _$UserDetailFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserDetailToJson(this);
}
