import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/screens/home/dashboard_screen.dart';
import 'package:kingz_cut_mobile/state_providers/appointments_provider.dart';
import 'package:kingz_cut_mobile/state_providers/staff_notifier.dart';
import 'package:kingz_cut_mobile/models/appointment.dart';
import 'package:kingz_cut_mobile/enums/appointment_status.dart';
import 'package:kingz_cut_mobile/utils/dashboard_page.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(appointmentsProvider.notifier)
          .fetchAppointments(staffId: ref.read(staffNotifier).value?.id);
    });
  }

  // Future<void> _refreshAppointments() async {
  //   await ref
  //       .read(appointmentsProvider.notifier)
  //       .fetchAppointments(customerId: ref.read(staffNotifier).value?.id);
  // }

  @override
  Widget build(BuildContext context) {
    final currentStaff = ref.watch(staffStateProvider);
    final todaysAppointmentsAsync = ref.watch(todaysAppointmentsProvider);
    final todaysSalesAsync = ref.watch(todaysSalesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top search bar and notification (keeping same as customer)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search appointments, customers',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Badge(
                label: Text('0'), // change as needed
                child: Icon(Icons.notifications),
              ),
            ],
          ),
        ),

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () => _goToBookingsScreen(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF9A826),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'View Bookings',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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

        // Appointments List
        Expanded(
          flex: 2,
          child: todaysAppointmentsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (appointments) {
              if (appointments.isEmpty) {
                return const Center(
                  child: Text(
                    'No appointments today',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
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
    );
  }

  Widget _buildAppointmentCard(Appointment appointment, WidgetRef ref) {
    // You'll need to fetch customer and service details based on IDs
    final customerName = 'Customer'; // Replace with actual customer lookup
    final serviceName = 'Service'; // Replace with actual service lookup
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
      child: Row(
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
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  'GHS ${price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
    );
  }
}

// Providers for today's data
final todaysAppointmentsProvider = FutureProvider<List<Appointment>>((
  ref,
) async {
  final currentStaff = await ref.watch(staffNotifier.future);
  if (currentStaff == null) return [];

  // Get today's date range
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  // final tomorrow = today.add(const Duration(days: 1));

  // Use the existing appointments provider with staff filter
  final appointmentsState = ref.watch(appointmentsProvider);

  // Filter appointments for today and current staff
  final todaysAppointments =
      appointmentsState.appointments.where((appointment) {
        final appointmentDate = DateTime(
          appointment.startTime.year,
          appointment.startTime.month,
          appointment.startTime.day,
        );
        return appointmentDate.isAtSameMomentAs(today) &&
            appointment.staffId == currentStaff.id &&
            appointment.status == AppointmentStatus.pending;
      }).toList();

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
