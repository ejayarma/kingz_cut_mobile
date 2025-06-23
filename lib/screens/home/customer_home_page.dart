import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kingz_cut_mobile/enums/service_type.dart';
import 'package:kingz_cut_mobile/models/service_category.dart';
import 'package:kingz_cut_mobile/screens/main_service_screen.dart';
import 'package:kingz_cut_mobile/state_providers/customer_notifer.dart';
import 'package:kingz_cut_mobile/state_providers/service_category_provider.dart';

class CustomerHomePage extends ConsumerWidget {
  const CustomerHomePage({super.key});

  void _goToHairStyleScreen(BuildContext context, ServiceCategory? category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MainServiceScreen(initialCategory: category),
      ),
    );
  }

  final Map<SalonServiceType, _ServiceCardStyle> predefinedStyles = const {
    SalonServiceType.haircut: _ServiceCardStyle(
      defaultTitle: 'Haircuts',
      imagePath: 'assets/images/services/haircut.png',
      bgColor: Color(0xFFD0E8FF),
      iconColor: Color(0xFF007AFF),
    ),
    SalonServiceType.beardGrooming: _ServiceCardStyle(
      defaultTitle: 'Beard Grooming',
      imagePath: 'assets/images/services/beard_grooming.png',
      bgColor: Color(0xFFFFE0E6),
      iconColor: Color(0xFFD00036),
    ),
    SalonServiceType.hairColoring: _ServiceCardStyle(
      defaultTitle: 'Hair Colouring',
      imagePath: 'assets/images/services/heari_coloring.png',
      bgColor: Color(0xFFFFF4D0),
      iconColor: Color(0xFFF57C00),
    ),
    SalonServiceType.washStyling: _ServiceCardStyle(
      defaultTitle: 'Wash & Styling',
      imagePath: 'assets/images/services/wash_styling.png',
      bgColor: Color(0xFFD8D6FB),
      iconColor: Color(0xFF6A1B9A),
    ),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final currentUser = FirebaseAuth.instance.currentUser;
    final categoriesAsync = ref.watch(serviceCategoriesProvider);
    final currentCustomer = ref.watch(customerNotifier);

    if (categoriesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (categoriesAsync.hasError) {
      return Center(child: Text('Error: ${categoriesAsync.error}'));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top search bar and notification
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search barbers, services',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Badge(
                label: Text('0'), // change as needed
                child: Icon(Icons.notifications),
              ),
            ],
          ),
        ),

        // Welcome banner
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.black, Color.fromARGB(183, 10, 10, 41)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: AssetImage('assets/images/barber_working.png'),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome,\n${currentCustomer.value?.name ?? ''}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Book your cut, pick your barber, and skip the wait!',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () => _goToHairStyleScreen(context, null),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF9A826),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Text(
            'Services',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        // SizedBox(height: 20),
        Expanded(
          child: categoriesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (categories) {
              return GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 5 / 3,
                padding: const EdgeInsets.all(16),
                children:
                    categories.map((category) {
                      final match = predefinedStyles.entries.firstWhere(
                        (entry) =>
                            entry.value.defaultTitle.toLowerCase() ==
                            category.name.toLowerCase(),
                        orElse:
                            () => const MapEntry(
                              SalonServiceType.haircut,
                              _ServiceCardStyle(
                                defaultTitle: '',
                                imagePath: 'assets/images/services/haircut.png',
                                bgColor: Colors.grey,
                                iconColor: Colors.black,
                              ),
                            ),
                      );

                      return InkWell(
                        onTap: () => _goToHairStyleScreen(context, category),
                        child: _buildServiceCard(
                          title: category.name,
                          style: match.value,
                        ),
                      );
                    }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String title,
    required _ServiceCardStyle style,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: style.bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 10,
            spreadRadius: 0.5,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          style: BorderStyle.solid,
          color: style.iconColor.withAlpha(50),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(
            AssetImage(style.imagePath),
            size: 32,
            color: style.iconColor,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ServiceCardStyle {
  final String defaultTitle;
  final String imagePath;
  final Color bgColor;
  final Color iconColor;

  const _ServiceCardStyle({
    required this.defaultTitle,
    required this.imagePath,
    required this.bgColor,
    required this.iconColor,
  });
}
