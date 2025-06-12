import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kingz_cut_mobile/models/working_hour.dart';

part 'about.freezed.dart';
part 'about.g.dart';

@freezed
class About with _$About {
  const factory About({
    required String name,
    required String description,
    required String email,
    required String phone,
    required String location,
    required String website,
    required String facebook,
    required String tiktok,
    required String instagram,
    required String x,
    required String youtube,
    required String whatsapp,
    required String hours,
    @JsonKey(name: 'working-hours') required List<WorkingHour> workingHours,
  }) = _About;

  factory About.fromJson(Map<String, dynamic> json) => _$AboutFromJson(json);
}
