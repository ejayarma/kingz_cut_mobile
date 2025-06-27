import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/enums/appointment_status.dart';
import 'package:kingz_cut_mobile/models/appointment.dart';
import 'package:kingz_cut_mobile/repositories/staff_repositoy.dart';
import 'package:kingz_cut_mobile/screens/receipt_page.dart';
import 'package:kingz_cut_mobile/screens/reviews_screen.dart';
import 'package:kingz_cut_mobile/state_providers/appointments_provider.dart';
import 'package:kingz_cut_mobile/state_providers/customer_notifer.dart';
import 'package:kingz_cut_mobile/state_providers/service_provider.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';
import 'package:kingz_cut_mobile/utils/custom_ui_block.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerBookingsPage extends ConsumerStatefulWidget {
  // final String customerId; // Add customer ID parameter

  const CustomerBookingsPage({super.key});

  @override
  ConsumerState<CustomerBookingsPage> createState() =>
      _CustomerBookingsPageState();
}

class _CustomerBookingsPageState extends ConsumerState<CustomerBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color primaryColor = Colors.teal;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch appointments on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(appointmentsProvider.notifier)
          .fetchAppointments(customerId: ref.read(customerNotifier).value?.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshAppointments() async {
    await ref
        .read(appointmentsProvider.notifier)
        .fetchAppointments(customerId: ref.read(customerNotifier).value?.id);
  }

  List<Appointment> _filterAppointmentsByStatus(
    List<Appointment> appointments,
    List<AppointmentStatus> statuses,
  ) {
    return appointments
        .where((appointment) => statuses.contains(appointment.status))
        .toList()
      ..sort(
        (a, b) => b.startTime.compareTo(a.startTime),
      ); // Sort by date, newest first
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsState = ref.watch(appointmentsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bookings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Cancelled'),
                ],
                labelColor: primaryColor,
                indicatorColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                dividerColor: Colors.transparent,
              ),
              Expanded(
                child:
                    appointmentsState.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : appointmentsState.error != null
                        ? _buildErrorWidget(appointmentsState.error!)
                        : TabBarView(
                          controller: _tabController,
                          children: [
                            _buildUpcomingTab(appointmentsState.appointments),
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

  Widget _buildUpcomingTab(List<Appointment> appointments) {
    final upcomingAppointments = _filterAppointmentsByStatus(appointments, [
      AppointmentStatus.pending,
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
                  return _buildBookingCard(appointment: appointment);
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
                  return _buildCompletedBookingCard(appointment: appointment);
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
                  return _buildCancelledBookingCard(appointment: appointment);
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

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final day = dateTime.day.toString().padLeft(2, '0');
    final month = months[dateTime.month - 1];
    final year = dateTime.year;
    final hour =
        dateTime.hour == 0
            ? 12
            : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$day $month, $year - $hour:$minute $period';
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    final success = await ref
        .read(appointmentsProvider.notifier)
        .cancelAppointment(appointmentId);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking cancelled successfully'),
          backgroundColor: Colors.green,
        ),
        // AppAlert.snackBarSuccessAlert(context,  'Booking cancelled successfully'),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to cancel booking'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCancelConfirmation(String appointmentId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cancel Booking'),
            content: const Text(
              'Are you sure you want to cancel this booking?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _cancelAppointment(appointmentId);
                },
                child: const Text('Yes, Cancel'),
              ),
            ],
          ),
    );
  }

  Widget _buildBookingCard({required Appointment appointment}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDateTime(appointment.startTime),
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/empty_salon.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kingz Cut Barbering Salon',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dansoman, Ghana',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Builder(
                        builder: (context) {
                          final serviceText = (ref
                                      .read(servicesProvider)
                                      .value ??
                                  [])
                              .where(
                                (service) =>
                                    appointment.serviceIds.contains(service.id),
                              )
                              .map((service) => service.name)
                              .join(', ');

                          return Text(
                            'Services: $serviceText',
                            style: TextStyle(color: Colors.grey.shade600),
                          );
                        },
                      ),
                      if (appointment.totalPrice != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Total: GHS ${appointment.totalPrice!.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                      // if (appointment.notes != null &&
                      //     appointment.notes!.isNotEmpty) ...[
                      //   const SizedBox(height: 4),
                      //   Text(
                      //     'Notes: ${appointment.notes}',
                      //     style: TextStyle(
                      //       color: Colors.grey.shade600,
                      //       fontStyle: FontStyle.italic,
                      //     ),
                      //   ),
                      // ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton.outlined(
                  tooltip: 'Cancel Appointment',
                  onPressed:
                      appointment.id != null
                          ? () => _showCancelConfirmation(appointment.id!)
                          : null,
                  style: IconButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),

                  icon: Icon(
                    Icons.close_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                IconButton.outlined(
                  tooltip: 'Call Barber',
                  onPressed:
                      appointment.id != null
                          ? () => _triggerStaffPhoneCall(appointment)
                          : null,
                  style: IconButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  icon: Icon(
                    Icons.call,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ReceiptPage(appointment: appointment),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View Receipt'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedBookingCard({required Appointment appointment}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDateTime(appointment.startTime),
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/empty_salon.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kingz Cut Barbering Salon',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Builder(
                        builder: (context) {
                          final serviceText = (ref
                                      .read(servicesProvider)
                                      .value ??
                                  [])
                              .where(
                                (service) =>
                                    appointment.serviceIds.contains(service.id),
                              )
                              .map((service) => service.name)
                              .join(', ');

                          return Text(
                            'Services: $serviceText',
                            style: TextStyle(color: Colors.grey.shade600),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Staff ID: ${appointment.staffId}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      if (appointment.totalPrice != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Total: GHS ${appointment.totalPrice!.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     TextButton(
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => ReviewsScreen()),
            //         );
            //       },
            //       child: Text(
            //         appointment.reviewed ? 'View Reviews' : 'Add Review',
            //         style: TextStyle(
            //           color: Theme.of(context).colorScheme.secondary,
            //           decoration: TextDecoration.underline,
            //           decorationColor: Theme.of(context).colorScheme.secondary,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceiptPage(appointment: appointment),
                  ),
                );
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View Receipt'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelledBookingCard({required Appointment appointment}) {
    final isCancelled = appointment.status == AppointmentStatus.cancelled;
    final statusText = isCancelled ? 'Cancelled' : 'No Show';
    final statusColor = isCancelled ? Colors.red : Colors.orange;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDateTime(appointment.startTime),
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/empty_salon.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kingz Cut Barbering Salon',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dansoman, Ghana',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Builder(
                        builder: (context) {
                          final serviceText = (ref
                                      .read(servicesProvider)
                                      .value ??
                                  [])
                              .where(
                                (service) =>
                                    appointment.serviceIds.contains(service.id),
                              )
                              .map((service) => service.name)
                              .join(', ');

                          return Text(
                            'Services: $serviceText',
                            style: TextStyle(color: Colors.grey.shade600),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              statusText,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _triggerStaffPhoneCall(Appointment appointment) async {
    try {
      CustomUiBlock.block(context);
      final staff = await ref
          .read(staffRepositoryProvider)
          .getStaff(appointment.staffId);

      log('STaff $staff');
      if (staff != null) {
        _launchUrl('tel:${staff.phone}');
      } else {
        if (mounted) {
          AppAlert.snackBarErrorAlert(context, 'Staff phone number not found');
        }
      }
    } catch (e) {
      if (mounted) {
        AppAlert.snackBarErrorAlert(context, 'Staff phone number not found');
      }
      log(e.toString());
    } finally {
      if (mounted) {
        CustomUiBlock.unblock(context);
      }
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      String formattedUrl = url;
      if (!url.startsWith('http://') &&
          !url.startsWith('https://') &&
          !url.startsWith('tel:') &&
          !url.startsWith('mailto:')) {
        formattedUrl = 'https://$url';
      }

      debugPrint('Attempting to launch: $formattedUrl'); // Add this line

      final uri = Uri.parse(formattedUrl);

      final canLaunch = await canLaunchUrl(uri);
      debugPrint('Can launch URL: $canLaunch'); // Add this line

      if (canLaunch) {
        final result = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        debugPrint('Launch result: $result'); // Add this line
      } else {
        debugPrint('Cannot launch $formattedUrl');
        if (mounted) {
          AppAlert.snackBarErrorAlert(context, 'Could not open $formattedUrl');
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (mounted) {
        AppAlert.snackBarErrorAlert(context, 'Error opening link');
      }
    }
  }
}
