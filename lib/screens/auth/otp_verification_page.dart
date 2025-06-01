import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utils/app_alert.dart';

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({
    super.key,
    required this.phone,
  });
  final String phone;

  static const route = '/otp';

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  late TapGestureRecognizer _tapRecognizer;

  late List<TextEditingController> _pinTextControllers;
  late List<FocusNode> _pinFocusNodes;
  bool _resending = false;
  bool _verifying = false;
  int _secondsLeft = -1;

  @override
  void initState() {
    super.initState();

    _handleResend().then((_) => _tickTimer());

    _tapRecognizer = TapGestureRecognizer()..onTap = _handleResend;

    _pinTextControllers = List.generate(
      4,
      (_) => TextEditingController(),
    );

    _pinFocusNodes = List.generate(
      4,
      (_) => FocusNode(),
    );
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();

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
      }
    });
  }

  Future<void> _handleResend() async {
    if (_resending) {
      return;
    }
    setState(() => _resending = true);
    var data = {
      'phone_number': widget.phone,
      "email": '',
      // "email": context.read<AuthStateService>().userEmail,
    };

    // await ApiBase.httpClient
    //     .post(
    //   '${ApiBase.otpServiceUrl}/generateOtp',
    //   data: data,
    // )
    //     .then((response) async {
    //   if (response.statusCode == 200 &&
    //       response.data['api_status'] == 'success') {
    //     int minutes = response.data['api_data']['duration'];
    //     setState(() {
    //       _secondsLeft = 60 * minutes;
    //     });
    //     AppAlert.snackBarSuccessAlert(context, 'OTP sent');
    //   }
    // }).catchError(ApiBase.onErrorWithContext(context));

    setState(() => _resending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 3.5 * kToolbarHeight,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Image.asset(
          'assets/images/bdr_splash_small.png',
          width: double.maxFinite,
        ),
        // title: IntroAppBarTitle(
        //   title: 'Enter OTP',
        //   subtitle: 'Please enter verification code sent to +${widget.phone}',
        // ),
      ),
      body: Container(
        // height:
        //     MediaQuery.of(context).size.height - 3.5 * kToolbarHeight - 64.0,
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 20),
            Text(
              'VERIFY OTP',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (_secondsLeft > 0)
              Text.rich(TextSpan(
                  text: 'OTP will expire in ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                    TextSpan(
                      text: '$_secondsLeft',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' seconds'),
                  ])),
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
                        pinTextControllers: _pinTextControllers),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32.0),
                SizedBox(
                  height: 50,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    onPressed: _resending || _verifying ? null : _verifyOtp,
                    child: _resending || _verifying
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
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _verifyOtp() async {
    setState(() => _verifying = true);

    String userOtpCode = '';
    for (final controller in _pinTextControllers) {
      userOtpCode += controller.text;
    }

    if (userOtpCode.length != 4) {
      AppAlert.snackBarErrorAlert(context, "Invalid OTP");
      setState(() => _verifying = false);
      return;
    }

    var data = {
      'phone_number': widget.phone,
      'email': '',
      'code': userOtpCode,
    };

    log(data.toString());
    // return;

    // await ApiBase.httpClient
    //     .post(
    //   '${ApiBase.otpServiceUrl}/verifyOtp',
    //   data: data,
    // )
    //     .then((response) {
    //   if (response.statusCode == 200) {
    //     // AppAlert.snackBarSuccessAlert(context, 'OTP Verification successful');
    //     GoRouter.of(context).pop(true);
    //   } else {
    //     // AppAlert.snackBarErrorAlert(context, 'OTP Verification failed');
    //     GoRouter.of(context).pop(false);
    //   }
    // }).catchError(ApiBase.onErrorWithContext(context));
    setState(() => _verifying = false);
  }
}

class OtpTextField extends StatelessWidget {
  const OtpTextField({
    super.key,
    required int index,
    required List<FocusNode> pinFocusNodes,
    required List<TextEditingController> pinTextControllers,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
  })  : _pinFocusNodes = pinFocusNodes,
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
            color: Theme.of(context).colorScheme.primary, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: Theme.of(context).colorScheme.inversePrimary, width: 2.0),
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
        // obscureText: true,
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

        // onEditingComplete: () {},
      ),
    );
  }
}
