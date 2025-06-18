import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_rating.freezed.dart';
part 'staff_rating.g.dart';

@freezed
class StaffRating with _$StaffRating {
  const factory StaffRating({
    required String id,
    required double? value,
    required String? staffId,
    required String? appointmentId,
    required String? customerId,
    required String? comment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StaffRating;

  factory StaffRating.fromJson(Map<String, dynamic> json) =>
      _$StaffRatingFromJson(json);
}
