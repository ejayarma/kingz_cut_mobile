import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/enums/booking_type.dart';
import 'package:kingz_cut_mobile/enums/payment_status.dart';
import 'package:kingz_cut_mobile/enums/payment_type.dart';
import 'package:kingz_cut_mobile/models/appointment.dart';
import 'package:kingz_cut_mobile/models/appointment_booking_state.dart';
import 'package:kingz_cut_mobile/repositories/appointment_repository.dart';

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return FirebaseAppointmentRepository();
});

final appointmentBookingProvider = StateNotifierProvider<
  AppointmentBookingNotifier,
  AppointmentBookingState
>((ref) => AppointmentBookingNotifier(ref.read(appointmentRepositoryProvider)));

class AppointmentBookingNotifier
    extends StateNotifier<AppointmentBookingState> {
  final AppointmentRepository _repository;

  AppointmentBookingNotifier(this._repository)
    : super(const AppointmentBookingState());

  // Service selection methods
  void selectService(String serviceId) {
    final currentServices = List<String>.from(state.selectedServiceIds);
    if (!currentServices.contains(serviceId)) {
      currentServices.add(serviceId);
      state = state.copyWith(selectedServiceIds: currentServices);
    }
  }

  void deselectService(String serviceId) {
    final currentServices = List<String>.from(state.selectedServiceIds);
    currentServices.remove(serviceId);
    state = state.copyWith(selectedServiceIds: currentServices);
  }

  void clearServices() {
    state = state.copyWith(selectedServiceIds: []);
  }

  // Staff selection methods
  void selectStaff(String staffId) {
    state = state.copyWith(selectedStaffId: staffId);
  }

  void clearStaffSelection() {
    state = state.copyWith(selectedStaffId: null);
  }

  // Date and time selection methods
  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void selectTimeSlot(DateTime startTime, DateTime endTime) {
    state = state.copyWith(
      selectedStartTime: startTime,
      selectedEndTime: endTime,
    );
  }

  void clearDateTimeSelection() {
    state = state.copyWith(
      selectedDate: null,
      selectedStartTime: null,
      selectedEndTime: null,
    );
  }

  // Total Price
  void updateTotalPrice(double totalPrice) {
    state = state.copyWith(totalPrice: totalPrice);
  }

  // Booking type
  void updateBookingType(BookingType bookingType) {
    state = state.copyWith(bookingType: bookingType);
  }

  // Payment type
  void updatePaymentType(PaymentType paymentType) {
    state = state.copyWith(paymentType: paymentType);
  }

  // Payment Status
  void updatePaymentStatus(PaymentStatus paymentStatus) {
    state = state.copyWith(paymentStatus: paymentStatus);
  }

  // Total timeframe
  void updateTotalTimeframe(int totalTimeframe) {
    state = state.copyWith(totalTimeframe: totalTimeframe);
  }

  // Book appointment
  Future<bool> bookAppointment(String customerId) async {
    if (!state.canBookAppointment) {
      state = state.copyWith(error: 'Please complete all required fields');
      return false;
    }

    state = state.copyWith(isLoading: true, error: null);

    final appointment = Appointment(
      customerId: customerId,
      staffId: state.selectedStaffId!,
      serviceIds: state.selectedServiceIds,
      startTime: state.selectedStartTime!,
      endTime: state.selectedEndTime!,
      totalPrice: state.totalPrice,
      bookingType: state.bookingType,
      totalTimeframe: state.totalTimeframe,
      paymentReference: state.paymentReference,
      paymentType: state.paymentType,
      paymentStatus: state.paymentStatus,
    );

    final result = await _repository.createAppointment(appointment);

    return result.fold(
      (error) {
        state = state.copyWith(isLoading: false, error: error);
        return false;
      },
      (appointment) {
        state = state.copyWith(isLoading: false);
        // clearBookingState();
        return true;
      },
    );
  }

  // Reset booking state
  void clearBookingState() {
    state = const AppointmentBookingState();
  }

  // Go back to previous step
  void goBackToServices() {
    state = state.copyWith(
      selectedStaffId: null,
      selectedDate: null,
      selectedStartTime: null,
      selectedEndTime: null,
    );
  }

  void goBackToStaffSelection() {
    state = state.copyWith(
      selectedDate: null,
      selectedStartTime: null,
      selectedEndTime: null,
    );
  }
}
