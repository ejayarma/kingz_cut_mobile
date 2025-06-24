import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kingz_cut_mobile/enums/booking_type.dart';
import 'package:kingz_cut_mobile/models/about.dart';
import 'package:kingz_cut_mobile/models/appointment.dart';
import 'package:kingz_cut_mobile/models/appointment_booking_state.dart';
// import 'package:kingz_cut_mobile/models/service.dart';
import 'package:kingz_cut_mobile/models/working_hour.dart';
import 'package:kingz_cut_mobile/state_providers/about_provider.dart';
import 'package:kingz_cut_mobile/state_providers/appointment_booking_provider.dart';
import 'package:kingz_cut_mobile/state_providers/appointments_provider.dart';
import 'package:kingz_cut_mobile/state_providers/customer_notifer.dart';
import 'package:kingz_cut_mobile/state_providers/customers_provider.dart';
import 'package:kingz_cut_mobile/state_providers/service_provider.dart';
import 'package:kingz_cut_mobile/screens/home/dashboard_screen.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';
import 'package:kingz_cut_mobile/utils/dashboard_page.dart';

class BookingScreen extends ConsumerStatefulWidget {
  // final String customerId; // Customer ID parameter

  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  DateTime? _selectedDate;
  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;
  List<DateTime> _availableStartTimes = [];
  int get _totalDurationMinutes =>
      ref.read(appointmentBookingProvider).totalTimeframe ??
      0; // Get total duration from state
  BookingType? _bookingType = BookingType.walkInService;

