import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kingz_cut_mobile/enums/appointment_status.dart';
import 'package:kingz_cut_mobile/enums/booking_type.dart';

part 'appointment.freezed.dart';
part 'appointment.g.dart';

@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    String? id, // Add id field for Firestore document ID
    required String customerId,
    @Default(false) bool reviewed,
    required DateTime startTime,
    required DateTime endTime,
    required String staffId,
    @Default(AppointmentStatus.pending) AppointmentStatus status,
    required List<String> serviceIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? totalPrice,
    int? totalTimeframe,
    BookingType? bookingType,  // (homeService or walkInService)
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);
}