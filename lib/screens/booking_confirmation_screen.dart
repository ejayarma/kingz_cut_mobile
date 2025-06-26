import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kingz_cut_mobile/enums/booking_type.dart';
import 'package:kingz_cut_mobile/enums/payment_type.dart';
import 'package:kingz_cut_mobile/enums/payment_status.dart';
import 'package:kingz_cut_mobile/models/appointment_booking_state.dart';
import 'package:kingz_cut_mobile/models/notification_model.dart';
import 'package:kingz_cut_mobile/repositories/notification_repository.dart';
import 'package:kingz_cut_mobile/repositories/payment_repository.dart';
import 'package:kingz_cut_mobile/repositories/staff_repositoy.dart';
import 'package:kingz_cut_mobile/screens/checkout_screen.dart';
import 'package:kingz_cut_mobile/screens/home/dashboard_screen.dart';
import 'package:kingz_cut_mobile/services/notification_service.dart';
import 'package:kingz_cut_mobile/state_providers/appointment_booking_provider.dart';
import 'package:kingz_cut_mobile/state_providers/customer_notifer.dart';
import 'package:kingz_cut_mobile/state_providers/notification_notifier.dart';
import 'package:kingz_cut_mobile/state_providers/service_provider.dart';
import 'package:kingz_cut_mobile/state_providers/staff_provider.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';
import 'package:kingz_cut_mobile/utils/dashboard_page.dart';
import 'package:kingz_cut_mobile/utils/id_generator.dart';

