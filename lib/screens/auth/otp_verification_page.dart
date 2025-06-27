import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/state_providers/otp_provider.dart';

import '../../utils/app_alert.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({
    super.key,
    this.phone,
    this.validatePhone = false,
    required this.onPhoneNumberSubmitted,
  });

  final String? phone;
  final bool? validatePhone;

  // async callback
  final Future<void> Function(String phoneNumber, bool verified, WidgetRef ref)
  onPhoneNumberSubmitted;

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationScreen> {
  late TapGestureRecognizer _tapRecognizer;
  late TextEditingController _phoneController;

  late List<TextEditingController> _pinTextControllers;
  late List<FocusNode> _pinFocusNodes;
  bool _resending = false;
  bool _verifying = false;
  int _secondsLeft = -1;
  bool _otpSent = false;
  String _otpId = '';

  @override
  void initState() {
    super.initState();

    _tapRecognizer = TapGestureRecognizer()..onTap = _handleSendOtp;
    _phoneController = TextEditingController(
      text: widget.phone?.replaceAll(' ', ''),
    );
    _pinTextControllers = List.generate(4, (_) => TextEditingController());
    _pinFocusNodes = List.generate(4, (_) => FocusNode());
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    _phoneController.dispose();

    for (final controller in _pinTextControllers) {
      controller.dispose();
    }
    for (final controller in _pinFocusNodes) {
      controller.dispose();
    }
    super.dispose();
  }

  void _tickTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() => _secondsLeft--);
      } else if (_secondsLeft == 0) {
        AppAlert.snackBarErrorAlert(context, 'OTP expired');
        setState(() => _secondsLeft = -1);
        timer.cancel();
      }
    });
  }

  Future<void> _handleSendOtp() async {
    final phone = _phoneController.text.trim();
    final isValid = RegExp(r'^\d{10}$').hasMatch(phone);

    log("Phone $phone");
    if (!isValid) {
      log("validity $isValid");
      AppAlert.snackBarErrorAlert(context, 'Enter a valid 10-digit number');
      return;
    }

    setState(() {
      _resending = true;

      for (final c in _pinTextControllers) {
        c.clear();
      }
    });
    try {
      final otpService = ref.read(otpProvider);

      log('should validate phone: ${widget.validatePhone}');
      // Check if no user has phone Number
      if (widget.validatePhone == true) {
        final phoneExists = await otpService.checkPhoneNumber(phone);
        log('Phone number $phone has been used already');
        log('Phone exists: $phoneExists');
        if (mounted && phoneExists) {
          AppAlert.snackBarErrorAlert(
            context,
            'Phone number has already been taken.',
          );

          throw Exception('Phone already exists');
        }
      }

      final otpId = await otpService.sendOtp(phone);

      if (otpId != null) {
        setState(() {
          _otpId = otpId;
          _otpSent = true;
          _secondsLeft = 300;
        });
        _tickTimer();

        if (mounted) {
          AppAlert.snackBarSuccessAlert(context, 'OTP sent to $phone');
        }
      }
    } catch (e) {
      AppAlert.snackBarErrorAlert(context, 'Failed to send OTP');
    } finally {
      setState(() => _resending = false);
    }
  }

  // Future<void> _handleResend() async {
  //   await _handleSendOtp();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Confirm Phone number'),
        centerTitle: true,
        titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                _otpSent ? 'VERIFY OTP' : 'ENTER PHONE NUMBER',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Phone number input section
              ...[
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  readOnly: widget.phone != null,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: 'Enter your phone number',
                    // prefixText: '+',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        width: 2.0,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _handleSendOtp(),
                ),
                const SizedBox(height: 32),
                _otpSent
                    ? SizedBox()
                    : SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _resending ? null : _handleSendOtp,
                        child:
                            _resending
                                ? SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                )
                                : Text(
                                  'Send OTP',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
              ],

              // OTP verification section
              if (_otpSent) ...[
                Text(
                  'Please enter verification code sent to ${_phoneController.text}',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (_secondsLeft > 0)
                  Text.rich(
                    TextSpan(
                      text: 'OTP will expire in ',
                      style: Theme.of(context).textTheme.titleMedium,
                      children: [
                        TextSpan(
                          text: '$_secondsLeft',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: ' seconds'),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 70.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: OtpTextField(
                          index: 0,
                          pinFocusNodes: _pinFocusNodes,
                          pinTextControllers: _pinTextControllers,
                        ),
                      ),
                      Expanded(
                        child: OtpTextField(
                          index: 1,
                          pinFocusNodes: _pinFocusNodes,
                          pinTextControllers: _pinTextControllers,
                        ),
                      ),
                      Expanded(
                        child: OtpTextField(
                          index: 2,
                          pinFocusNodes: _pinFocusNodes,
                          pinTextControllers: _pinTextControllers,
                        ),
                      ),
                      Expanded(
                        child: OtpTextField(
                          index: 3,
                          pinFocusNodes: _pinFocusNodes,
                          pinTextControllers: _pinTextControllers,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _resending || _verifying ? null : _verifyOtp,
                    child:
                        _resending || _verifying
                            ? SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                backgroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                            : Text(
                              'Verify',
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 10.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Did not receive any code? ',
                    style: Theme.of(context).textTheme.bodyLarge,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Resend Code',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 20.0,
                          color: Theme.of(context).colorScheme.primary,
                          decorationColor:
                              Theme.of(context).colorScheme.primary,
                        ),
                        recognizer: _resending ? null : _tapRecognizer,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    final code = _pinTextControllers.map((c) => c.text).join();

    if (code.length != 4) {
      AppAlert.snackBarErrorAlert(context, 'Enter the 4-digit OTP');
      return;
    }

    setState(() => _verifying = true);
    try {
      final otpService = ref.read(otpProvider);
      final verified = await otpService.verifyOtp(_otpId, code);

      log('OTP ID $_otpId');
      log('OTP code $code');

      if (verified) {
        await widget.onPhoneNumberSubmitted(
          _phoneController.text.trim(),
          verified,
          ref,
        );

        if (mounted) {
          AppAlert.snackBarSuccessAlert(context, 'OTP Verified');
        }

        // Navigate to dashboard or next screen
      } else {
        if (mounted) {
          AppAlert.snackBarErrorAlert(context, 'Invalid OTP');
        }
      }
    } catch (e) {
      log("VERIFICATION RESPONSE: " + e.toString());
      if (mounted) {
        AppAlert.snackBarErrorAlert(context, 'Failed to verify OTP');
      }
    } finally {
      setState(() => _verifying = false);
    }
  }
}

class OtpTextField extends StatelessWidget {
  const OtpTextField({
    super.key,
    required int index,
    required List<FocusNode> pinFocusNodes,
    required List<TextEditingController> pinTextControllers,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
  }) : _pinFocusNodes = pinFocusNodes,
       _pinTextControllers = pinTextControllers,
       _padding = padding,
       _index = index;

  final int _index;
  final List<FocusNode> _pinFocusNodes;
  final List<TextEditingController> _pinTextControllers;
  final EdgeInsetsGeometry _padding;

  @override
  Widget build(BuildContext context) {
    final inputDecorator = InputDecoration(
      counterText: '',
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: 2.0,
        ),
      ),
    );

    return Padding(
      padding: _padding,
      child: TextField(
        keyboardType: TextInputType.number,
        focusNode: _pinFocusNodes[_index],
        controller: _pinTextControllers[_index],
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: inputDecorator,
        autofocus: _index == 0,
        onChanged: (text) {
          if (text.length == 1) {
            if (_index < 3) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).unfocus();
            }
          } else if (text.isEmpty) {
            if (_index > 0) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
        onSubmitted: (text) {
          if (text.length == 1 && _index < 3) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
