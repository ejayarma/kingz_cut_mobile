import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/staff.dart';
import 'package:kingz_cut_mobile/screens/customer/booking_screen.dart';
import 'package:kingz_cut_mobile/screens/customer/reviews_screen.dart';
import 'package:kingz_cut_mobile/state_providers/staff_provider.dart';

class ChooseStylistScreen extends ConsumerStatefulWidget {
  const ChooseStylistScreen({super.key});

  @override
  ConsumerState<ChooseStylistScreen> createState() =>
      _ChooseStylistScreenState();
}

class _ChooseStylistScreenState extends ConsumerState<ChooseStylistScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Staff> _filteredStaff = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Add listener to search field
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Handle search input changes
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  // Filter staff based on search text
  List<Staff> _filterStaff(List<Staff> staff) {
    if (_searchQuery.isEmpty) {
      return staff;
    }
    return staff
        .where((stylist) => stylist.name.toLowerCase().contains(_searchQuery))
        .toList();
  }

  // Navigate to next screen with selected stylist
  void _selectStylist(Staff staff) {
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
                child: Builder(
                  builder: (context) {
                    if (staff.imageUrl == null || staff.imageUrl!.isEmpty) {
                      return CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade200,
                        child: Text(
                          staff.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      );
                    }
                    return CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: NetworkImage(staff.imageUrl!),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                staff.name,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                staff.active ? 'Available' : 'Unavailable',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: staff.active ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (staff.rating != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      staff.rating!.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
              Text(
                "Kindly book 30 mins before\n appointment time",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
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
                    // You can pass staff.id or staff object for messaging
                  },
                  child: const Text("Send message"),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed:
                      staff.active
                          ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BookingScreen(
                                      // You might want to pass the selected staff to BookingScreen
                                      // selectedStaff: staff,
                                    ),
                              ),
                            );
                          }
                          : null,
                  child: const Text("Book"),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 32,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => ReviewsScreen(
                                // You might want to pass staff.id for staff-specific reviews
                                // staffId: staff.id,
                              ),
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
    print('Selected stylist: ${staff.name} (ID: ${staff.id})');
  }

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(staffProvider);

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

              // Staff list
              Expanded(
                child: staffAsync.when(
                  data: (staff) {
                    final filteredStaff = _filterStaff(staff);

                    if (filteredStaff.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'No stylists available'
                                  : 'No stylists found for "$_searchQuery"',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await ref.read(staffProvider.notifier).refreshStaff();
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: filteredStaff.length,
                        itemBuilder: (context, index) {
                          final stylist = filteredStaff[index];
                          return _buildStylistCard(stylist);
                        },
                      ),
                    );
                  },
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error:
                      (error, stackTrace) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Failed to load stylists',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                ref.read(staffProvider.notifier).refreshStaff();
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
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

  Widget _buildStylistCard(Staff staff) {
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
        leading: Builder(
          builder: (context) {
            if (staff.imageUrl == null || staff.imageUrl!.isEmpty) {
              return CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey.shade200,
                child: Text(
                  staff.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              );
            }
            return CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: NetworkImage(staff.imageUrl!),
            );
          },
        ),
        title: Text(
          staff.name,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color:
                    staff.active ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                staff.active ? 'Available' : 'Unavailable',
                style: TextStyle(
                  color:
                      staff.active
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (staff.rating != null) ...[
              const SizedBox(width: 8),
              Icon(Icons.star, color: Colors.amber.shade600, size: 14),
              const SizedBox(width: 2),
              Text(
                staff.rating!.toStringAsFixed(1),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _selectStylist(staff),
      ),
    );
  }
}
