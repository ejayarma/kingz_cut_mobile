import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff.freezed.dart';
part 'staff.g.dart';

@freezed
class Staff with _$Staff {
  const factory Staff({
    required bool active,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    required String email,
    required String id,
    @JsonKey(name: 'image') String? imageUrl,
    required String name,
    required String phone,
    required String role,
    @JsonKey(name: 'services') required List<String> serviceIds,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
    String? url,
    @JsonKey(name: 'userId') required String userId,
  }) = _Staff;

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);
}
