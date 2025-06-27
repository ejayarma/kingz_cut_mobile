import 'dart:developer';

import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kingz_cut_mobile/repositories/customer_repository.dart';
import 'package:kingz_cut_mobile/screens/home/dashboard_screen.dart';
import 'package:kingz_cut_mobile/state_providers/appointments_provider.dart';
import 'package:kingz_cut_mobile/state_providers/customers_provider.dart';
import 'package:kingz_cut_mobile/state_providers/service_provider.dart';
import 'package:kingz_cut_mobile/state_providers/staff_notifier.dart';
import 'package:kingz_cut_mobile/models/appointment.dart';
import 'package:kingz_cut_mobile/enums/appointment_status.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';
import 'package:kingz_cut_mobile/utils/custom_ui_block.dart';
import 'package:kingz_cut_mobile/utils/dashboard_page.dart';
import 'package:url_launcher/url_launcher.dart';

class BarberHomePage extends ConsumerStatefulWidget {
  const BarberHomePage({super.key});

  @override
  ConsumerState<BarberHomePage> createState() => _BarberHomePageState();
}

class _BarberHomePageState extends ConsumerState<BarberHomePage> {
  void _goToBookingsScreen(BuildContext context) {
    // Navigate to bookings/calendar screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder:
            (_) =>
                DashboardScreen(initialPageIndex: DashboardPage.bookings.index),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _refreshAppointments();
    });
  }

  Future<void> _refreshAppointments() async {
    await ref.read(customersProvider.notifier).refreshCustomers();
    await ref
        .read(appointmentsProvider.notifier)
        .fetchAppointments(staffId: ref.read(staffNotifier).value?.id);
  }

  Future<void> _onRefresh() async {
    // Show loading indicator and refresh data
    await _refreshAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final currentStaff = ref.watch(staffStateProvider);
    final todaysAppointmentsAsync = ref.watch(todaysAppointmentsProvider);
    final todaysSalesAsync = ref.watch(todaysSalesProvider);

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top search bar and notification (keeping same as customer)
          // Padding(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: 16.0,
          //     vertical: 8.0,
          //   ),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           decoration: InputDecoration(
          //             hintText: 'Search appointments, customers',
          //             prefixIcon: const Icon(Icons.search, color: Colors.grey),
          //             filled: true,
          //             fillColor: Colors.grey.shade200,
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(15),
          //               borderSide: BorderSide.none,
          //             ),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(width: 10),
          //       const Badge(
          //         label: Text('0'), // change as needed
          //         child: Icon(Icons.notifications),
          //       ),
          //     ],
          //   ),
          // ),

          // Welcome banner (adapted for barber)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.black, Color.fromARGB(183, 10, 10, 41)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: AssetImage('assets/images/barber_working.png'),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome,\n${currentStaff.value?.name ?? 'Barber'}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Visit the calendar section to view your appointments',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       child: SizedBox(
                  //         height: 60,
                  //         width: 200,
                  //         child: ElevatedButton(
                  //           onPressed: () => _goToBookingsScreen(context),
                  //           style: ElevatedButton.styleFrom(
                  //             backgroundColor: const Color(0xFFF9A826),
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(10),
                  //             ),
                  //           ),
                  //           child: const Text(
                  //             'View Bookings',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 20,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),

          // Today's Appointments Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Text(
              'Today\'s Appointments',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          // Appointments List - Keeping the original Expanded structure
          Expanded(
            flex: 2,
            child: todaysAppointmentsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (appointments) {
                if (appointments.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 100),
                      Center(
                        child: Text(
                          'No appointments today',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return _buildAppointmentCard(appointment, ref);
                  },
                );
              },
            ),
          ),

          // Today's Sales Section
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Text(
              'Today\'s Sales',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          // Sales Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E8),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: todaysSalesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
              data: (salesData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Appointments',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${salesData['appointmentCount'] ?? 10}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Income',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'GHS ${salesData['totalIncome'] ?? '300.00'}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment, WidgetRef ref) {
    // You'll need to fetch customer and service details based on IDs
    final customerName = _getCustomerName(
      appointment,
    ); // Replace with actual customer lookup
    final serviceName = _getServiceNames(
      appointment,
    ); // Replace with actual service lookup
    final price = appointment.totalPrice ?? 0.0;

    // Format time from DateTime
    final startTime =
        '${appointment.startTime.hour.toString().padLeft(2, '0')}:${appointment.startTime.minute.toString().padLeft(2, '0')}';
    final endTime =
        '${appointment.endTime.hour.toString().padLeft(2, '0')}:${appointment.endTime.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Customer Avatar
              const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/default_avatar.png'),
              ),
              const SizedBox(width: 16),

              // Appointment Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName, // You'll need to implement customer lookup
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      serviceName, // You'll need to implement service lookup
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'GHS ${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Time
              Text(
                '$startTime - $endTime',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),

          // Action Buttons - Only show for pending appointments
          if (appointment.status == AppointmentStatus.pending) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Call button
                IconButton.outlined(
                  tooltip: 'Call Customer',
                  onPressed:
                      appointment.id != null
                          ? () => _triggerCustomerPhoneCall(appointment)
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

                // Accept Button
                ElevatedButton(
                  onPressed:
                      () => _showConfirmationDialog(
                        context,
                        'Accept Appointment',
                        'Are you sure you want to accept this appointment with $customerName?',
                        'Accept',
                        () => _acceptAppointment(appointment.id!, ref),
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9A826),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 12),
                // Cancel Button
                OutlinedButton(
                  onPressed:
                      () => _showConfirmationDialog(
                        context,
                        'Cancel Appointment',
                        'Are you sure you want to cancel this appointment with $customerName?',
                        'Cancel',
                        () => _cancelAppointment(appointment.id!, ref),
                        isDestructive: true,
                      ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _triggerCustomerPhoneCall(Appointment appointment) async {
    try {
      CustomUiBlock.block(context);
      final customer = await ref
          .read(customerRepositoryProvider)
          .getCustomer(appointment.customerId);

      log('customer $customer');
      if (customer != null) {
        _launchUrl('tel:${customer.phone}');
      } else {
        if (mounted) {
          AppAlert.snackBarErrorAlert(
            context,
            'customer phone number not found',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        AppAlert.snackBarErrorAlert(context, 'customer phone number not found');
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

  // Show confirmation dialog
  Future<void> _showConfirmationDialog(
    BuildContext context,
    String title,
    String message,
    String actionButtonText,
    VoidCallback onConfirm, {
    bool isDestructive = false,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isDestructive ? Colors.red : const Color(0xFFF9A826),
                foregroundColor: Colors.white,
              ),
              child: Text(actionButtonText),
            ),
          ],
        );
      },
    );
  }

  // Accept appointment
  Future<void> _acceptAppointment(String appointmentId, WidgetRef ref) async {
    final success = await ref
        .read(appointmentsProvider.notifier)
        .confirmAppointment(appointmentId);

    if (success) {
      // Show success message
      if (mounted) {
        AppAlert.snackBarSuccessAlert(
          context,
          'Appointment accepted successfully',
        );
      }
      // Refresh the appointments
      await _refreshAppointments();
    } else {
      // Show error message
      if (mounted) {
        AppAlert.snackBarErrorAlert(context, 'Failed to accept appointment');
      }
    }
  }

  // Cancel appointment
  Future<void> _cancelAppointment(String appointmentId, WidgetRef ref) async {
    final success = await ref
        .read(appointmentsProvider.notifier)
        .cancelAppointment(appointmentId);

    if (success) {
      // Show success message
      if (mounted) {
        AppAlert.snackBarSuccessAlert(
          context,
          'Appointment cancelled successfully',
        );
      }
      // Refresh the appointments
      await _refreshAppointments();
    } else {
      // Show error message
      if (mounted) {
        AppAlert.snackBarErrorAlert(context, 'Failed to cancel appointment');
      }
    }
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
}

// Providers for today's data
final todaysAppointmentsProvider = FutureProvider<List<Appointment>>((
  ref,
) async {
  final currentStaff = await ref.watch(staffNotifier.future);
  if (currentStaff == null) return [];

  // Get today using Jiffy
  final today = Jiffy.now();

  // Use the existing appointments provider with staff filter
  final appointmentsState = ref.watch(appointmentsProvider);

  if (appointmentsState.appointments.isEmpty) return [];

  // Filter appointments for today and current staff
  final todaysAppointments =
      appointmentsState.appointments.where((appointment) {
        // Convert appointment start time to Jiffy and check if it's the same day
        final appointmentJiffy = Jiffy.parseFromDateTime(appointment.startTime);

        return appointmentJiffy.isSame(today, unit: Unit.day) &&
            appointment.staffId == currentStaff.id
        // && appointment.status == AppointmentStatus.pending
        ;
      }).toList();

  log('Appointments for today: ${todaysAppointments.toString()}');

  // Sort by start time
  todaysAppointments.sort((a, b) => a.startTime.compareTo(b.startTime));

  return todaysAppointments;
});
final todaysSalesProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final todaysAppointments = await ref.watch(todaysAppointmentsProvider.future);

  // Calculate total income from completed appointments
  double totalIncome = 0.0;
  int completedAppointments = 0;

  for (final appointment in todaysAppointments) {
    if (appointment.status == AppointmentStatus.completed) {
      totalIncome += appointment.totalPrice ?? 0.0;
      completedAppointments++;
    }
  }

  return {
    'appointmentCount': todaysAppointments.length,
    'totalIncome': totalIncome.toStringAsFixed(2),
    'completedAppointments': completedAppointments,
  };
});
