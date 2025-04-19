// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_checkout_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WebCheckoutInfo _$WebCheckoutInfoFromJson(Map<String, dynamic> json) =>
    WebCheckoutInfo(
      transactionId: json['transaction_id'] as String?,
      status: json['status'] as String?,
      paymentMethod: json['payment_method'] as String?,
      authorizationUrl: json['authorization_url'] as String?,
      reference: json['reference'] as String?,
      statusCode: json['status_code'] as String?,
    );

Map<String, dynamic> _$WebCheckoutInfoToJson(WebCheckoutInfo instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionId,
      'status': instance.status,
      'payment_method': instance.paymentMethod,
      'authorization_url': instance.authorizationUrl,
      'reference': instance.reference,
      'status_code': instance.statusCode,
    };
