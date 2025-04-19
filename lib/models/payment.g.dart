// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      id: (json['id'] as num?)?.toInt(),
      application_id: (json['application_id'] as num?)?.toInt(),
      user_id: (json['user_id'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      payment_method: json['payment_method'] as String?,
      status: json['status'] as String?,
      transaction_id: json['transaction_id'] as String?,
      receipt_url: json['receipt_url'] as String?,
      payment_date: json['payment_date'] == null
          ? null
          : DateTime.parse(json['payment_date'] as String),
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'application_id': instance.application_id,
      'user_id': instance.user_id,
      'amount': instance.amount,
      'payment_method': instance.payment_method,
      'status': instance.status,
      'transaction_id': instance.transaction_id,
      'receipt_url': instance.receipt_url,
      'payment_date': instance.payment_date?.toIso8601String(),
      'created_at': instance.created_at?.toIso8601String(),
      'updated_at': instance.updated_at?.toIso8601String(),
    };
