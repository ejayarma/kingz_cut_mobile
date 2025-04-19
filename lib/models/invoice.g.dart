// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice(
      id: (json['id'] as num?)?.toInt(),
      invoiceNumber: json['invoice_number'] as String?,
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      status: json['status'] as String?,
      currency: json['currency'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => InvoiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'id': instance.id,
      'invoice_number': instance.invoiceNumber,
      'status': instance.status,
      'currency': instance.currency,
      'total_amount': instance.totalAmount,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'paid_at': instance.paidAt?.toIso8601String(),
      'items': instance.items,
    };
