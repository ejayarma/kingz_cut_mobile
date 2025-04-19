import 'package:kingz_cut_mobile/models/invoice_item.dart';
import 'package:json_annotation/json_annotation.dart';
part 'invoice.g.dart';

@JsonSerializable()
class Invoice {
  int? id;
  @JsonKey(name: 'invoice_number')
  String? invoiceNumber;
  String? status;
  String? currency;
  @JsonKey(name: 'total_amount')
  double? totalAmount;
  @JsonKey(name: 'created_at')
  DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  DateTime? updatedAt;
  @JsonKey(name: 'paid_at')
  DateTime? paidAt;
  List<InvoiceItem>? items;

  Invoice({
    this.id,
    this.invoiceNumber,
    this.totalAmount,
    this.status,
    this.currency,
    this.createdAt,
    this.updatedAt,
    this.paidAt,
    this.items,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    if (json['total_amount'] is String) {
      json['total_amount'] =
          double.tryParse(json['total_amount'] ?? '0.0') ?? 0.0;
    }
    return _$InvoiceFromJson(json);
  }
  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}
