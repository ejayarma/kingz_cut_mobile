import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kingz_cut_mobile/models/about.dart';
import 'package:kingz_cut_mobile/models/working_hour.dart';
import 'package:kingz_cut_mobile/state_providers/about_provider.dart';

class BookingScreenCopy extends ConsumerStatefulWidget {
  const BookingScreenCopy({super.key});

  @override
  ConsumerState<BookingScreenCopy> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreenCopy> {
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  List<String> _availableTimeSlots = [];

  // Sample booked slots - replace with your actual data source
  final Set<String> _bookedSlots = {'10:30 AM', '11:30 AM', '12:00 PM'};

  @override
  Widget build(BuildContext context) {
    final aboutAsync = ref.watch(aboutProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Book your hair stylist'),
      ),
      body: aboutAsync.when(
        data: (about) => _buildBookingContent(about),
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

  Widget _buildBookingContent(About about) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildDateSection(about.workingHours),
              const SizedBox(height: 32),
              if (_selectedDate != null) _buildTimeSection(),
            ],
          ),
        ),
        _buildConfirmButton(),
      ],
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
          'Select Time',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (_availableTimeSlots.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No available time slots for this date.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ..._availableTimeSlots.map((timeSlot) {
            final isBooked = _bookedSlots.contains(timeSlot);
            final isSelected = _selectedTimeSlot == timeSlot;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: isBooked ? null : () => _selectTimeSlot(timeSlot),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    color:
                        isSelected
                            ? Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1)
                            : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeSlot,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isBooked ? Colors.grey : null,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isBooked
                                  ? Colors.red.shade100
                                  : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isBooked ? 'Booked' : 'Available',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:
                                isBooked
                                    ? Colors.red.shade700
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

  Widget _buildConfirmButton() {
    final canBook = _selectedDate != null && _selectedTimeSlot != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canBook ? _confirmBooking : null,
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
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
        _selectedTimeSlot = null; // Reset time selection
        _availableTimeSlots = _generateTimeSlots(date, workingHours);
      });
    }
  }

  void _selectTimeSlot(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

  void _confirmBooking() {
    if (_selectedDate != null && _selectedTimeSlot != null) {
      // Handle booking confirmation
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Booking Confirmed'),
              content: Text(
                'Your appointment is scheduled for:\n'
                '${DateFormat('EEEE, dd/MM/yyyy').format(_selectedDate!)} '
                'at $_selectedTimeSlot',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
    }
  }

  List<String> _generateTimeSlots(
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

    final openingTime = _parseTime(workingHour.openingTime);
    final closingTime = _parseTime(workingHour.closingTime);

    if (openingTime == null || closingTime == null) return [];

    final slots = <String>[];
    var currentTime = openingTime;

    while (currentTime.isBefore(closingTime)) {
      slots.add(DateFormat('h:mm a').format(currentTime));
      currentTime = currentTime.add(const Duration(minutes: 30));
    }

    return slots;
  }

  DateTime? _parseTime(String timeString) {
    try {
      // Handle different time formats
      final formats = [
        'h:mm a', // 8:00 AM
        'HH:mm', // 08:00
        'h:mm', // 8:00
      ];

      for (final format in formats) {
        try {
          final time = DateFormat(format).parse(timeString.toUpperCase());
          final now = DateTime.now();
          return DateTime(now.year, now.month, now.day, time.hour, time.minute);
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
