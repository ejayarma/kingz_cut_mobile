import 'dart:developer';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kingz_cut_mobile/enums/user_type.dart';
import 'package:kingz_cut_mobile/models/notification_model.dart';
import 'package:kingz_cut_mobile/repositories/customer_repository.dart';
import 'package:kingz_cut_mobile/repositories/notification_repository.dart';
import 'package:kingz_cut_mobile/repositories/staff_repositoy.dart';
import 'package:kingz_cut_mobile/screens/auth/login_screen.dart';
import 'package:kingz_cut_mobile/screens/auth/otp_verification_page.dart';
import 'package:kingz_cut_mobile/screens/home/dashboard_screen.dart';
import 'package:kingz_cut_mobile/state_providers/app_config_notifier.dart';
import 'package:kingz_cut_mobile/state_providers/customer_notifer.dart';
import 'package:kingz_cut_mobile/state_providers/notification_notifier.dart';
import 'package:kingz_cut_mobile/state_providers/staff_notifier.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';
import 'package:kingz_cut_mobile/utils/custom_ui_block.dart';
import 'package:kingz_cut_mobile/utils/firebase_error_mapper.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  final Function(String, String, String)? onSignUp;
  final VoidCallback? onLoginTap;

  const CreateAccountScreen({super.key, this.onSignUp, this.onLoginTap});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(''),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Full Name field
                  const Text(
                    'Full Name',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email field
                  const Text(
                    'E-mail',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || !EmailValidator.validate(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password field
                  const Text(
                    'Password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Sign Up Button
                  FilledButton(
                    onPressed: _handleRegistration,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Google Sign Up Button
                  OutlinedButton.icon(
                    icon: Icon(FontAwesomeIcons.google),
                    onPressed: _registerWithGoogle,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    label: Text(
                      'Sign Up with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        // color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Login text
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already a user? ',
                          style: TextStyle(fontSize: 14),
                        ),
                        GestureDetector(
                          onTap:
                              widget.onLoginTap ??
                              () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return LoginScreen();
                                    },
                                  ),
                                );
                              },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<UserCredential?> _registerWithGoogle() async {
    try {
      if (mounted) {
        CustomUiBlock.block(context);
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Handle user cancellation
      if (googleUser == null) {
        if (mounted) {
          CustomUiBlock.unblock(context);
          AppAlert.snackBarErrorAlert(context, 'Google sign-in was cancelled.');
        }
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Verify we have the necessary tokens
      if (googleAuth?.accessToken == null || googleAuth?.idToken == null) {
        if (mounted) {
          CustomUiBlock.unblock(context);
          AppAlert.snackBarErrorAlert(
            context,
            'Failed to get Google authentication tokens.',
          );
        }
        return null;
      }

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth!.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential login = await FirebaseAuth.instance
          .signInWithCredential(credential);

      log('Google sign-in successful: ${login.user?.email}');

      // After registration, check if customer exists, then create if not
      final userId = login.user?.uid;
      if (userId != null) {
        final customerRepo = CustomerRepository();
        // For Google sign-in, use the Google user's display name
        final displayName = googleUser.displayName ?? login.user?.displayName;

        final customer = await customerRepo.createCustomerFromFirebaseUser(
          login.user!,
          displayName: displayName,
        );
        ref.read(customerNotifier.notifier).setCustomer(customer);
      }

      if (mounted) {
        CustomUiBlock.unblock(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return OtpVerificationScreen(
                phone: null,
                validatePhone: true,
                onPhoneNumberSubmitted: _handleOtpVerification,
              );
              // return DashboardScreen();
            },
          ),
        );
      }

      return login;
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth specific exceptions
      final errorMessage = FirebaseErrorMapper.getMessage(e.code);
      if (mounted) {
        AppAlert.snackBarErrorAlert(context, errorMessage);
        CustomUiBlock.unblock(context);
      }

      log(
        'Firebase Auth error during Google sign-in: ${e.code} - ${e.message}',
      );
      return null;
    } on PlatformException catch (e) {
      // Handle Google Sign-In specific platform exceptions
      String errorMessage;

      switch (e.code) {
        case 'sign_in_failed':
          errorMessage = 'Google sign-in failed. Please try again.';
          break;
        case 'network_error':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        case 'sign_in_canceled':
          errorMessage = 'Google sign-in was cancelled.';
          break;
        default:
          log(
            'Unexpected platform error during Google sign-in: ${e.code} - ${e.message}',
          );
          errorMessage =
              'An error occurred during Google sign-in. Please try again.';
          break;
      }

      if (mounted) {
        AppAlert.snackBarErrorAlert(context, errorMessage);
        CustomUiBlock.unblock(context);
      }

      log('Platform error during Google sign-in: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      // Handle any other unexpected errors
      log('Unexpected error during Google sign-in: $e');

      if (mounted) {
        AppAlert.snackBarErrorAlert(
          context,
          'An unexpected error occurred during Google sign-in. Please try again.',
        );
        CustomUiBlock.unblock(context);
      }

      return null;
    }
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      AppAlert.snackBarErrorAlert(context, 'Please provide all details');
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();

    try {
      CustomUiBlock.block(context);

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await credential.user?.updateDisplayName(name);
      await credential.user?.reload();

      // After registration, check if customer exists, then create if not
      final userId = credential.user?.uid;
      if (userId != null) {
        final customerRepo = CustomerRepository();
        final customer = await customerRepo.createCustomerFromFirebaseUser(
          credential.user!,
          displayName: name,
        );
        ref.read(customerNotifier.notifier).setCustomer(customer);
      }

      log('User registration successful: ${credential.user?.email}');
    } on FirebaseAuthException catch (e) {
      final errorMessage = FirebaseErrorMapper.getMessage(e.code);
      if (mounted) {
        AppAlert.snackBarErrorAlert(context, errorMessage);
        CustomUiBlock.unblock(context);
      }
      log('Firebase Auth error during registration: ${e.code} - ${e.message}');
      return;
    } catch (e) {
      log('Unexpected error during registration: $e');
      if (mounted) {
        AppAlert.snackBarErrorAlert(
          context,
          'An unexpected error occurred during registration. Please try again.',
        );
        CustomUiBlock.unblock(context);
      }
      return;
    }

    if (mounted) {
      CustomUiBlock.unblock(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return OtpVerificationScreen(
              phone: null,
              validatePhone: true,
              onPhoneNumberSubmitted: _handleOtpVerification,
            );
            // return DashboardScreen();
          },
        ),
      );
    }
  }

  Future<void> _handleOtpVerification(
    String phone,
    bool verified,
    WidgetRef ref,
  ) async {
    final notificationRepo = ref.read(notificationRepositoryProvider);

    if (verified) {
      final userType = ref.read(appConfigProvider).value?.userType;
      if (userType == UserType.customer) {
        final customer = await ref
            .read(customerRepositoryProvider)
            .getCustomerByUserId(FirebaseAuth.instance.currentUser?.uid ?? '');
        if (customer != null) {
          await ref
              .read(customerRepositoryProvider)
              .updateCustomer(customer.id, customer.copyWith(phone: phone));

          // Send customer registration  message
          final customerMessage =
              "Hello ${customer.name}, Welcome to Kingz Cut Mobile. Your customer account has been set up. You can start booking appointments. Enjoy!";

          log(
            'Sending message to customer: ${customer.toString()}, MESSAGE: $customerMessage',
          );
          await notificationRepo.createNotification(
            CreateNotificationRequest(
              uid: customer.userId,
              message: customerMessage,
            ),
          );
        }

        ref.invalidate(customerNotifier);
      }

      if (userType == UserType.barber) {
        final staff = await ref
            .read(staffRepositoryProvider)
            .getStaffByUserId(FirebaseAuth.instance.currentUser?.uid ?? '');
        if (staff != null) {
          await ref
              .read(staffRepositoryProvider)
              .updateStaff(staff.id, staff.copyWith(phone: phone));
          // Send staff registration  message
          final staffMessage =
              "Hello ${staff.name}, Welcome to Kingz Cut Mobile. Your barber account has been set up. You can start receiving appointment bookings. Enjoy!";
          log(
            'Sending message to staff: ${staff.toString()}, MESSAGE: $staffMessage',
          );
          await notificationRepo.createNotification(
            CreateNotificationRequest(uid: staff.userId, message: staffMessage),
          );
        }

        ref.invalidate(staffNotifier);
      }

      await FirebaseAuth.instance.currentUser?.reload();
      await Future.delayed(Durations.long2);

      await ref
          .read(notificationNotifierProvider.notifier)
          .fetchNotifications(FirebaseAuth.instance.currentUser?.uid ?? '');

      if (ref.context.mounted) {
        Navigator.of(ref.context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return DashboardScreen();
            },
          ),
        );
      }
    }
  }
}
