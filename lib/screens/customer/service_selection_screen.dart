import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/service.dart';
import 'package:kingz_cut_mobile/screens/customer/choose_stylist_screen.dart';
import 'package:kingz_cut_mobile/state_providers/service_provider.dart';

class ServiceSelectionScreen extends ConsumerStatefulWidget {
  const ServiceSelectionScreen({super.key});

  @override
  ConsumerState<ServiceSelectionScreen> createState() =>
      _ServiceSelectionScreenState();
}

class _ServiceSelectionScreenState
    extends ConsumerState<ServiceSelectionScreen> {
  // Selected services list
  final List<Service> _selectedServices = [];

  void _addService(Service service) {
    // Check if service is already selected to avoid duplicates
    if (!_selectedServices.any((s) => s.name == service.name)) {
      setState(() {
        _selectedServices.add(service);
      });
    }
  }

  void _removeService(int index) {
    setState(() {
      _selectedServices.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesProvider);

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
              const SizedBox(height: 24),

              // Selected services section
              if (_selectedServices.isNotEmpty) ...[
                Text(
                  'Services Selected',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._selectedServices
                    .asMap()
                    .entries
                    .map(
                      (entry) =>
                          _buildSelectedServiceCard(entry.value, entry.key),
                    )
                    .toList(),
                const SizedBox(height: 16),
              ],

              // Available services section
              Text(
                _selectedServices.isEmpty
                    ? 'Please select services'
                    : (servicesAsync.value?.length == _selectedServices.length
                        ? ''
                        : 'Please select more service options here if necessary'),
                style: Theme.of(context).textTheme.labelLarge!,
              ),
              const SizedBox(height: 12),

              // Services list with provider data
              Expanded(
                child: servicesAsync.when(
                  data: (services) {
                    if (services.isEmpty) {
                      return const Center(child: Text('No services available'));
                    }
                    return ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
                        final isSelected = _selectedServices.any(
                          (s) => s.name == service.name,
                        );
                        return isSelected
                            ? SizedBox()
                            : _buildServiceCard(context, service, isSelected);
                      },
                    );
                  },
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error:
                      (error, stack) => Center(
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
                                ref
                                    .read(servicesProvider.notifier)
                                    .refreshServices();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                ),
              ),

              // Continue button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 12),
                child: ElevatedButton(
                  onPressed:
                      _selectedServices.isNotEmpty
                          ? () {
                            // Handle continue action
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const ChooseStylistScreen();
                                },
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
                    _selectedServices.isEmpty
                        ? 'Select a service to continue'
                        : 'Continue (${_selectedServices.length})',
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

  Widget _buildSelectedServiceCard(Service service, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              onTap: () => _removeService(index),
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
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading:
            service.imageUrl != null
                ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    service.imageUrl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
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
        trailing:
            isSelected
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
                  onPressed: () => _addService(service),
                ),
      ),
    );
  }
}