  @override
  void initState() {
    super.initState();
    _initializeBookingState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshAppointments();
    });
  }

  Future<void> _refreshAppointments() async {
    await ref.read(appointmentsProvider.notifier).fetchAppointments();
  }

  void _calculateTotalDurationAndPrice() {
    final bookingState = ref.read(appointmentBookingProvider);
    final bookingNotifier = ref.read(appointmentBookingProvider.notifier);
    final servicesState = ref.read(servicesProvider).value ?? [];

    // Calculate total duration from selected services in the state

    final totalDurationMinutes = servicesState
        .where(
          (service) => bookingState.selectedServiceIds.contains(service.id),
        )
        .sumBy((service) => service.timeframe);

    final totalPrice = servicesState
        .where(
          (service) => bookingState.selectedServiceIds.contains(service.id),
        )
        .sumBy((service) => service.price);

    bookingNotifier.updateTotalPrice(totalPrice);
    bookingNotifier.updateTotalTimeframe(totalDurationMinutes);
  }

  void _initializeBookingState() {
    // The booking state should already be initialized from previous screens
    // Just log the current state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logCurrentState();
      _calculateTotalDurationAndPrice();
    });
  }

  void _logCurrentState() {
    final bookingState = ref.read(appointmentBookingProvider);
    debugPrint('=== Current Booking State ===');
    debugPrint('Selected Service IDs: ${bookingState.selectedServiceIds}');
    debugPrint('Selected Staff ID: ${bookingState.selectedStaffId}');
    debugPrint('Selected Date: ${bookingState.selectedDate}');
    debugPrint('Selected Start Time: ${bookingState.selectedStartTime}');
    debugPrint('Selected End Time: ${bookingState.selectedEndTime}');
    debugPrint('Total Duration: $_totalDurationMinutes minutes');
    debugPrint('Can Book Appointment: ${bookingState.canBookAppointment}');
    debugPrint('TotalPrice: ${bookingState.totalPrice}');
    debugPrint('=============================');
  }

  @override
  Widget build(BuildContext context) {
    final aboutAsync = ref.watch(aboutProvider);
    final bookingState = ref.watch(appointmentBookingProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Book your hair stylist'),
      ),
      body: aboutAsync.when(
        data: (about) => _buildBookingContent(about, bookingState),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error loading working hours: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(aboutProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildBookingContent(
    About about,
    AppointmentBookingState bookingState,
  ) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildServicesSection(),
                  const SizedBox(height: 24),
                  _buildBookingTypeSection(),
                  const SizedBox(height: 24),
                  _buildDateSection(about.workingHours),
                  const SizedBox(height: 32),
                  if (_selectedDate != null) _buildTimeSection(),
                ],
              ),
            ),
            _buildConfirmButton(bookingState),
          ],
        ),
        if (bookingState.isLoading)
          Container(
            color: Colors.black54,
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Column _buildBookingTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Select Booking Type',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        RadioListTile<BookingType>(
          title: const Text('Home Service'),
          value: BookingType.homeService,
          groupValue: _bookingType,
          onChanged: (BookingType? value) {
            if (value == null) return;
            final bookingNotifier = ref.read(
              appointmentBookingProvider.notifier,
            );
            bookingNotifier.updateBookingType(value);
            setState(() => _bookingType = value);
          },
        ),
        RadioListTile<BookingType>(
          title: const Text('Walk-in Service'),
          value: BookingType.walkInService,
          groupValue: _bookingType,
          onChanged: (BookingType? value) {
            if (value == null) return;
            final bookingNotifier = ref.read(
              appointmentBookingProvider.notifier,
            );
            bookingNotifier.updateBookingType(value);
            setState(() => _bookingType = value);
          },
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    final bookingState = ref.watch(appointmentBookingProvider);
    final servicesAsync = ref.watch(servicesProvider);
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Services',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...(servicesAsync.value ?? [])
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
                            service.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Text(
                          '${service.timeframe} min',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Duration',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$_totalDurationMinutes min (${(_totalDurationMinutes / 60).toStringAsFixed(1)}h)',
                  style: TextStyle(
                    fontSize: 16,
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

  Widget _buildDateSection(List<WorkingHour> workingHours) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Date',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => _selectDate(workingHours),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? DateFormat('EEEE, dd/MM/yyyy').format(_selectedDate!)
                        : 'Select a date',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          _selectedDate != null
                              ? Colors.black87
                              : Colors.grey.shade600,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Start Time',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (_selectedStartTime != null && _selectedEndTime != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Appointment: ${DateFormat('h:mm a').format(_selectedStartTime!)} - ${DateFormat('h:mm a').format(_selectedEndTime!)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        if (_availableStartTimes.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No available time slots for this date and duration.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ..._availableStartTimes.map((startTime) {
            final endTime = startTime.add(
              Duration(minutes: _totalDurationMinutes),
            );
            final isSelected = _selectedStartTime == startTime;
            final isPastTime = _isPastTime(startTime);
            final canSelect = !isPastTime;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap:
                    canSelect
                        ? () => _selectTimeSlot(startTime, endTime)
                        : null,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : isPastTime
                              ? Colors.grey.shade300
                              : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color:
                        isSelected
                            ? Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1)
                            : isPastTime
                            ? Colors.grey.shade50
                            : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isPastTime ? Colors.grey : null,
                            ),
                          ),
                          Text(
                            'Duration: $_totalDurationMinutes minutes',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  isPastTime
                                      ? Colors.grey
                                      : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isPastTime
                                  ? Colors.grey.shade200
                                  : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isPastTime ? 'Past' : 'Available',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:
                                isPastTime
                                    ? Colors.grey.shade600
                                    : Colors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildConfirmButton(AppointmentBookingState bookingState) {
    final canBook =
        _selectedDate != null &&
        _selectedStartTime != null &&
        _selectedEndTime != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (bookingState.error != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        bookingState.error!,
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    canBook && !bookingState.isLoading ? _confirmBooking : null,
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
                  canBook ? 'Confirm Booking' : 'Select Date and Time',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(List<WorkingHour> workingHours) async {
    final activeWorkingDays =
        workingHours
            .where((wh) => wh.isActive)
            .map((wh) => _getWeekdayFromName(wh.dayName))
            .toSet();

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      selectableDayPredicate: (date) {
        return activeWorkingDays.contains(date.weekday);
      },
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _selectedStartTime = null;
        _selectedEndTime = null;
        _availableStartTimes = _generateAvailableStartTimes(date, workingHours);
      });

      // Update the booking provider
      ref.read(appointmentBookingProvider.notifier).selectDate(date);
      _logCurrentState();
    }
  }

  void _selectTimeSlot(DateTime startTime, DateTime endTime) {
    setState(() {
      _selectedStartTime = startTime;
      _selectedEndTime = endTime;
    });

    // Update the booking provider
    ref
        .read(appointmentBookingProvider.notifier)
        .selectTimeSlot(startTime, endTime);
    _logCurrentState();
  }

  Future<void> _confirmBooking() async {
    final bookingState = ref.read(appointmentBookingProvider);
    final servicesState = ref.read(servicesProvider).value ?? [];
    final customer = ref.read(customerNotifier).value;

    if (customer == null) {
      AppAlert.snackBarErrorAlert(
        context,
        'You must be logged in to book an appointment.',
      );
      return;
    }

    if (_selectedDate != null &&
        _selectedStartTime != null &&
        _selectedEndTime != null) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Confirm Booking'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${DateFormat('EEEE, dd/MM/yyyy').format(_selectedDate!)}',
                  ),
                  Text(
                    'Time: ${DateFormat('h:mm a').format(_selectedStartTime!)} - ${DateFormat('h:mm a').format(_selectedEndTime!)}',
                  ),
                  Text(
                    'Total Price: GHS ${bookingState.totalPrice?.toStringAsFixed(2)}',
                  ),
                  Builder(
                    builder: (context) {
                      final bookingType =
                          bookingState.bookingType == BookingType.walkInService
                              ? 'Waliking Service'
                              : 'Home Service';
                      return Text('Booking Type: $bookingType');
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Services:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...servicesState
                      .where(
                        (service) => bookingState.selectedServiceIds.contains(
                          service.id,
                        ),
                      )
                      .map(
                        (service) => Text(
                          '• ${service.name} (${service.timeframe} min)',
                        ),
                      ),
                  const SizedBox(height: 12),
                  const Text(
                    'Are you sure you want to book this appointment?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Confirm'),
                ),
              ],
            ),
      );

      if (confirmed == true) {
        debugPrint('=== Creating Appointment ===');
        _logCurrentState();

        final success = await ref
            .read(appointmentBookingProvider.notifier)
            .bookAppointment(customer?.id ?? '');

        if (success) {
          ref.read(appointmentBookingProvider.notifier).clearBookingState();
          if (mounted) {
            AppAlert.snackBarSuccessAlert(
              context,
              'Appointment booked successfully!',
            );
            _navigateToHomScreen(); // Go back to previous screen
          }
        } else {
          final bookingState = ref.read(appointmentBookingProvider);
          if (mounted) {
            AppAlert.snackBarErrorAlert(
              context,
              'Failed to book appointment: ${bookingState.error ?? "Unknown error"}',
            );
          }
        }
      }
    }
  }

  void _navigateToHomScreen() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder:
            (_) =>
                DashboardScreen(initialPageIndex: DashboardPage.bookings.index),
      ),
      (route) => false,
    );
  }

  List<DateTime> _generateAvailableStartTimes(
    DateTime date,
    List<WorkingHour> workingHours,
  ) {
    final dayName = DateFormat('EEEE').format(date);
    final workingHour = workingHours.firstWhere(
      (wh) => wh.dayName.toLowerCase() == dayName.toLowerCase(),
      orElse:
          () => const WorkingHour(
            dayName: '',
            shortName: '',
            openingTime: '',
            closingTime: '',
            isActive: false,
          ),
    );

    if (!workingHour.isActive) return [];

    final openingTime = _parseTime(workingHour.openingTime, date);
    final closingTime = _parseTime(workingHour.closingTime, date);

    if (openingTime == null || closingTime == null) return [];

    final availableSlots = <DateTime>[];
    var currentTime = openingTime;

    // Generate slots with 30-minute intervals
    while (currentTime
            .add(Duration(minutes: _totalDurationMinutes))
            .isBefore(closingTime) ||
        currentTime
            .add(Duration(minutes: _totalDurationMinutes))
            .isAtSameMomentAs(closingTime)) {
      final endTime = currentTime.add(Duration(minutes: _totalDurationMinutes));

      // Check if this time slot conflicts with any booked appointments
      if (!_isTimeSlotBooked(currentTime, endTime)) {
        availableSlots.add(currentTime);
      }

      currentTime = currentTime.add(const Duration(minutes: 30));
    }

    return availableSlots;
  }

  bool _isTimeSlotBooked(DateTime startTime, DateTime endTime) {
    for (final Appointment ap in ref.read(appointmentsProvider).appointments) {
      final bookedStart = ap.startTime;
      final bookedEnd = ap.endTime;

      // Check if the time slots overlap
      if (startTime.isBefore(bookedEnd) && endTime.isAfter(bookedStart)) {
        return true;
      }
    }
    return false;
  }

  bool _isPastTime(DateTime startTime) {
    final now = DateTime.now();
    return startTime.isBefore(now);
  }

  DateTime? _parseTime(String timeString, DateTime date) {
    try {
      final formats = [
        'h:mm a', // 8:00 AM
        'HH:mm', // 08:00
        'h:mm', // 8:00
      ];

      for (final format in formats) {
        try {
          final time = DateFormat(format).parse(timeString.toUpperCase());
          return DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        } catch (e) {
          continue;
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error parsing time: $timeString - $e');
      return null;
    }
  }

  int _getWeekdayFromName(String dayName) {
    switch (dayName.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday':
        return DateTime.saturday;
      case 'sunday':
        return DateTime.sunday;
      default:
        return DateTime.monday;
    }
  }
}
