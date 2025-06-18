import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kingz_cut_mobile/enums/appointment_status.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    required String? customerId,
    required bool? reviewed,
    required DateTime? startTime,
    required DateTime? endTime,
    required String? staffId,
    required AppointmentStatus? status,
    required List<String>? serviceIds,
    required DateTime? createdAt,
    required DateTime? updatedAt,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}
