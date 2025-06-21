import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kingz_cut_mobile/screens/about_page.dart';
// import 'package:kingz_cut_mobile/screens/auth/create_account_screen.dart';
import 'package:kingz_cut_mobile/screens/auth/login_screen.dart';
import 'package:kingz_cut_mobile/state_providers/customer_provider.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';
import 'package:kingz_cut_mobile/utils/custom_ui_block.dart';

class CustomerProfilePage extends ConsumerStatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  ConsumerState<CustomerProfilePage> createState() =>
      _CustomerProfilePageState();
}

class _CustomerProfilePageState extends ConsumerState<CustomerProfilePage> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final currentCustomer = ref.watch(customerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // Profile header
              const Text(
                'Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Profile info section
              Row(
                children: [
                  // Profile image
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.onSecondary,
                        width: 2,
                      ),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/kingz_cut_logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Name
                  Expanded(
                    child: Text(
                      currentCustomer.value?.name ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Edit button
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                ],
              ),
              const SizedBox(height: 24),

              // Contact information
              Row(
                children: [
                  Icon(Icons.email, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Text(
                    currentCustomer.value?.email ?? '',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Row(
              //   children: [
              //     Icon(Icons.location_on, color: colorScheme.onSurfaceVariant),
              //     const SizedBox(width: 12),
              //     Text(
              //       'Accra - Ghana',
              //       style: TextStyle(
              //         color: colorScheme.onSurface,
              //         fontSize: 16,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 32),

              // Settings section
              Text(
                'Setting',
                style: TextStyle(fontSize: 16, color: colorScheme.tertiary),
              ),
              const SizedBox(height: 16),

              // Settings list
              _buildSettingItem(
                title: 'Notification',
                trailing: Switch(
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
              ),

              _buildSettingItemWithArrow(title: 'Account'),
              _buildSettingItemWithArrow(title: 'Security'),
              _buildSettingItemWithArrow(
                title: 'About',
                onTap: () {
                  // Navigate to the about screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
              ),
              _buildSettingItemWithArrow(title: 'Contact Us'),

              const Spacer(),

              // Logout button
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({required String title, required Widget trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          trailing,
        ],
      ),
    );
  }

  Widget _buildSettingItemWithArrow({
    required String title,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),

      trailing: Icon(
        Icons.chevron_right_rounded,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }

  Future<void> _handleLogout() async {
    try {
      if (mounted) {
        CustomUiBlock.block(context);
      }

      // Get current user to check sign-in providers
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Check if user signed in with Google and sign out from Google as well
        final List<UserInfo> providerData = currentUser.providerData;
        final bool signedInWithGoogle = providerData.any(
          (userInfo) => userInfo.providerId == 'google.com',
        );

        if (signedInWithGoogle) {
          try {
            // Sign out from Google to clear cached account
            await GoogleSignIn().signOut();
            log('Successfully signed out from Google');
          } catch (e) {
            // Log but don't fail the entire logout process
            log('Failed to sign out from Google: $e');
          }
        }

        // Sign out from Firebase
        await FirebaseAuth.instance.signOut();
        log('Successfully signed out from Firebase');
      }

      if (mounted) {
        CustomUiBlock.unblock(context);

        // Use pushAndRemoveUntil to clear the navigation stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false, // Remove all previous routes
        );
      }
    } on FirebaseAuthException catch (e) {
      log('Firebase Auth error during logout: ${e.code} - ${e.message}');

      if (mounted) {
        AppAlert.snackBarErrorAlert(
          context,
          'Logout failed. Please try again.',
        );
        CustomUiBlock.unblock(context);
      }
    } catch (e) {
      // Handle any other unexpected errors
      log('Unexpected error during logout: $e');

      if (mounted) {
        AppAlert.snackBarErrorAlert(
          context,
          'An unexpected error occurred during logout. Please try again.',
        );
        CustomUiBlock.unblock(context);
      }
    }
  }
}
