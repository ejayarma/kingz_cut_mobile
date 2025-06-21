import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/service.dart';
import 'package:kingz_cut_mobile/screens/customer/choose_stylist_screen.dart';
import 'package:kingz_cut_mobile/state_providers/appointment_booking_provider.dart';
import 'package:kingz_cut_mobile/state_providers/service_provider.dart';
// Import your appointment booking provider
// import 'package:kingz_cut_mobile/providers/appointment_booking_provider.dart';

class ServiceSelectionScreen extends ConsumerStatefulWidget {
  const ServiceSelectionScreen({super.key});

  @override
  ConsumerState<ServiceSelectionScreen> createState() =>
      _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState
    extends ConsumerState<ServiceSelectionScreen> {
  
  @override
  void initState() {
    super.initState();
    // Clear any previous booking state when entering service selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appointmentBookingProvider.notifier).clearBookingState();
    });
  }

  void _toggleService(Service service) {
    final bookingNotifier = ref.read(appointmentBookingProvider.notifier);
    final currentBookingState = ref.read(appointmentBookingProvider);
    
    // Check if service is already selected
    if (currentBookingState.selectedServiceIds.contains(service.id)) {
      // Remove service if already selected
      bookingNotifier.deselectService(service.id!);
    } else {
      // Add service if not selected
      bookingNotifier.selectService(service.id!);
    }
  }

  void _removeService(Service service) {
    final bookingNotifier = ref.read(appointmentBookingProvider.notifier);
    bookingNotifier.deselectService(service.id!);
  }

  List<Service> _getSelectedServices(List<Service> allServices, List<String> selectedServiceIds) {
    return allServices.where((service) => selectedServiceIds.contains(service.id)).toList();
  }

  double _calculateTotalPrice(List<Service> selectedServices) {
    return selectedServices.fold(0.0, (total, service) => total + service.price);
  }

  // int _calculateTotalDuration(List<Service> selectedServices) {
  //   return selectedServices.fold(0, (total, service) => total + service.timeframe);
  // }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesProvider);
    final bookingState = ref.watch(appointmentBookingProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Select Services"),
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
                  'assets/images/salon_chair.png',
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Salon name
              Text(
                'Kingz Cut Barbering Salon',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Sowutuom, Ghana',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Services list with provider data
              Expanded(
                child: servicesAsync.when(
                  data: (services) {
                    if (services.isEmpty) {
                      return const Center(child: Text('No services available'));
                    }

                    final selectedServices = _getSelectedServices(services, bookingState.selectedServiceIds);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Selected services section
                        if (selectedServices.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Services Selected (${selectedServices.length})',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'GHS ${_calculateTotalPrice(selectedServices).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ...selectedServices
                              .map((service) => _buildSelectedServiceCard(service))
                              .toList(),
                          const SizedBox(height: 16),
                        ],

                        // Available services section
                        Text(
                          selectedServices.isEmpty
                              ? 'Please select services'
                              : (services.length == selectedServices.length
                                  ? 'All services selected'
                                  : 'Add more services if needed'),
                          style: Theme.of(context).textTheme.labelLarge!,
                        ),
                        const SizedBox(height: 12),

                        // Available services list
                        Expanded(
                          child: ListView.builder(
                            itemCount: services.length,
                            itemBuilder: (context, index) {
                              final service = services[index];
                              final isSelected = bookingState.selectedServiceIds.contains(service.id);
                              
                              return _buildServiceCard(context, service, isSelected);
                            },
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Failed to load services',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(servicesProvider.notifier).refreshServices();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Loading indicator when booking state is loading
              if (bookingState.isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(child: CircularProgressIndicator()),
                ),

              // Error message
              if (bookingState.error != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    bookingState.error!,
                    style: TextStyle(color: Colors.red.shade700),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Continue button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 12),
                child: ElevatedButton(
                  onPressed: bookingState.canProceedToStaffSelection && !bookingState.isLoading
                      ? () {
                          // Navigate to stylist selection
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ChooseStylistScreen(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    bookingState.selectedServiceIds.isEmpty
                        ? 'Select a service to continue'
                        : 'Continue (${bookingState.selectedServiceIds.length})',
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
    );
  }

  Widget _buildSelectedServiceCard(Service service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: service.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  service.imageUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.content_cut,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              )
            : Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.content_cut, color: Colors.grey.shade400),
              ),
        title: Text(
          service.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Row(
          children: [
            Text('GHS ${service.price.toStringAsFixed(2)}'),
            const SizedBox(width: 8),
            Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              '${service.timeframe} mins',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Icon(Icons.check, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _removeService(service),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade100,
                ),
                child: Icon(Icons.close, size: 16, color: Colors.red.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    Service service,
    bool isSelected,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: service.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  service.imageUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.content_cut,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              )
            : Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.content_cut, color: Colors.grey.shade400),
              ),
        title: Text(service.name),
        subtitle: Row(
          children: [
            Text('GHS ${service.price.toStringAsFixed(2)}'),
            const SizedBox(width: 8),
            Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              '${service.timeframe} mins',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
        trailing: isSelected
            ? Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const Icon(Icons.check, size: 16, color: Colors.white),
              )
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
                onPressed: () => _toggleService(service),
              ),
        onTap: () => _toggleService(service),
      ),
    );
  }
}