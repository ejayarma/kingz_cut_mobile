import 'dart:developer';

import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/enums/appointment_status.dart';
import 'package:kingz_cut_mobile/models/appointment.dart';
import 'package:kingz_cut_mobile/screens/receipt_page.dart';
import 'package:kingz_cut_mobile/state_providers/appointments_provider.dart';
import 'package:kingz_cut_mobile/state_providers/customers_provider.dart';
import 'package:kingz_cut_mobile/state_providers/service_provider.dart';
import 'package:kingz_cut_mobile/state_providers/staff_notifier.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';

class BarberBookingsPage extends ConsumerStatefulWidget {
  const BarberBookingsPage({super.key});

  @override
  ConsumerState<BarberBookingsPage> createState() => _BarberBookingsPageState();
}

class _BarberBookingsPageState extends ConsumerState<BarberBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color primaryColor = Colors.teal;
  DateTime? selectedDate;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch all appointments for barber view
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshAppointments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshAppointments() async {
    await ref.read(customersProvider.notifier).refreshCustomers();
    await ref
        .read(appointmentsProvider.notifier)
        .fetchAppointments(staffId: ref.read(staffNotifier).value?.id);
  }

  List<Appointment> _filterAppointmentsByStatus(
    List<Appointment> appointments,
    List<AppointmentStatus> statuses,
  ) {
    var filteredAppointments =
        appointments
            .where((appointment) => statuses.contains(appointment.status))
            .toList();

    // Filter by selected date if provided
    if (selectedDate != null) {
      filteredAppointments =
          filteredAppointments
              .where(
                (appointment) =>
                    appointment.startTime.year == selectedDate!.year &&
                    appointment.startTime.month == selectedDate!.month &&
                    appointment.startTime.day == selectedDate!.day,
              )
              .toList();
    }

    // Filter by search query if provided
    if (searchQuery.isNotEmpty) {
      filteredAppointments =
          filteredAppointments
              .where(
                (appointment) =>
                    _getCustomerName(
                      appointment,
                    ).toLowerCase().contains(searchQuery.toLowerCase()) ||
                    _getServiceNames(
                      appointment,
                    ).toLowerCase().contains(searchQuery.toLowerCase()),
              )
              .toList();
    }

    // Sort by date, newest first
    filteredAppointments.sort((a, b) => b.startTime.compareTo(a.startTime));

    return filteredAppointments;
  }

  String _getServiceNames(Appointment appointment) {
    final services = ref.read(servicesProvider).value ?? [];
    return services
        .where((service) => appointment.serviceIds.contains(service.id))
        .map((service) => service.name)
        .join(', ');
  }

  String _getCustomerName(Appointment appointment) {
    final customers = ref.read(customersProvider).value ?? [];
    // log(customers.toString());
    return customers
            .firstOrNullWhere(
              (customer) => appointment.customerId == customer.id,
            )
            ?.name ??
        'Unknown Customer';
  }

  String _getCustomerPhone(Appointment appointment) {
    final customers = ref.read(customersProvider).value ?? [];
    return customers
            .firstOrNullWhere(
              (customer) => appointment.customerId == customer.id,
            )
            ?.phone ??
        'N/A';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _clearDateFilter() {
    setState(() {
      selectedDate = null;
    });
  }

  Future<void> _showCompleteDialog(Appointment appointment) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Complete Booking'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to complete this booking for ${_getCustomerName(appointment)}?',
                ),
                const SizedBox(height: 8),
                const Text('This will change the status back to pending.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Complete'),
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await ref
                    .read(appointmentsProvider.notifier)
                    .completeAppointment(appointment.id!);

                if (success) {
                  AppAlert.snackBarSuccessAlert(
                    context,
                    'Booking completed successfully',
                  );
                } else {
                  AppAlert.snackBarErrorAlert(
                    context,
                    'Failed to complete booking',
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showCancelDialog(Appointment appointment) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to cancel this booking for ${_getCustomerName(appointment)}?',
                ),
                const SizedBox(height: 8),
                const Text('This action cannot be undone.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Keep Booking'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel Booking'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await ref
                    .read(appointmentsProvider.notifier)
                    .cancelAppointment(appointment.id!);

                if (success) {
                  AppAlert.snackBarSuccessAlert(
                    context,
                    'Booking cancelled successfully',
                  );
                } else {
                  AppAlert.snackBarErrorAlert(
                    context,
                    'Failed to cancel booking',
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToReceipt(Appointment appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReceiptPage(appointment: appointment),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsState = ref.watch(appointmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Confirmed'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ],
                labelColor: primaryColor,
                indicatorColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                dividerColor: Colors.transparent,
              ),
              const SizedBox(height: 16),

              // Date Picker
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDate != null
                              ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}'
                              : 'DD/MM/YYYY',
                          style: TextStyle(
                            color:
                                selectedDate != null
                                    ? Colors.black
                                    : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      if (selectedDate != null)
                        GestureDetector(
                          onTap: _clearDateFilter,
                          child: Icon(Icons.clear, color: Colors.grey.shade600),
                        ),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_today, color: Colors.grey.shade600),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search customer name or service here..',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                    suffixIcon:
                        searchQuery.isNotEmpty
                            ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {
                                  searchQuery = '';
                                });
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.grey.shade600,
                              ),
                            )
                            : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child:
                    appointmentsState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : appointmentsState.error != null
                        ? _buildErrorWidget(appointmentsState.error!)
                        : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildConfirmedTab(appointmentsState.appointments),
                            _buildCompletedTab(appointmentsState.appointments),
                            _buildCancelledTab(appointmentsState.appointments),
                          ],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return RefreshIndicator(
      onRefresh: _refreshAppointments,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Error loading bookings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refreshAppointments,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmedTab(List<Appointment> appointments) {
    final upcomingAppointments = _filterAppointmentsByStatus(appointments, [
      AppointmentStatus.confirmed,
    ]);

    return RefreshIndicator(
      onRefresh: _refreshAppointments,
      child:
          upcomingAppointments.isEmpty
              ? _buildEmptyState('No upcoming bookings')
              : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: upcomingAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = upcomingAppointments[index];
                  return _buildBarberBookingCard(
                    appointment: appointment,
                    isConfirmedTab: true,
                  );
                },
              ),
    );
  }

  Widget _buildCompletedTab(List<Appointment> appointments) {
    final completedAppointments = _filterAppointmentsByStatus(appointments, [
      AppointmentStatus.completed,
    ]);

    return RefreshIndicator(
      onRefresh: _refreshAppointments,
      child:
          completedAppointments.isEmpty
              ? _buildEmptyState('No completed bookings')
              : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: completedAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = completedAppointments[index];
                  return _buildBarberBookingCard(appointment: appointment);
                },
              ),
    );
  }

  Widget _buildCancelledTab(List<Appointment> appointments) {
    final cancelledAppointments = _filterAppointmentsByStatus(appointments, [
      AppointmentStatus.cancelled,
      AppointmentStatus.noShow,
    ]);

    return RefreshIndicator(
      onRefresh: _refreshAppointments,
      child:
          cancelledAppointments.isEmpty
              ? _buildEmptyState('No cancelled bookings')
              : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: cancelledAppointments.length,
                itemBuilder: (context, index) {
                  final appointment = cancelledAppointments[index];
                  return _buildBarberBookingCard(appointment: appointment);
                },
              ),
    );
  }

  Widget _buildEmptyState(String message) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour =
        dateTime.hour == 0
            ? 12
            : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute$period';
  }

  Widget _buildBarberBookingCard({
    required Appointment appointment,
    bool isConfirmedTab = false,
  }) {
    final timeRange =
        '${_formatTime(appointment.startTime)}- ${_formatTime(appointment.endTime ?? appointment.startTime.add(const Duration(hours: 1)))}';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Customer Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 30, color: Colors.grey),
              ),
              const SizedBox(width: 16),
              // Appointment Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getCustomerName(appointment),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeRange,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getServiceNames(appointment),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'GHS ${appointment.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // View Receipt Button
              TextButton(
                onPressed: () => _navigateToReceipt(appointment),
                child: Text(
                  'View Receipt',
                  style: TextStyle(
                    color:
                        appointment.status == AppointmentStatus.cancelled
                            ? Theme.of(context).colorScheme.error
                            : primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          // Action buttons for confirmed tab
          if (isConfirmedTab) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showCancelDialog(appointment),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _showCompleteDialog(appointment),
                    style: FilledButton.styleFrom(
                      // side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Text('Complete'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
