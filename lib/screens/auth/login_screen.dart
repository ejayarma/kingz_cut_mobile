import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kingz_cut_mobile/enums/user_type.dart';
import 'package:kingz_cut_mobile/exceptions/customer_not_found_exception.dart';
import 'package:kingz_cut_mobile/exceptions/staff_not_found_exception.dart';
import 'package:kingz_cut_mobile/repositories/customer_repository.dart';
import 'package:kingz_cut_mobile/repositories/staff_repositoy.dart';
import 'package:kingz_cut_mobile/screens/auth/create_account_screen.dart';
import 'package:kingz_cut_mobile/screens/auth/forgot_password_screen.dart';
import 'package:kingz_cut_mobile/screens/auth/otp_verification_page.dart';
import 'package:kingz_cut_mobile/screens/home/dashboard_screen.dart';
import 'package:kingz_cut_mobile/state_providers/app_config_notifier.dart';
import 'package:kingz_cut_mobile/state_providers/customer_notifer.dart';
import 'package:kingz_cut_mobile/state_providers/staff_notifier.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kingz_cut_mobile/utils/custom_ui_block.dart';
import 'package:kingz_cut_mobile/utils/firebase_error_mapper.dart';
import 'package:kingz_cut_mobile/utils/platform_error_mapper.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final Function(String, String)? onLogin;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onSignUpTap;

  const LoginScreen({
    super.key,
    this.onLogin,
    this.onForgotPassword,
    this.onSignUpTap,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _logAppConfig();
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
                      'Sign in',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email field
                  const Text(
                    'E-mail',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || !EmailValidator.validate(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
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
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
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
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Forgot password
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed:
                          widget.onForgotPassword ??
                          () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ForgotPasswordScreen();
                                },
                              ),
                            );
                          },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  // Sign Up Button
                  FilledButton(
                    onPressed: _handleSignIn,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Google Sign in Button
                  OutlinedButton.icon(
                    icon: Icon(FontAwesomeIcons.google),
                    onPressed: signInWithGoogle,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    label: Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        // color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Sign up text
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account? ',
                          style: TextStyle(fontSize: 14),
                        ),
                        GestureDetector(
                          onTap:
                              widget.onSignUpTap ??
                              () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return CreateAccountScreen();
                                    },
                                  ),
                                );
                              },
                          child: Text(
                            'Sign Up',
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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (mounted) {
        CustomUiBlock.block(context);
      }

      // Trigger the authentication flow
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Clear any cached account to force selection
      await googleSignIn.signOut();

      // Now sign in - this will always show account picker
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

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

      // After registration, check if customer/staff exists and handle navigation
      final userId = login.user?.uid;
      if (userId != null) {
        final shouldNavigateToDashboard = await _checkCustomerOrStaff(userId);

        // Only navigate to dashboard if OTP verification is not needed
        if (mounted && shouldNavigateToDashboard) {
          CustomUiBlock.unblock(context);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return DashboardScreen();
              },
            ),
          );
        } else if (mounted) {
          CustomUiBlock.unblock(context);
        }
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
    } on CustomerNotFoundException catch (e) {
      await _failedLogout();
      if (mounted) {
        CustomUiBlock.unblock(context);
        AppAlert.snackBarErrorAlert(
          context,
          'Customer not found. Please create an account.',
        );
      }
      log('Customer not found during Google sign-in: $e');
      return null;
    } on StaffNotFoundException catch (e) {
      await _failedLogout();
      if (mounted) {
        CustomUiBlock.unblock(context);
        AppAlert.snackBarErrorAlert(
          context,
          'Staff not found. Please create an account.',
        );
      }
      log('Staff not found during Google sign-in: $e');
      return null;
    } on PlatformException catch (e) {
      final errorMessage = PlatformErrorMapper.getMessage(
        e.code,
        context: 'Google sign-in',
      );

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

  /// Returns true if should navigate to dashboard, false if OTP verification is needed
  /// Throws [CustomerNotFoundException], [StaffNotFoundException] if the user is not found.
  Future<bool> _checkCustomerOrStaff(String userId) async {
    final customerRepo = ref.read(customerRepositoryProvider);
    final staffRepo = ref.read(staffRepositoryProvider);

    // log current firebase user
    final currentUser = FirebaseAuth.instance.currentUser;
    log('Current Firebase user email: ${currentUser?.email}');
    log('Current Firebase user id: ${currentUser?.uid}');

    String? phone;

    final customer = await customerRepo.getCustomerByUserId(userId);
    if (customer != null) {
      log('Customer found: ${customer.toJson().toString()}');
      phone = customer.phone;
      // Update state in CustomerProvider
      ref.read(customerNotifier.notifier).setCustomer(customer);
    } else {
      log('No customer found for userId: $userId');
    }

    final staff = await staffRepo.getStaffByUserId(userId);
    if (staff != null) {
      log('Staff found: ${staff.toJson().toString()}');
      phone = staff.phone;
      // Update state in StaffProvider if needed
      ref.read(staffNotifier.notifier).setStaff(staff);
    } else {
      log('No staff found for userId: $userId');
    }

    final appConfig = ref.read(appConfigProvider);
    final customerExists = customer != null;
    final staffExists = staff != null;

    if (!customerExists && appConfig.value?.userType == UserType.customer) {
      throw CustomerNotFoundException();
    } else if (customerExists && customer.active != true) {
      throw CustomerNotFoundException();
    }
    if (!staffExists && appConfig.value?.userType == UserType.barber) {
      throw StaffNotFoundException();
    } else if (staffExists && staff.active != true) {
      throw StaffNotFoundException();
    }

    // Any user without phone will verify
    if ((phone == null || phone.isEmpty) && mounted) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return OtpVerificationScreen(
              phone: null,
              validatePhone: true,
              onPhoneNumberSubmitted: _handleOtpVerification,
            );
          },
        ),
      );
      return false; // Don't navigate to dashboard
    }
    // Staff verify OTP always
    else if (staffExists && phone != null && phone.isNotEmpty && mounted) {
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return OtpVerificationScreen(
              phone: phone,
              validatePhone: false,
              onPhoneNumberSubmitted: _handleStaffOtpVerification,
            );
          },
        ),
      );
      return false; // Don't navigate to dashboard
    }

    return true; // Navigate to dashboard if no phone verification needed
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      AppAlert.snackBarErrorAlert(context, 'Please provide all details');
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (widget.onLogin != null) {
      widget.onLogin!(email, password);
      return;
    }

    try {
      CustomUiBlock.block(context);

      final UserCredential login = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final userId = login.user?.uid;
      if (userId != null) {
        final shouldNavigateToDashboard = await _checkCustomerOrStaff(userId);

        log('shouldNavigateToDashboard: $shouldNavigateToDashboard');

        // Only navigate to dashboard if OTP verification is not needed
        if (mounted && shouldNavigateToDashboard) {
          CustomUiBlock.unblock(context);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return DashboardScreen();
              },
            ),
          );
        } else if (mounted) {
          CustomUiBlock.unblock(context);
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle all possible Firebase Auth exceptions
      final errorMessage = FirebaseErrorMapper.getMessage(e.code);
      if (mounted) {
        AppAlert.snackBarErrorAlert(context, errorMessage);
        CustomUiBlock.unblock(context);
      }
      return;
    } on PlatformException catch (e) {
      final errorMessage = PlatformErrorMapper.getMessage(
        e.code,
        context: 'Email/Password sign-in',
      );

      if (mounted) {
        AppAlert.snackBarErrorAlert(context, errorMessage);
        CustomUiBlock.unblock(context);
      }

      log(
        'Platform error during Email/Password sign-in: ${e.code} - ${e.message}',
      );
    } on CustomerNotFoundException catch (e) {
      if (mounted) {
        CustomUiBlock.unblock(context);
        AppAlert.snackBarErrorAlert(
          context,
          'Customer not found. Please create an account.',
        );
      }
      log('Customer not found during Email/Password sign-in: $e');
    } on StaffNotFoundException catch (e) {
      if (mounted) {
        CustomUiBlock.unblock(context);
        AppAlert.snackBarErrorAlert(
          context,
          'Staff not found. Please create an account.',
        );
      }
      log('Staff not found during Email/Password sign-in: $e');
    } catch (e) {
      // Handle any other unexpected errors
      log('Unexpected error during sign-in: $e');
      if (mounted) {
        AppAlert.snackBarErrorAlert(
          context,
          'An unexpected error occurred. Please try again.',
        );
        CustomUiBlock.unblock(context);
      }
      return;
    }
  }

  void _logAppConfig() async {
    final appConfig = await ref.read(appConfigProvider.future);
    log('🔧 AppConfig loaded: = ${appConfig?.toJson().toString()}');
  }

  Future<void> _failedLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      log('Error during logout: $e');
    }
  }

  Future<void> _handleOtpVerification(
    String phone,
    bool verified,
    WidgetRef ref,
  ) async {
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
        }
        ref.invalidate(staffNotifier);
      }

      await FirebaseAuth.instance.currentUser?.reload();
      await Future.delayed(Durations.long2);

      if (ref.context.mounted) {
        Navigator.of(ref.context).push(
          MaterialPageRoute(
            builder: (_) {
              return DashboardScreen();
            },
          ),
        );
      }
    }
  }

  Future<void> _handleStaffOtpVerification(
    String phone,
    bool verified,
    WidgetRef ref,
  ) async {
    if (verified) {
      if (ref.context.mounted) {
        Navigator.of(ref.context).push(
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
