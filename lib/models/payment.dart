import 'package:json_annotation/json_annotation.dart';
part 'payment.g.dart';

@JsonSerializable()
class Payment {
  int? id;
  int? application_id;
  int? user_id;
  double? amount;
  String? payment_method; // credit_card, mobile_money, bank_transfer
  String? status; // pending, completed, failed
  String? transaction_id;
  String? receipt_url;
  DateTime? payment_date;
  DateTime? created_at;
  DateTime? updated_at;

  Payment({
    this.id,
    this.application_id,
    this.user_id,
    this.amount,
    this.payment_method,
    this.status,
    this.transaction_id,
    this.receipt_url,
    this.payment_date,
    this.created_at,
    this.updated_at,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}