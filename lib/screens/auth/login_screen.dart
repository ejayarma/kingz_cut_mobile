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
import 'package:kingz_cut_mobile/screens/customer/home/customer_dashboard_screen.dart';
import 'package:kingz_cut_mobile/state_providers/app_config_notifier.dart';
import 'package:kingz_cut_mobile/state_providers/customer_provider.dart';
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

      // // Trigger the authentication flow

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

      // After registration, check if customer/staff exists,
      final userId = login.user?.uid;
      if (userId != null) {
        await _checkCustomerOrStaff(userId);
      }

      log('Google sign-in successful: ${login.user?.email}');

      if (mounted) {
        CustomUiBlock.unblock(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return CustomerDashboardScreen();
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
    } on CustomerNotFoundException catch (e) {
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
    } finally {
      if (FirebaseAuth.instance.currentUser != null) {}
    }
  }

  /// Throws [CustomerNotFoundException], [StaffNotFoundException] if the user is not found.
  Future<void> _checkCustomerOrStaff(String userId) async {
    final customerRepo = ref.read(customerRepositoryProvider);
    final staffRepo = ref.read(staffRepositoryProvider);
    // final customerNotifier = ref.watch(customerProvider);

    // log current firebase user
    final currentUser = FirebaseAuth.instance.currentUser;
    log('Current Firebase user email: ${currentUser?.email}');
    log('Current Firebase user id: ${currentUser?.uid}');

    final customer = await customerRepo.getCustomerByUserId(userId);
    if (customer != null) {
      log('Customer found: ${customer.toString()}');
    } else {
      log('No customer found for userId: $userId');
    }
    final appConfig = ref.read(appConfigProvider);
    final staffExists = await staffRepo.staffExists(userId);
    final customerExists = customer != null;

    if (!customerExists &&
        appConfig.valueOrNull?.userType == UserType.customer) {
      throw CustomerNotFoundException();
    }
    if (!staffExists && appConfig.valueOrNull?.userType == UserType.barber) {
      throw StaffNotFoundException();
    }
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
        await _checkCustomerOrStaff(userId);
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

    // Success case
    if (mounted) {
      CustomUiBlock.unblock(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return CustomerDashboardScreen();
          },
        ),
      );
    }
  }
}
