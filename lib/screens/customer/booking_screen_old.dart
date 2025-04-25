import 'package:flutter/material.dart';

class BookingScreenOld extends StatefulWidget {
  final String stylistName; // Receiving the stylist's name

  const BookingScreenOld({super.key, required this.stylistName});

  @override
  State<BookingScreenOld> createState() => _BookingScreenOldState();
}

class _BookingScreenOldState extends State<BookingScreenOld> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _confirmBooking() {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both date and time')),
      );
      return;
    }

    // Show the confirmation dialog after a successful booking
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Booking Confirmed"),
            content: Text(
              "You have successfully booked ${widget.stylistName} on "
              "${_selectedDate!.toLocal().toString().split(' ')[0]} at ${_selectedTime!.format(context)}",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book ${widget.stylistName}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Booking with ${widget.stylistName}",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _pickDate,
              child: Text(
                _selectedDate == null
                    ? "Choose Date"
                    : "Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickTime,
              child: Text(
                _selectedTime == null
                    ? "Choose Time"
                    : "Time: ${_selectedTime!.format(context)}",
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                print("Booking button pressed!"); // Debugging
                _confirmBooking();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Confirm Booking"),
            ),
          ],
        ),
      ),
    );
  }
}
