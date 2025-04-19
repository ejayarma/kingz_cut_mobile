// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) => CartItem(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      price: (json['price'] as num).toDouble(),
      extraDetails: json['extraDetails'] as Map<String, dynamic>?,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      thumbnail: json['thumbnail'] as String?,
    );

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'quantity': instance.quantity,
      'price': instance.price,
      'extraDetails': instance.extraDetails,
      'images': instance.images,
      'thumbnail': instance.thumbnail,
    };
