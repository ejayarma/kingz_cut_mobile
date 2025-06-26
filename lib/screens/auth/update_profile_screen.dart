import 'dart:developer';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/enums/user_type.dart';
import 'package:kingz_cut_mobile/repositories/customer_repository.dart';
import 'package:kingz_cut_mobile/repositories/staff_repositoy.dart';
import 'package:kingz_cut_mobile/state_providers/app_config_notifier.dart';
import 'package:kingz_cut_mobile/state_providers/customer_notifer.dart';
import 'package:kingz_cut_mobile/state_providers/otp_provider.dart';
import 'package:kingz_cut_mobile/state_providers/staff_notifier.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';
import 'package:kingz_cut_mobile/utils/custom_ui_block.dart';
import 'package:kingz_cut_mobile/utils/firebase_error_mapper.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;

  const UpdateProfileScreen({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
  });

  @override
  ConsumerState<UpdateProfileScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
    _phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
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
                      'Update Account',
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
                    readOnly: true,
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

                  // Full Name field
                  const Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    validator: (value) {
                      if (value == null || value.length != 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
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

                  // Sign Up Button
                  FilledButton(
                    onPressed: _handleUpdate,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) {
      AppAlert.snackBarErrorAlert(context, 'Please provide all details');
      return;
    }

    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final name = _nameController.text.trim();

    try {
      CustomUiBlock.block(context);

      final userType = ref.read(appConfigProvider).value?.userType;
      if (userType == UserType.customer) {
        final customer = await ref
            .read(customerRepositoryProvider)
            .getCustomerByUserId(FirebaseAuth.instance.currentUser?.uid ?? '');
        if (customer != null) {
          await ref
              .read(customerRepositoryProvider)
              .updateCustomer(
                customer.id,
                customer.copyWith(phone: phone, name: name, email: email),
              );
        }

        ref.invalidate(customerNotifier);
      }

      if (widget.initialPhone.isEmpty) {
        final otpService = ref.read(otpProvider);

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

      if (userType == UserType.barber) {
        final staff = await ref
            .read(staffRepositoryProvider)
            .getStaffByUserId(FirebaseAuth.instance.currentUser?.uid ?? '');
        if (staff != null) {
          await ref
              .read(staffRepositoryProvider)
              .updateStaff(
                staff.id,
                staff.copyWith(phone: phone, name: name, email: email),
              );
        }
        ref.invalidate(staffNotifier);
      }

      await FirebaseAuth.instance.currentUser?.reload();
      await Future.delayed(Durations.long2);
    } on FirebaseAuthException catch (e) {
      final errorMessage = FirebaseErrorMapper.getMessage(e.code);
      if (mounted) {
        AppAlert.snackBarErrorAlert(context, errorMessage);
        CustomUiBlock.unblock(context);
      }
      log(
        'Firebase Auth error during profile update: ${e.code} - ${e.message}',
      );
      return;
    } catch (e) {
      log('Unexpected error during profile update: $e');
      if (mounted) {
        AppAlert.snackBarErrorAlert(
          context,
          'An unexpected error occurred during profile update. Please try again.',
        );
        CustomUiBlock.unblock(context);
      }
      return;
    }

    if (mounted) {
      CustomUiBlock.unblock(context);
      Navigator.of(context).pop();
    }
  }
}
