import 'package:json_annotation/json_annotation.dart';
part 'user_notice.g.dart';

@JsonSerializable()
class UserNotice {
  int? id;
  String? title;
  String? message;
  String? type; // application_status, payment_status, system
  String? priority; // application_status, payment_status, system
  @JsonKey(name: 'read_at')
  DateTime? readAt;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;

  UserNotice({
    this.id,
    this.title,
    this.message,
    this.type,
    this.priority,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserNotice.fromJson(Map<String, dynamic> json) =>
      _$UserNoticeFromJson(json);
  Map<String, dynamic> toJson() => _$UserNoticeToJson(this);
}
