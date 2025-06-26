// OtpVerificationPage with phone input and Riverpod provider using Dio

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/enums/user_type.dart';
import 'package:kingz_cut_mobile/repositories/customer_repository.dart';
import 'package:kingz_cut_mobile/repositories/staff_repositoy.dart';
import 'package:kingz_cut_mobile/screens/home/dashboard_screen.dart';
import 'package:kingz_cut_mobile/state_providers/app_config_notifier.dart';
import 'package:kingz_cut_mobile/state_providers/customer_notifer.dart';
import 'package:kingz_cut_mobile/state_providers/otp_provider.dart';
import 'package:kingz_cut_mobile/state_providers/staff_notifier.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';

class OtpVerificationPageCopy extends ConsumerStatefulWidget {
  const OtpVerificationPageCopy({super.key});

  @override
  ConsumerState<OtpVerificationPageCopy> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPageCopy> {
  final TextEditingController _phoneController = TextEditingController();
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _focusNodes;
  bool _verifying = false;
  bool _resending = false;
  int _secondsLeft = -1;
  Timer? _timer;
  String _otpId = '';

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(4, (_) => TextEditingController());
    _focusNodes = List.generate(4, (_) => FocusNode());
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _handleSendOtp() async {
    final phone = _phoneController.text.trim();
    final isValid = RegExp(r'^\d{10}\$').hasMatch(phone);

    if (!isValid) {
      AppAlert.snackBarErrorAlert(context, 'Enter a valid 10-digit number');
      return;
    }

    setState(() => _resending = true);
    try {
      final otpService = ref.read(otpProvider);
      final otpId = await otpService.sendOtp(phone);

      if (otpId != null) {
        setState(() {
          _otpId = otpId;
          _secondsLeft = 300;
        });
        _startTimer();
        AppAlert.snackBarSuccessAlert(context, 'OTP sent to $phone');
      }
    } catch (e) {
      AppAlert.snackBarErrorAlert(context, 'Failed to send OTP');
    } finally {
      setState(() => _resending = false);
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpControllers.map((c) => c.text).join();

    if (code.length != 4) {
      AppAlert.snackBarErrorAlert(context, 'Enter the 4-digit OTP');
      return;
    }

    setState(() => _verifying = true);
    try {
      final otpService = ref.read(otpProvider);
      final verified = await otpService.verifyOtp(_otpId, code);

      if (verified) {
        final userType = ref.read(appConfigProvider).value?.userType;
        if (userType == UserType.customer) {
          final customer = await ref
              .read(customerRepositoryProvider)
              .getCustomerByUserId(
                FirebaseAuth.instance.currentUser?.uid ?? '',
              );
          if (customer != null) {
            ref
                .read(customerRepositoryProvider)
                .updateCustomer(
                  customer.id,
                  customer.copyWith(phone: _phoneController.text.trim()),
                );
          }

          ref.invalidate(customerNotifier);
        }

        if (userType == UserType.barber) {
          final staff = await ref
              .read(staffRepositoryProvider)
              .getStaffByUserId(FirebaseAuth.instance.currentUser?.uid ?? '');
          if (staff != null) {
            ref
                .read(staffRepositoryProvider)
                .updateStaff(
                  staff.id,
                  staff.copyWith(phone: _phoneController.text.trim()),
                );
          }
          ref.invalidate(staffNotifier);
        }

        await FirebaseAuth.instance.currentUser?.reload();
        await Future.delayed(Durations.long2);

        if (mounted) {
          AppAlert.snackBarSuccessAlert(context, 'OTP Verified');

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return DashboardScreen();
              },
            ),
          );
        }

        // Navigate to dashboard or next screen
      } else {
        AppAlert.snackBarErrorAlert(context, 'Invalid OTP');
      }
    } catch (e) {
      AppAlert.snackBarErrorAlert(context, 'Failed to verify OTP');
    } finally {
      setState(() => _verifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _resending ? null : _handleSendOtp,
              child: Text(_resending ? 'Sending...' : 'Send OTP'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (i) => _buildOtpBox(i)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _verifying ? null : _verifyOtp,
              child: Text(_verifying ? 'Verifying...' : 'Verify'),
            ),
            if (_secondsLeft > 0) Text('OTP expires in $_secondsLeft seconds'),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(counterText: ''),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}
