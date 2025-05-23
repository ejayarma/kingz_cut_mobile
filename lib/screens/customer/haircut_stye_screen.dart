import 'package:flutter/material.dart';
import 'package:kingz_cut_mobile/screens/customer/service_selection_screen.dart';

// Main page widget
class HaircutStylesScreen extends StatelessWidget {
  const HaircutStylesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Haircut Styles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              hintText: 'Search haircut styles here...',
              leading: const Icon(Icons.search),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              elevation: WidgetStateProperty.all(0),
              backgroundColor: WidgetStateProperty.all(Colors.grey.shade100),
            ),
          ),

          // List of haircut styles
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children:
                  haircutStyles
                      .map((style) => HaircutStyleCard(haircutStyle: style))
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// Model class for haircut style data
class HaircutStyle {
  final String name;
  final String imagePath;
  final int durationInMinutes;
  final double price;
  final String currency;

  const HaircutStyle({
    required this.name,
    required this.imagePath,
    required this.durationInMinutes,
    required this.price,
    required this.currency,
  });
}

// Reusable card widget for each haircut style
class HaircutStyleCard extends StatelessWidget {
  final HaircutStyle haircutStyle;

  const HaircutStyleCard({super.key, required this.haircutStyle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Style image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                haircutStyle.imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),

            // Style details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    haircutStyle.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${haircutStyle.durationInMinutes}mins',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${haircutStyle.currency} ${haircutStyle.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Book button
            FilledButton(
              onPressed: () {
                // ServiceSelectionScreen
                 Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ServiceSelectionScreen();
                      },
                    ),
                  );
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}

// Sample data
final List<HaircutStyle> haircutStyles = [
  HaircutStyle(
    name: 'Fading',
    imagePath: 'assets/images/hairstyles/fading.jpg',
    durationInMinutes: 30,
    price: 15.00,
    currency: 'GHS',
  ),
  HaircutStyle(
    name: 'Lowcut',
    imagePath: 'assets/images/hairstyles/low_cut.jpg',
    durationInMinutes: 30,
    price: 15.00,
    currency: 'GHS',
  ),
  HaircutStyle(
    name: 'Buzz cut',
    imagePath: 'assets/images/hairstyles/buzz_cut.jpg',
    durationInMinutes: 30,
    price: 15.00,
    currency: 'GHS',
  ),
  HaircutStyle(
    name: 'Curls cut',
    imagePath: 'assets/images/hairstyles/curls_cut.jpg',
    durationInMinutes: 30,
    price: 15.00,
    currency: 'GHS',
  ),
  HaircutStyle(
    name: 'Side part',
    imagePath: 'assets/images/hairstyles/side_part.jpg',
    durationInMinutes: 30,
    price: 15.00,
    currency: 'GHS',
  ),
];
