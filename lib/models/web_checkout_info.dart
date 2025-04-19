import 'package:json_annotation/json_annotation.dart';
part 'web_checkout_info.g.dart';

@JsonSerializable()
class WebCheckoutInfo {
  @JsonKey(name: 'transaction_id')
  String? transactionId;
  String? status;
  @JsonKey(name: 'payment_method')
  String? paymentMethod;
  @JsonKey(name: 'authorization_url')
  String? authorizationUrl;
  String? reference;
  @JsonKey(name: 'status_code')
  String? statusCode;

  WebCheckoutInfo({
    this.transactionId,
    this.status,
    this.paymentMethod,
    this.authorizationUrl,
    this.reference,
    this.statusCode,
  });

  factory WebCheckoutInfo.fromJson(Map<String, dynamic> json) {
    return _$WebCheckoutInfoFromJson(json);
  }
  Map<String, dynamic> toJson() => _$WebCheckoutInfoToJson(this);
}
