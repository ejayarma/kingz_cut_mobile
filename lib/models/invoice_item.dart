import 'package:kingz_cut_mobile/models/service.dart';
import 'package:json_annotation/json_annotation.dart';
part 'invoice_item.g.dart';

@JsonSerializable()
class InvoiceItem {
  int? id;
  String? description;
  double? amount;
  Service? service;

  InvoiceItem({this.id, this.description, this.amount, this.service});

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    if (json['amount'] is String) {
      json['amount'] = double.tryParse(json['amount'] ?? '0.0') ?? 0.0;
    }
    return _$InvoiceItemFromJson(json);
  }
  Map<String, dynamic> toJson() => _$InvoiceItemToJson(this);
}
