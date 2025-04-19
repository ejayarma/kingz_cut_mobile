import 'package:json_annotation/json_annotation.dart';
part 'feedback.g.dart';

@JsonSerializable()
class Feedback {
  int? id;
  int? user_id;
  int? service_id;
  String? feedback_type; // complaint, suggestion, other
  String? description;
  int? rating;
  bool? is_resolved;
  String? admin_response;
  DateTime? created_at;
  DateTime? updated_at;

  Feedback({
    this.id,
    this.user_id,
    this.service_id,
    this.feedback_type,
    this.description,
    this.rating,
    this.is_resolved,
    this.admin_response,
    this.created_at,
    this.updated_at,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) => _$FeedbackFromJson(json);
  Map<String, dynamic> toJson() => _$FeedbackToJson(this);
}