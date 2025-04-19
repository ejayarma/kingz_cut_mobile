import 'package:json_annotation/json_annotation.dart';
part 'application.g.dart';

@JsonSerializable()
class Application {
  int? id;
  int? user_id;
  int? service_id;
  String? status; // pending, approved, rejected
  Map<String, String>? submitted_documents; // document_type: document_url
  String? rejection_reason;
  DateTime? submission_date;
  DateTime? processing_date;
  DateTime? completion_date;
  DateTime? created_at;
  DateTime? updated_at;

  Application({
    this.id,
    this.user_id,
    this.service_id,
    this.status,
    this.submitted_documents,
    this.rejection_reason,
    this.submission_date,
    this.processing_date,
    this.completion_date,
    this.created_at,
    this.updated_at,
  });

  factory Application.fromJson(Map<String, dynamic> json) => _$ApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationToJson(this);
}