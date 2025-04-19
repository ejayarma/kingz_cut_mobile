import 'package:kingz_cut_mobile/models/user_detail.dart';
import 'package:kingz_cut_mobile/screens/wrappers/default_screen_wrapper.dart';
import 'package:kingz_cut_mobile/state_providers/user_provider.dart';
import 'package:kingz_cut_mobile/utils/api_util.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';
import 'package:kingz_cut_mobile/utils/custom_ui_block.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';

import '../login_screen.dart';
import '../register_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailOrPhoneController = TextEditingController();
  ApiUtil get apiUtil => ApiUtil(context);
  UserDetail get user => context.read<UserProvider>().currentUser!;
  // late final TextEditingController _idController =
  //       TextEditingController();

  @override
  void dispose() {
    emailOrPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScreenWrapper(
      title: "Forgot Password",
      showAction: false,
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Image.asset(
                  'assets/images/kingz_cut_logo.png',
                  height: 70,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Enter your email or phone number to reset your password.',
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                return null;
                              }
                              return "This field is required";
                            },
                            decoration: InputDecoration(
                              errorStyle: TextStyle(color: Colors.red),
                              hintText: "Email / Phone Number *",
                            ),
                            controller: emailOrPhoneController,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: _handleResetPassword,
                            child: Text(
                              'RESET PASSWORD',
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const SignUpScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Don\'t have account?',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign me in',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleResetPassword() async {
    CustomUiBlock.block(context);
    print('haha');

    try {
      final response = await apiUtil.handleResponse<Map<String, dynamic>>(
        request:
            () => apiUtil.httpClient.post(
              '/citizen/auth/forgot-password',
              data: {"identifier": emailOrPhoneController.text},
            ),
      );

      if (!response.success) {
        throw Exception(response.message);
      }

      Logger().i(response.data);

      // await userProv.updateProfile(updatedUser);

      if (mounted) {
        AppAlert.snackBarSuccessAlert(
          context,
          "Password reset link sent. Check your email inbox.",
        );
      }
    } catch (e) {
      // debugPrint(e.toString());
      if (mounted) {
        AppAlert.snackBarErrorAlert(context, e.toString());
      }
    } finally {
      if (mounted) {
        CustomUiBlock.unblock(context);
      }
    }
  }

  // void _handleResetPassword() async {
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }

  //   try {
  //     // await AuthService.resetPassword(emailOrPhoneController.text);
  //     // Show success message to the user
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //             'Password reset instructions sent to ${emailOrPhoneController.text}'),
  //       ),
  //     );
  //     // Optionally, navigate the user to the login screen
  //     Navigator.pushNamed(context, '/login');
  //   } catch (e) {
  //     // Handle reset password error
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to reset password: $e'),
  //       ),
  //     );
  //   }
  // }
}
