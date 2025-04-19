// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItem _$InvoiceItemFromJson(Map<String, dynamic> json) => InvoiceItem(
      id: (json['id'] as num?)?.toInt(),
      description: json['description'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      service: json['service'] == null
          ? null
          : Service.fromJson(json['service'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$InvoiceItemToJson(InvoiceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'amount': instance.amount,
      'service': instance.service,
    };
