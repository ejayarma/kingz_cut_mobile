import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kingz_cut_mobile/models/appointment.dart';
import 'package:kingz_cut_mobile/state_providers/customers_provider.dart';
import 'package:kingz_cut_mobile/state_providers/service_provider.dart';
import 'package:kingz_cut_mobile/state_providers/staff_notifier.dart';

class ReceiptPage extends ConsumerWidget {
  final Appointment appointment;

  const ReceiptPage({super.key, required this.appointment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersProvider).value ?? [];
    final services = ref.watch(servicesProvider).value ?? [];
    final staff = ref.watch(staffNotifier).value;

    final customer = customers.firstOrNullWhere(
      (c) => c.id == appointment.customerId,
    );

    final appointmentServices =
        services
            .where((service) => appointment.serviceIds.contains(service.id))
            .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Receipt',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // QR Code
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: QrImageView(
                data: 'RECEIPT-${appointment.id ?? 'INV001'}',
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Receipt ID
            Text(
              'Receipt ID: ${appointment.id?.substring(0, 6).toUpperCase() ?? 'INV001'}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 32),

            // Receipt Details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildReceiptRow('Salon', 'Kingz Cut Barbering Salon'),
                  _buildReceiptRow('Location', 'Dansoman, Ghana'),
                  _buildReceiptRow('Customer Name', customer?.name ?? 'N/A'),
                  _buildReceiptRow('Phone', customer?.phone ?? 'N/A'),
                  _buildReceiptRow(
                    'Booking Date',
                    _formatDate(appointment.startTime),
                  ),
                  _buildReceiptRow(
                    'Booking Time',
                    _formatTime(appointment.startTime),
                  ),
                  _buildReceiptRow('Stylist', staff?.name ?? 'N/A'),

                  // Services
                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 16),

                  ...appointmentServices.map(
                    (service) => _buildReceiptRow(
                      service.name,
                      'GHS ${service.price?.toStringAsFixed(2) ?? '0.00'}',
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: Colors.grey, thickness: 2),
                  const SizedBox(height: 16),

                  _buildReceiptRow(
                    'Total',
                    'GHS ${appointment.totalPrice?.toStringAsFixed(2) ?? '0.00'}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            // Row(
            //   children: [
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: () => _sendMessage(customer?.phone),
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.teal,
            //           foregroundColor: Colors.white,
            //           padding: const EdgeInsets.symmetric(vertical: 16),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //         ),
            //         child: const Text(
            //           'Send Message',
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(width: 16),
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: () => _makeCall(customer?.phone),
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.teal,
            //           foregroundColor: Colors.white,
            //           padding: const EdgeInsets.symmetric(vertical: 16),
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(12),
            //           ),
            //         ),
            //         child: const Text(
            //           'Call',
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 18 : 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Flexible(
            flex: 1,
            child: Text(
              value,
              style: TextStyle(
                fontSize: isTotal ? 18 : 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isTotal ? Colors.black : Colors.grey.shade600,
              ),
              maxLines: 2,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final day = dateTime.day;
    final month = months[dateTime.month - 1];
    final year = dateTime.year;

    String suffix = 'th';
    if (day == 1 || day == 21 || day == 31)
      suffix = 'st';
    else if (day == 2 || day == 22)
      suffix = 'nd';
    else if (day == 3 || day == 23)
      suffix = 'rd';

    return '$day$suffix $month, $year';
  }

  String _formatTime(DateTime dateTime) {
    final hour =
        dateTime.hour == 0
            ? 12
            : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Future<void> _sendMessage(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return;
    }

    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {
        'body':
            'Thank you for choosing Kingz Cut Barbering Salon! Your appointment receipt is ready.',
      },
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      }
    } catch (e) {
      // Handle error
      print('Could not launch SMS: $e');
    }
  }

  Future<void> _makeCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return;
    }

    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      }
    } catch (e) {
      // Handle error
      print('Could not launch call: $e');
    }
  }
}
