import 'package:flutter/material.dart';
import 'package:kingz_cut_mobile/screens/customer/booking_screen.dart';
import 'package:kingz_cut_mobile/screens/customer/booking_screen_old.dart';
import 'package:kingz_cut_mobile/screens/customer/reviews_screen.dart'; // Import the booking screen

class ChooseStylistScreenCopy extends StatefulWidget {
  const ChooseStylistScreenCopy({super.key});

  @override
  State<ChooseStylistScreenCopy> createState() => _ChooseStylistScreenCopyState();
}

class _ChooseStylistScreenCopyState extends State<ChooseStylistScreenCopy> {
  final TextEditingController _searchController = TextEditingController();

  // List of stylists
  final List<Map<String, dynamic>> _stylists = [
    {'name': 'John Will', 'image': 'assets/images/stylists/john_will.png'},
    {'name': 'Ama Doe', 'image': 'assets/images/stylists/ama_doe.png'},
    {'name': 'Jojo Ansah', 'image': 'assets/images/stylists/jojo_ansah.png'},
    {
      'name': 'Daniel Grey',
      'image': 'assets/images/stylists/daniel_grey.png',
      // 'image': null, // No image for this stylist
    },
    {'name': 'Kofi Brown', 'image': 'assets/images/stylists/kofi_brown.png'},
    {'name': 'Dave Moore', 'image': 'assets/images/stylists/dave_moore.png'},
  ];

  List<Map<String, dynamic>> _filteredStylists = [];

  @override
  void initState() {
    super.initState();
    _filteredStylists = List.from(_stylists);

    // Add listener to search field
    _searchController.addListener(_filterStylists);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter stylists based on search text
  void _filterStylists() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredStylists = List.from(_stylists);
      } else {
        _filteredStylists =
            _stylists
                .where(
                  (stylist) => stylist['name'].toLowerCase().contains(query),
                )
                .toList();
      }
    });
  }

  // Navigate to next screen with selected stylist
  void _selectStylist(Map<String, dynamic> stylist) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16).copyWith(top: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(stylist['image']),
                ),
              ),
              SizedBox(height: 16),
              Text(
                stylist['name'],
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Available',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Kindly book 30 mins before\n appointment time",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Add "Send message" functionality here
                  },
                  child: Text("Send message"),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookingScreen()),
                    );
                  },
                  child: Text("Book"),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 32,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewsScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "View Reviews",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        decorationColor:
                            Theme.of(context).colorScheme.secondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    print('Selected stylist: ${stylist['name']}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Choose your hair stylist'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search hair stylists here...',
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Stylists list
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredStylists.length,
                  itemBuilder: (context, index) {
                    final stylist = _filteredStylists[index];
                    return _buildStylistCard(stylist);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStylistCard(Map<String, dynamic> stylist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade200,
          backgroundImage:
              stylist['image'] != null ? AssetImage(stylist['image']) : null,
          child:
              stylist['image'] == null
                  ? Text(
                    stylist['name'].substring(0, 1),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                  : null,
        ),
        title: Text(
          stylist['name'],
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _selectStylist(stylist),
      ),
    );
  }
}
