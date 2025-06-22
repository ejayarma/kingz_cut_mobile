import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/enums/appointment_status.dart';
import 'package:kingz_cut_mobile/models/appointment.dart';
import 'package:kingz_cut_mobile/models/appointments_state.dart';
import 'package:kingz_cut_mobile/repositories/appointment_repository.dart';
import 'package:kingz_cut_mobile/state_providers/appointment_booking_provider.dart';

final appointmentsProvider =
    StateNotifierProvider<AppointmentsNotifier, AppointmentsState>(
      (ref) => AppointmentsNotifier(ref.read(appointmentRepositoryProvider)),
    );

// Provider for watching appointments stream
// final appointmentsStreamProvider =
//     StreamProvider.family<List<Appointment>, AppointmentFilters>((
//       ref,
//       filters,
//     ) {
//       final repository = ref.read(appointmentRepositoryProvider);
//       return repository.watchAppointments(
//         customerId: filters.customerId,
//         staffId: filters.staffId,
//       );
//     });

// Filters for appointments
class AppointmentFilters {
  final String? customerId;
  final String? staffId;
  final AppointmentStatus? status;

  const AppointmentFilters({this.customerId, this.staffId, this.status});
}

class AppointmentsNotifier extends StateNotifier<AppointmentsState> {
  final AppointmentRepository _repository;

  AppointmentsNotifier(this._repository) : super(const AppointmentsState());

  // Fetch appointments with filters
  Future<void> fetchAppointments({
    String? customerId,
    String? staffId,
    AppointmentStatus? status,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.getAppointments(
      customerId: customerId,
      staffId: staffId,
      status: status,
    );

    result.fold(
      (error) => state = state.copyWith(isLoading: false, error: error),
      (appointments) =>
          state = state.copyWith(isLoading: false, appointments: appointments),
    );
  }

  // Update appointment status
  Future<bool> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus status,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.updateAppointmentStatus(
      appointmentId,
      status,
    );

    return result.fold(
      (error) {
        state = state.copyWith(isLoading: false, error: error);
        return false;
      },
      (_) {
        // Update local state
        final updatedAppointments =
            state.appointments.map((appointment) {
              if (appointment.id == appointmentId) {
                return appointment.copyWith(status: status);
              }
              return appointment;
            }).toList();

        state = state.copyWith(
          isLoading: false,
          appointments: updatedAppointments,
        );
        return true;
      },
    );
  }

  // Update entire appointment
  Future<bool> updateAppointment(Appointment appointment) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.updateAppointment(appointment);

    return result.fold(
      (error) {
        state = state.copyWith(isLoading: false, error: error);
        return false;
      },
      (_) {
        // Update local state
        final updatedAppointments =
            state.appointments.map((apt) {
              if (apt.id == appointment.id) {
                return appointment;
              }
              return apt;
            }).toList();

        state = state.copyWith(
          isLoading: false,
          appointments: updatedAppointments,
        );
        return true;
      },
    );
  }

  // Delete appointment
  Future<bool> deleteAppointment(String appointmentId) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _repository.deleteAppointment(appointmentId);

    return result.fold(
      (error) {
        state = state.copyWith(isLoading: false, error: error);
        return false;
      },
      (_) {
        // Remove from local state
        final updatedAppointments =
            state.appointments
                .where((appointment) => appointment.id != appointmentId)
                .toList();

        state = state.copyWith(
          isLoading: false,
          appointments: updatedAppointments,
        );
        return true;
      },
    );
  }

  // Convenience methods for common status updates
  Future<bool> confirmAppointment(String appointmentId) =>
      updateAppointmentStatus(appointmentId, AppointmentStatus.confirmed);

  Future<bool> cancelAppointment(String appointmentId) =>
      updateAppointmentStatus(appointmentId, AppointmentStatus.cancelled);

  Future<bool> completeAppointment(String appointmentId) =>
      updateAppointmentStatus(appointmentId, AppointmentStatus.completed);

  Future<bool> markAsNoShow(String appointmentId) =>
      updateAppointmentStatus(appointmentId, AppointmentStatus.noShow);

  // Refresh appointments
  Future<void> refresh() async {
    await fetchAppointments();
  }
}
