import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kingz_cut_mobile/screens/auth/create_account_screen.dart';
import 'package:kingz_cut_mobile/screens/auth/login_screen.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                        image: AssetImage('assets/images/kojo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Name
                  const Expanded(
                    child: Text(
                      'Kojo Jnr.',
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
                    'kojojnr@gmail.com',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 12),
                  Text(
                    'Accra - Ghana',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
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
              _buildSettingItemWithArrow(title: 'About'),
              _buildSettingItemWithArrow(title: 'Contact Us'),

              const Spacer(),

              // Logout button
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
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

  Widget _buildSettingItemWithArrow({required String title}) {
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
      onTap: () {},
    );

    // return Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 16.0),
    //   child: Row(
    //     children: [
    //       Text(
    //         title,
    //         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    //       ),
    //       const Spacer(),
    //       Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
    //     ],
    //   ),
    // );
  }
}
