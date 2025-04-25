import 'package:flutter/material.dart';
import 'package:kingz_cut_mobile/enums/service_type.dart';
import 'package:kingz_cut_mobile/screens/customer/haircut_stye_screen.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  void _goToHairStyleScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return HaircutStylesScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top search bar and notification
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: const [
                      SizedBox(width: 10),
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Search barbers, haircut service',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              Badge.count(count: 2, child: Icon(Icons.notifications)),
            ],
          ),
        ),

        // Welcome banner
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            // color: const Color(0xFF0A0A29),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black,
                Colors.black,
                Colors.black,
                Color.fromARGB(183, 10, 10, 41),
              ],
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
                const Text(
                  'Welcome,\nKojo Jnr.',
                  style: TextStyle(
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
                ElevatedButton(
                  onPressed: _goToHairStyleScreen,
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // View on Map button
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: TextButton.icon(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.location_on_rounded,
        //       color: Colors.blueAccent,
        //     ),
        //     label: const Text(
        //       'View on Map',
        //       style: TextStyle(
        //         color: Colors.blueAccent,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //   ),
        // ),

        // Services section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Text(
            'Services',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),

        // Service grid
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 4 / 3,
            padding: EdgeInsets.all(16),
            children: [
              InkWell(
                onTap: _goToHairStyleScreen,
                child: _buildServiceCard(
                  title: 'Haircuts',
                  serviceType: SalonServiceType.haircut,
                  color: Colors.blue.shade100,
                  iconColor: Colors.blue.shade600,
                ),
              ),
              InkWell(
                onTap: _goToHairStyleScreen,
                child: _buildServiceCard(
                  title: 'Beard Grooming',
                  serviceType: SalonServiceType.beardGrooming,
                  color: Colors.pink.shade100,
                  iconColor: Colors.red,
                ),
              ),
              InkWell(
                onTap: _goToHairStyleScreen,
                child: _buildServiceCard(
                  title: 'Hair Coloring',
                  serviceType: SalonServiceType.hairColoring,
                  color: Colors.amber.shade100,
                  iconColor: Colors.orange,
                ),
              ),
              InkWell(
                onTap: _goToHairStyleScreen,
                child: _buildServiceCard(
                  title: 'Wash & Styling',
                  serviceType: SalonServiceType.washStyling,
                  color: Colors.indigo.shade100,
                  iconColor: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String title,
    required SalonServiceType serviceType,
    required Color color,
    required Color iconColor,
  }) {
    final imagePath = switch (serviceType) {
      SalonServiceType.haircut => 'assets/images/services/haircut.png',
      SalonServiceType.beardGrooming =>
        'assets/images/services/beard_grooming.png',
      SalonServiceType.hairColoring =>
        'assets/images/services/heari_coloring.png',
      SalonServiceType.washStyling => 'assets/images/services/wash_styling.png',
    };

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 10,
            spreadRadius: 0.5,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(
          style: BorderStyle.solid,
          color: iconColor.withAlpha(50),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(AssetImage(imagePath), size: 32, color: iconColor),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
