import 'package:json_annotation/json_annotation.dart';
part 'support_chart.g.dart';

@JsonSerializable()
class SupportChat {
  int? id;
  int? user_id;
  String? message;
  bool? is_user_message;
  bool? is_read;
  DateTime? created_at;
  DateTime? updated_at;

  SupportChat({
    this.id,
    this.user_id,
    this.message,
    this.is_user_message,
    this.is_read,
    this.created_at,
    this.updated_at,
  });

  factory SupportChat.fromJson(Map<String, dynamic> json) => _$SupportChatFromJson(json);
  Map<String, dynamic> toJson() => _$SupportChatToJson(this);
}