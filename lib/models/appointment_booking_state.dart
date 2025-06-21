import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kingz_cut_mobile/enums/booking_type.dart';

part 'appointment_booking_state.freezed.dart';

@freezed
class AppointmentBookingState with _$AppointmentBookingState {
  const factory AppointmentBookingState({
    @Default([]) List<String> selectedServiceIds,
    String? selectedStaffId,
    DateTime? selectedDate,
    DateTime? selectedStartTime,
    DateTime? selectedEndTime,
    double? totalPrice,
    BookingType? bookingType,
    int? totalTimeframe,
    @Default(false) bool isLoading,
    String? error,
  }) = _AppointmentBookingState;

  const AppointmentBookingState._();

  bool get canProceedToStaffSelection => selectedServiceIds.isNotEmpty;
  bool get canProceedToDateTimeSelection =>
      selectedServiceIds.isNotEmpty && selectedStaffId != null;
  bool get canBookAppointment =>
      selectedServiceIds.isNotEmpty &&
      selectedStaffId != null &&
      selectedStartTime != null &&
      selectedEndTime != null;

}
