import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kingz_cut_mobile/screens/auth/create_account_screen.dart';
import 'package:kingz_cut_mobile/screens/auth/login_screen.dart';
import 'package:kingz_cut_mobile/screens/home/dashboard_screen.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';
import 'package:kingz_cut_mobile/utils/custom_ui_block.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final Function(String, String)? onLogin;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onSignUpTap;

  const ForgotPasswordScreen({
    super.key,
    this.onLogin,
    this.onForgotPassword,
    this.onSignUpTap,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Text(
                    'Please enter your email for the password reset process',
                    textAlign: TextAlign.center,
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
                      if (value == null ||
                          value.isEmpty ||
                          !EmailValidator.validate(value)) {
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

                  // Login Button
                  // Sign Up Button
                  FilledButton(
                    onPressed: _handleForgotPassword,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
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

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) {
      AppAlert.snackBarErrorAlert(context, 'Please provide all details');
      return;
    }

    if (widget.onLogin != null) {
      widget.onLogin!(_emailController.text.trim(), _passwordController.text);
      return;
    }

    final email = _emailController.text.trim();
    bool emailSent = false;

    try {
      if (mounted) {
        CustomUiBlock.block(context);
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      log('Password reset email sent successfully to: $email');

      // Set success flag for navigation outside try-catch
      emailSent = true;
    } on FirebaseAuthException catch (e) {
      // Handle all possible Firebase Auth exceptions for password reset
      String errorMessage;

      switch (e.code) {
        case 'auth/invalid-email':
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'auth/user-not-found':
        case 'user-not-found':
          // Note: This may not be thrown when email enumeration protection is enabled
          errorMessage = 'No account found with this email address.';
          break;
        case 'auth/missing-android-pkg-name':
          errorMessage = 'Configuration error. Please contact support.';
          break;
        case 'auth/missing-continue-uri':
          errorMessage = 'Configuration error. Please contact support.';
          break;
        case 'auth/missing-ios-bundle-id':
          errorMessage = 'Configuration error. Please contact support.';
          break;
        case 'auth/invalid-continue-uri':
          errorMessage = 'Configuration error. Please contact support.';
          break;
        case 'auth/unauthorized-continue-uri':
          errorMessage = 'Configuration error. Please contact support.';
          break;
        case 'too-many-requests':
          errorMessage =
              'Too many password reset requests. Please try again later.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        default:
          // Log unexpected errors for debugging
          log(
            'Unexpected Firebase Auth error during password reset: ${e.code} - ${e.message}',
          );
          errorMessage =
              'Failed to send password reset email. Please try again.';
          break;
      }

      if (mounted) {
        AppAlert.snackBarErrorAlert(context, errorMessage);
      }

      log(
        'Firebase Auth error during password reset: ${e.code} - ${e.message}',
      );
    } catch (e) {
      // Handle any other unexpected errors
      log('Unexpected error during password reset: $e');

      if (mounted) {
        AppAlert.snackBarErrorAlert(
          context,
          'An unexpected error occurred. Please try again.',
        );
      }
    } finally {
      // Always unblock UI regardless of success or failure
      if (mounted) {
        CustomUiBlock.unblock(context);
      }
    }

    // Handle success navigation outside try-catch
    if (emailSent && mounted) {
      AppAlert.snackBarSuccessAlert(
        context,
        'Password reset link has been sent to your email address. Please check your inbox.',
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ),
      );
    }
  }
}
