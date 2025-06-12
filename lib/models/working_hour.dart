import 'package:freezed_annotation/freezed_annotation.dart';

part 'working_hour.freezed.dart';
part 'working_hour.g.dart';

@freezed
class WorkingHour with _$WorkingHour {
  const factory WorkingHour({
    required String dayName,
    required String shortName,
    required String openingTime,
    required String closingTime,
    required bool isActive,
  }) = _WorkingHour;

  factory WorkingHour.fromJson(Map<String, dynamic> json) =>
      _$WorkingHourFromJson(json);
}
