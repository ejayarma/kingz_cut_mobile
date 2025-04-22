import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kingz_cut_mobile/screens/customer/choose_stylist_screen.dart';

class ServiceSelectionScreen extends StatefulWidget {
  const ServiceSelectionScreen({super.key});

  @override
  State<ServiceSelectionScreen> createState() => _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState extends State<ServiceSelectionScreen> {
  // Selected services list
  final List<Map<String, dynamic>> _selectedServices = [
    {'name': 'Haircut - Fading', 'price': 15.00, 'duration': 30},
  ];

  // Available services
  final List<Map<String, dynamic>> _availableServices = [
    {
      'name': 'Hair Cut',
      'price': 15.00,
      'duration': 20,
      'hasSubOptions': false,
    },
    {
      'name': 'Beard Grooming',
      'price': 15.00,
      'duration': 20,
      'hasSubOptions': false,
    },
    {
      'name': 'Hair Coloring',
      'price': 15.00,
      'duration': 20,
      'hasSubOptions': false,
    },
    {
      'name': 'Wash & Styling',
      'price': 15.00,
      'duration': 20,
      'hasSubOptions': false,
    },
  ];

  void _addService(Map<String, dynamic> service) {
    setState(() {
      _selectedServices.add(service);
    });
  }

  void _removeService(int index) {
    setState(() {
      _selectedServices.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Select Services"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Salon image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/salon_chair.png', // Replace with your image path
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Salon name
              Text(
                'Kingz Cut Barbering Salon',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Sowutuom, Ghana',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Hours
              // Row(
              //   children: [
              //     Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
              //     const SizedBox(width: 4),
              //     Text(
              //       '10AM-10PM, Mon -Sun',
              //       style: Theme.of(
              //         context,
              //       ).textTheme.labelSmall?.copyWith(color: Colors.grey[600]),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 24),

              // Selected services title
              Text(
                'Services Selected',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Selected services list
              if (_selectedServices.isNotEmpty)
                ..._selectedServices
                    .map((service) => _buildSelectedServiceCard(service))
                    .toList(),

              const SizedBox(height: 16),

              // Additional services text
              Text(
                'Please select more service options here if necessary',
                style: Theme.of(context).textTheme.labelLarge!,
              ),
              const SizedBox(height: 12),

              // Available services list
              Expanded(
                child: ListView.builder(
                  itemCount: _availableServices.length,
                  itemBuilder: (context, index) {
                    final service = _availableServices[index];
                    return _buildServiceCard(context, service);
                  },
                ),
              ),

              // Continue button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 12),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle continue action
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ChooseStylistScreen();
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Continue (${_selectedServices.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // bottomSheet: BottomSheet(
      //   showDragHandle: true,
      //   elevation: 10,
      //   onClosing: () {},
      //   builder: (context) {
      //     return Column(
      //       mainAxisSize: MainAxisSize.min,
      //       mainAxisAlignment: MainAxisAlignment.end,
      //       children: [
      //         Text('hahahaha'),
      //         Text('hahahaha'),
      //         Text('hahahaha'),
      //         Text('hahahaha'),
      //         Text('hahahaha'),
      //         Text('hahahaha'),
      //         Text('hahahaha'),
      //         Text('hahahaha'),
      //         SingleChildScrollView(
      //           child: Column(
      //             children: [
      //               Text('hahahaha'),
      //               Text('hahahaha'),
      //               Text('hahahaha'),
      //               Text('hahahaha'),
      //               Text('hahahaha'),
      //               Text('hahahaha'),
      //               Text('hahahaha'),
      //               Text('hahahaha'),
      //               Text('hahahaha'),
      //               Text('hahahaha'),
      //             ],
      //           ),
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }

  Widget _buildSelectedServiceCard(Map<String, dynamic> service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(service['name']),
        subtitle: Row(
          children: [
            Text('GHS ${service['price'].toStringAsFixed(2)}'),
            const SizedBox(width: 8),
            Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text('${service['duration']} Minutes'),
          ],
        ),
        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
          child: const Icon(Icons.check, size: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(service['name']),
        subtitle: Row(
          children: [
            Text('GHS ${service['price'].toStringAsFixed(2)}'),
            const SizedBox(width: 8),
            Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text('${service['duration']} Minutes'),
          ],
        ),
        trailing:
            service['hasSubOptions']
                ? const Icon(Icons.chevron_right)
                : IconButton(
                  icon: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Icon(Icons.add, size: 16, color: Colors.grey),
                  ),
                  onPressed: () => _addService(service),
                ),
        onTap:
            service['hasSubOptions']
                ? () {
                  // Navigate to sub-options if available
                }
                : null,
      ),
    );
  }
}
