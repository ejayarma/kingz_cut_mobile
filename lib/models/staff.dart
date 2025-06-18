import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff.freezed.dart';
part 'staff.g.dart';

@freezed
class Staff with _$Staff {
  const factory Staff({
    required String id,
    required bool active,
    required String email,
    required double? rating,
    @JsonKey(name: 'image') String? imageUrl,
    required String name,
    required String phone,
    required String role,
    @JsonKey(name: 'services') required List<String> serviceIds,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userId,
  }) = _Staff;

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);
}
