import 'package:json_annotation/json_annotation.dart';

part 'cart_item.g.dart';

@JsonSerializable()
class CartItem {
  final int id;
  final String name;
  final String? description;
  final int quantity;
  final double price;
  final Map<String, dynamic>? extraDetails;
  final List<String>? images;
  final String? thumbnail;

  CartItem({
    required this.id,
    required this.name,
    this.description,
    this.quantity = 1,
    required this.price,
     this.extraDetails,
     this.images,
     this.thumbnail,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
