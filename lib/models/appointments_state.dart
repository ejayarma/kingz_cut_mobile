import 'package:freezed_annotation/freezed_annotation.dart';
import 'appointment.dart';

part 'appointments_state.freezed.dart';

@freezed
class AppointmentsState with _$AppointmentsState {
  const factory AppointmentsState({
    @Default([]) List<Appointment> appointments,
    @Default(false) bool isLoading,
    String? error,
  }) = _AppointmentsState;
}