class BookingConfirmationScreen extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final DateTime selectedStartTime;
  final DateTime selectedEndTime;
  final BookingType bookingType;
  final PaymentType paymentType;

  const BookingConfirmationScreen({
    super.key,
    required this.selectedDate,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.bookingType,
    required this.paymentType,
  });

  @override
  ConsumerState<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState
    extends ConsumerState<BookingConfirmationScreen> {
  bool _isProcessing = false;
  String? _paymentReference;
  // String? _mobileNumber;
  PaymentStatus _paymentStatus = PaymentStatus.pending;
  // final _mobileNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logCurrentState();
    });
  }

  void _logCurrentState() {
    final bookingState = ref.read(appointmentBookingProvider);
    log('=== Current Booking State ===');
    log("${bookingState.toString()}");
    // debugPrint('Selected Service IDs: ${bookingState.selectedServiceIds}');
    // debugPrint('Selected Staff ID: ${bookingState.selectedStaffId}');
    // debugPrint('Selected Date: ${bookingState.selectedDate}');
    // debugPrint('Selected Start Time: ${bookingState.selectedStartTime}');
    // debugPrint('Selected End Time: ${bookingState.selectedEndTime}');
    // debugPrint('Total Duration: $_totalDurationMinutes minutes');
    // debugPrint('Can Book Appointment: ${bookingState.canBookAppointment}');
    // debugPrint('TotalPrice: ${bookingState.totalPrice}');
    log('=============================');
  }

  // @override
  // void dispose() {
  //   _mobileNumberController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(appointmentBookingProvider);
    final servicesState = ref.watch(servicesProvider).value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Booking'),
        leading: _isProcessing ? null : const BackButton(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookingSummaryCard(bookingState, servicesState),
                  const SizedBox(height: 24),
                  if (widget.paymentType == PaymentType.mobileMoney)
                    _buildMobileMoneySection(),
                  const SizedBox(height: 24),
                  if (_paymentReference != null) _buildPaymentStatusCard(),
                  const SizedBox(height: 100), // Space for fixed button
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildConfirmButton(bookingState),
          ),
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Processing your booking...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookingSummaryCard(
    AppointmentBookingState bookingState,
    List<dynamic> servicesState,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Date',
              DateFormat('EEEE, dd/MM/yyyy').format(widget.selectedDate),
            ),
            _buildSummaryRow(
              'Time',
              '${DateFormat('h:mm a').format(widget.selectedStartTime)} - ${DateFormat('h:mm a').format(widget.selectedEndTime)}',
            ),
            _buildSummaryRow(
              'Booking Type',
              widget.bookingType == BookingType.walkInService
                  ? 'Walk-in Service'
                  : 'Home Service',
            ),
            _buildSummaryRow(
              'Payment Type',
              widget.paymentType == PaymentType.cash
                  ? 'Cash Payment'
                  : 'Mobile Money',
            ),
            const Divider(height: 24),
            const Text(
              'Services',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...servicesState
                .where(
                  (service) =>
                      bookingState.selectedServiceIds.contains(service.id),
                )
                .map(
                  (service) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '• ${service.name}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        Text(
                          'GHS ${service.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'GHS ${bookingState.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileMoneySection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mobile Money Payment',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // const Text(
            //   'Enter your mobile money number to proceed with payment:',
            //   style: TextStyle(fontSize: 14, color: Colors.grey),
            // ),
            // const SizedBox(height: 12),
            // TextFormField(
            //   controller: _mobileNumberController,
            //   keyboardType: TextInputType.phone,
            //   decoration: InputDecoration(
            //     labelText: 'Mobile Number',
            //     hintText: 'e.g., 0244123456',
            //     prefixIcon: const Icon(Icons.phone),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     contentPadding: const EdgeInsets.symmetric(
            //       horizontal: 12,
            //       vertical: 16,
            //     ),
            //   ),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter your mobile number';
            //     }
            //     if (value.length < 10) {
            //       return 'Please enter a valid mobile number';
            //     }
            //     return null;
            //   },
            //   onChanged: (value) {
            //     setState(() {
            //       _mobileNumber = value;
            //     });
            //   },
            // ),
            // const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You will be redirected to a page to complete payment. Follow the instructions to receive a payment prompt on your mobile device. Please approve the transaction to complete your booking',
                      // 'You will receive a payment prompt on your mobile device. Please approve the transaction to complete your booking.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatusCard() {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (_paymentStatus) {
      case PaymentStatus.pending:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        statusText = 'Payment Pending';
        break;
      case PaymentStatus.success:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Payment Successful';
        break;
      case PaymentStatus.failed:
        statusColor = Colors.red;
        statusIcon = Icons.error;
        statusText = 'Payment Failed';
        break;
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_paymentReference != null) ...[
              Text(
                'Reference: $_paymentReference',
                style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
              ),
              const SizedBox(height: 8),
            ],
            if (_paymentStatus == PaymentStatus.pending) ...[
              const Text(
                'Please check your mobile device and approve the payment request.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _checkPaymentStatus,
                      child: const Text('Check Status'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancelPayment,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
            ] else if (_paymentStatus == PaymentStatus.failed) ...[
              const Text(
                'Payment could not be processed. Please try again.',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    // backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  onPressed: _retryPayment,
                  child: const Text('Retry Payment'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(AppointmentBookingState bookingState) {
    // final canConfirm =
    //     widget.paymentType == PaymentType.cash ||
    //     (_mobileNumber != null && _mobileNumber!.isNotEmpty);

    String buttonText;
    if (_paymentStatus == PaymentStatus.success) {
      buttonText = 'Complete Booking';
    } else if (widget.paymentType == PaymentType.cash) {
      buttonText = 'Confirm Booking';
    } else {
      buttonText =
          _paymentReference == null || _paymentStatus != PaymentStatus.success
              ? 'Process Payment'
              : 'Complete Booking';
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: !_isProcessing ? _handleConfirmBooking : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              disabledBackgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleConfirmBooking() async {
    if (widget.paymentType == PaymentType.mobileMoney) {
      if (_paymentReference == null) {
        await _processMobileMoneyPayment();
      } else if (_paymentStatus == PaymentStatus.success) {
        await _completeBooking();
      } else {
        await _checkPaymentStatus();
      }
    } else {
      await _completeBooking();
    }
  }

  Future<void> _processMobileMoneyPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final customer = ref.read(customerNotifier).value;
      if (customer == null) {
        AppAlert.snackBarErrorAlert(context, 'User not logged in');
        return;
      }

      final paymentRepo = ref.read(paymentRepositoryProvider);

      setState(() {
        _paymentReference = IdGenerator.generate();
      });

      final checkoutUrl = await paymentRepo.initializePayment(
        amount: ref.read(appointmentBookingProvider).totalPrice ?? 0,
        email: customer.email,
        reference: _paymentReference!,
        name: customer.name,
      );

      log("CHeckout URL $checkoutUrl");

      // Navigate to Checkout screen
      if (mounted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CheckoutScreen(url: checkoutUrl),
          ),
        );
        if (result == true) {
          // User confirmed payment manually
          await _verifyAfterCheckout();
        }
      }
    } catch (e, stack) {
      if (mounted) {
        AppAlert.snackBarErrorAlert(
          context,
          'Failed to initialize payment: Please try again',
        );
        log(e.toString());
        log(stack.toString());
      }
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _verifyAfterCheckout() async {
    final paymentRepo = ref.read(paymentRepositoryProvider);

    if (_paymentReference == null) {
      AppAlert.snackBarErrorAlert(context, 'Missing payment reference');
      return;
    }

    setState(() => _isProcessing = true);

    bool verified = false;
    int attempts = 0;

    final bookingNotifier = ref.read(appointmentBookingProvider.notifier);
    while (!verified && attempts < 5) {
      await Future.delayed(const Duration(seconds: 3));

      try {
        verified = await paymentRepo.verifyPayment(_paymentReference!);
        if (verified) {
          bookingNotifier.updatePaymentStatus(PaymentStatus.success);
          break;
        } else {
          bookingNotifier.updatePaymentStatus(PaymentStatus.failed);
        }
      } catch (e, stack) {
        // if (mounted) {
        //   AppAlert.snackBarErrorAlert(
        //     context,
        //     'Failed to initialize payment: Please try again',
        //   );
        // }
        log(stack.toString());
        log(e.toString());
      }

      attempts++;
    }

    setState(() {
      _paymentStatus = verified ? PaymentStatus.success : PaymentStatus.failed;
      _isProcessing = false;
    });

    if (verified) {
      AppAlert.snackBarSuccessAlert(context, 'Payment verified successfully!');
    } else {
      if (mounted) {
        AppAlert.snackBarErrorAlert(
          context,
          'Could not verify payment. Please try again.',
        );
      }
    }
  }

  Future<void> _checkPaymentStatus() async {
    if (_paymentReference == null) return;
    if (_isProcessing) return;

    try {
      await _verifyAfterCheckout();
    } catch (e) {
      if (mounted) {
        AppAlert.snackBarErrorAlert(
          context,
          'Error checking payment status: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _retryPayment() async {
    setState(() {
      _paymentReference = null;
      _paymentStatus = PaymentStatus.pending;
    });
    await _processMobileMoneyPayment();
  }

  void _cancelPayment() {
    setState(() {
      _paymentReference = null;
      _paymentStatus = PaymentStatus.pending;
    });
  }

  Future<void> _completeBooking() async {
    final customer = ref.read(customerNotifier).value;

    if (customer == null) {
      AppAlert.snackBarErrorAlert(
        context,
        'You must be logged in to complete booking.',
      );
      return;
    }

    // For mobile money, ensure payment is successful before booking
    if (widget.paymentType == PaymentType.mobileMoney &&
        _paymentStatus != PaymentStatus.success) {
      AppAlert.snackBarErrorAlert(
        context,
        'Payment must be completed before booking.',
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final bookingNotifier = ref.read(appointmentBookingProvider.notifier);
      final success = await bookingNotifier.bookAppointment(customer.id);

      // await _sendSuccessBookingNotification();

      // final success = true;

      if (success) {
        if (!mounted) return;

        AppAlert.snackBarSuccessAlert(
          context,
          'Booking confirmed successfully!',
        );

        await _sendSuccessBookingNotification();

        bookingNotifier.clearBookingState();

        if (mounted) {
          // Navigate to dashboard and clear the navigation stack
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder:
                  (context) => DashboardScreen(
                    initialPageIndex: DashboardPage.bookings.index,
                  ),
            ),
            (route) => false,
          );
        }
      } else {
        final error = ref.read(appointmentBookingProvider).error;

        if (!mounted) return;

        AppAlert.snackBarErrorAlert(
          context,
          error ?? 'Failed to create booking. Please try again.',
        );
      }
    } catch (e) {
      log('Error creating booking: $e');
      log('Error creating booking: $e');
      if (mounted) {
        AppAlert.snackBarErrorAlert(
          context,
          'Error creating booking: Please try again',
        );
      }
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _sendSuccessBookingNotification() async {
    // Send Notification
    try {
      final notificationRepo = ref.read(notificationRepositoryProvider);
      final bookingStateProvider = ref.read(appointmentBookingProvider);

      final staffId = bookingStateProvider.selectedStaffId;

      final staff = await ref.read(staffRepositoryProvider).getStaff(staffId!);
      final customer = ref.read(customerNotifier).value;

      final date = Jiffy.parseFromDateTime(bookingStateProvider.selectedDate!);
      final formattedDate = date.format(pattern: 'EEE MMM dd, yyyy');
      final formattedTime = date.format(pattern: 'hh:mm a');

      final staffMessage =
          "Hello ${staff!.name}, You have a booking from ${customer!.name} on $formattedDate at $formattedTime";
      final customerMessage =
          "Hello ${customer.name}, Your booking on $formattedDate at $formattedTime has been received successfully.";

      log(
        'Sending message to staff: ${staff.toString()}, MESSAGE: $staffMessage',
      );
      await notificationRepo.createNotification(
        CreateNotificationRequest(uid: staff.userId, message: staffMessage),
      );

      log(
        'Sending message to customer: ${customer.toString()}, MESSAGE: $customerMessage',
      );
      await notificationRepo.createNotification(
        CreateNotificationRequest(
          uid: customer.userId,
          message: customerMessage,
        ),
      );
    } catch (e, stack) {
      log("Error sending notifications: $e");
      log("Error sending notifications: $stack");
    }
  }
}
