import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kingz_cut_mobile/state_providers/about_provider.dart';
import 'package:kingz_cut_mobile/utils/app_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kingz_cut_mobile/models/about.dart';

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    final aboutAsync = ref.watch(aboutProvider); // Adjust provider name

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'About',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: aboutAsync.when(
        data: (about) => _buildAboutContent(context, about),
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load about information',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(aboutProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildAboutContent(BuildContext context, About about) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Business Name
                    Text(
                      about.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Description
                    Text(
                      about.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Contact Information
                    if (about.phone.isNotEmpty ||
                        about.email.isNotEmpty ||
                        about.location.isNotEmpty)
                      _buildContactSection(about),

                    // Working Hours
                    if (about.workingHours.isNotEmpty)
                      _buildWorkingHoursSection(about),

                    // Social Media Links
                    _buildSocialMediaSection(context, about),
                  ],
                ),
              ),
            ),

            // Back Button
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(
                    0xFF4A9B8E,
                  ), // Teal color from image
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(About about) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),

        if (about.phone.isNotEmpty)
          _buildContactItem(
            icon: Icons.phone,
            text: about.phone,
            onTap: () => _launchUrl('tel:${about.phone}'),
          ),

        if (about.email.isNotEmpty)
          _buildContactItem(
            icon: Icons.email,
            text: about.email,
            onTap: () => _launchUrl('mailto:${about.email}'),
          ),

        if (about.location.isNotEmpty)
          _buildContactItem(
            icon: Icons.location_on,
            text: about.location,
            onTap:
                () => _launchUrl(
                  'https://maps.google.com/?q=${Uri.encodeComponent(about.location)}',
                ),
          ),

        if (about.website.isNotEmpty)
          _buildContactItem(
            icon: Icons.language,
            text: about.website,
            onTap: () => _launchUrl(about.website),
          ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Row(
            children: [
              Icon(icon, size: 20, color: const Color(0xFF4A9B8E)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkingHoursSection(About about) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Working Hours',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),

        ...about.workingHours.map(
          (hour) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hour.dayName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  hour.isActive
                      ? '${hour.openingTime} - ${hour.closingTime}'
                      : 'Closed',
                  style: TextStyle(
                    fontSize: 14,
                    color: hour.isActive ? Colors.grey[700] : Colors.red[400],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSocialMediaSection(BuildContext context, About about) {
    final socialMediaItems = [
      if (about.facebook.isNotEmpty)
        SocialMediaItem(
          icon: FontAwesomeIcons.facebook,
          url: about.facebook,
          label: 'Facebook',
        ),
      if (about.instagram.isNotEmpty)
        SocialMediaItem(
          icon: FontAwesomeIcons.instagram,
          url: about.instagram,
          label: 'Instagram',
        ),
      if (about.tiktok.isNotEmpty)
        SocialMediaItem(
          icon: FontAwesomeIcons.tiktok,
          url: about.tiktok,
          label: 'TikTok',
        ),
      if (about.x.isNotEmpty)
        SocialMediaItem(
          icon: FontAwesomeIcons.xTwitter,
          url: about.x,
          label: 'X (Twitter)',
        ),
      if (about.youtube.isNotEmpty)
        SocialMediaItem(
          icon: FontAwesomeIcons.youtube,
          url: about.youtube,
          label: 'YouTube',
        ),
      if (about.whatsapp.isNotEmpty)
        SocialMediaItem(
          icon: FontAwesomeIcons.whatsapp,
          url: about.whatsapp,
          label: 'WhatsApp',
        ),
    ];

    if (socialMediaItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Follow Us',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),

        Wrap(
          spacing: 16,
          runSpacing: 16,
          children:
              socialMediaItems
                  .map((item) => _buildSocialMediaButton(context, item))
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildSocialMediaButton(BuildContext context, SocialMediaItem item) {
    return InkWell(
      onTap: () => _launchUrl(item.url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: FaIcon(
          item.icon,
          size: 24,
          color: _getSocialMediaColor(item.label),
        ),
      ),
    );
  }

  Color _getSocialMediaColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'tiktok':
        return const Color(0xFF000000);
      case 'x (twitter)':
        return const Color(0xFF000000);
      case 'youtube':
        return const Color(0xFFFF0000);
      case 'whatsapp':
        return const Color(0xFF25D366);
      default:
        return Colors.grey[600]!;
    }
  }

  Future<void> _launchUrl(String url) async {
    try {
      String formattedUrl = url;
      if (!url.startsWith('http://') &&
          !url.startsWith('https://') &&
          !url.startsWith('tel:') &&
          !url.startsWith('mailto:')) {
        formattedUrl = 'https://$url';
      }

      debugPrint('Attempting to launch: $formattedUrl'); // Add this line

      final uri = Uri.parse(formattedUrl);

      final canLaunch = await canLaunchUrl(uri);
      debugPrint('Can launch URL: $canLaunch'); // Add this line

      if (canLaunch) {
        final result = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        debugPrint('Launch result: $result'); // Add this line
      } else {
        debugPrint('Cannot launch $formattedUrl');
        if (mounted) {
          AppAlert.snackBarErrorAlert(context, 'Could not open $formattedUrl');
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      if (mounted) {
        AppAlert.snackBarErrorAlert(context, 'Error opening link');
      }
    }
  }
}

class SocialMediaItem {
  final IconData icon;
  final String url;
  final String label;

  const SocialMediaItem({
    required this.icon,
    required this.url,
    required this.label,
  });
}
