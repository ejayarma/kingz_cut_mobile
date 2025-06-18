import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_category.freezed.dart';
part 'service_category.g.dart';

@freezed
class ServiceCategory with _$ServiceCategory {
  const factory ServiceCategory({
    required String id,
    required String? imageUrl,
    required String? description,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ServiceCategory;

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      _$ServiceCategoryFromJson(json);
}
