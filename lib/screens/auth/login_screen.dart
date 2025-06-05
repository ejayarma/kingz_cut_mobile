import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kingz_cut_mobile/screens/auth/create_account_screen.dart';
import 'package:kingz_cut_mobile/screens/auth/forgot_password_screen.dart';
import 'package:kingz_cut_mobile/screens/customer/home/customer_dashboard_screen.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kingz_cut_mobile/utils/custom_ui_block.dart';

class LoginScreen extends StatefulWidget {
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
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      String errorMessage;

      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage =
              'An account already exists with this email using a different sign-in method. Please try signing in with your original method.';
          break;
        case 'invalid-credential':
          errorMessage =
              'The Google sign-in credential is invalid or has expired. Please try again.';
          break;
        case 'operation-not-allowed':
          errorMessage =
              'Google sign-in is not enabled. Please contact support.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for this account.';
          break;
        case 'wrong-password':
          errorMessage = 'Authentication failed. Please try again.';
          break;
        case 'invalid-verification-code':
          errorMessage = 'Invalid verification code. Please try again.';
          break;
        case 'invalid-verification-id':
          errorMessage = 'Invalid verification ID. Please try again.';
          break;
        default:
          log(
            'Unexpected Firebase Auth error during Google sign-in: ${e.code} - ${e.message}',
          );
          errorMessage = 'Google sign-in failed. Please try again.';
          break;
      }

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

  // Future<UserCredential> signInWithGoogle() async {
  //   if (mounted) {
  //     CustomUiBlock.block(context);
  //   }
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   if (mounted) {
  //     CustomUiBlock.unblock(context);
  //   }

  //   var login = await FirebaseAuth.instance.signInWithCredential(credential);

  //   log(login.toString());
  //   log(login.user.toString());

  //   if (mounted) {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return CustomerDashboardScreen();
  //         },
  //       ),
  //     );
  //   }

  //   return login;
  // }

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

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Handle all possible Firebase Auth exceptions
      String errorMessage;

      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for that email address.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later.';
          break;
        case 'user-token-expired':
          errorMessage = 'Your session has expired. Please sign in again.';
          break;
        case 'network-request-failed':
          errorMessage =
              'Network error. Please check your internet connection.';
          break;
        case 'INVALID_LOGIN_CREDENTIALS':
        case 'invalid-credential':
          errorMessage =
              'Invalid email or password. Please check your credentials.';
          break;
        case 'operation-not-allowed':
          errorMessage =
              'Email/password sign-in is not enabled. Please contact support.';
          break;
        default:
          // Log unexpected errors for debugging
          log('Unexpected Firebase Auth error: ${e.code} - ${e.message}');
          errorMessage = 'Something went wrong. Please try again.';
          break;
      }

      if (mounted) {
        AppAlert.snackBarErrorAlert(context, errorMessage);
        CustomUiBlock.unblock(context);
      }
      return;
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
