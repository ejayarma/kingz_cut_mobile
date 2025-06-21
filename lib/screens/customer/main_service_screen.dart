import 'package:dartx/dartx_io.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/service.dart';
import 'package:kingz_cut_mobile/models/service_category.dart';
// import 'package:kingz_cut_mobile/providers/service_provider.dart';
// import 'package:kingz_cut_mobile/providers/service_category_provider.dart';
import 'package:kingz_cut_mobile/screens/customer/service_selection_screen.dart';
import 'package:kingz_cut_mobile/state_providers/appointment_booking_provider.dart';
import 'package:kingz_cut_mobile/state_providers/service_category_provider.dart';
import 'package:kingz_cut_mobile/state_providers/service_provider.dart';

// Main page widget
class MainServiceScreen extends ConsumerStatefulWidget {
  final ServiceCategory? initialCategory;

  const MainServiceScreen({super.key, this.initialCategory});

  @override
  ConsumerState<MainServiceScreen> createState() => _HaircutStylesScreenState();
}

class _HaircutStylesScreenState extends ConsumerState<MainServiceScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  TabController? _tabController;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategory?.id;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  List<Service> _getFilteredServices(
    List<Service> services,
    List<ServiceCategory> categories,
  ) {
    List<Service> filteredByCategory = services;

    // Filter by category if not "All"
    if (_selectedCategoryId != null && _selectedCategoryId != 'All') {
      // Find the category ID by ID
      final category = categories.firstOrNullWhere(
        (cat) => cat.id == _selectedCategoryId,
      );
      if (category != null) {
        filteredByCategory =
            services
                .where((service) => service.categoryId == category.id)
                .toList();
      }
    }

    // Filter by search text
    if (_searchController.text.trim().isNotEmpty) {
      filteredByCategory =
          filteredByCategory
              .filter(
                (service) => service.name.toLowerCase().contains(
                  _searchController.text.trim().toLowerCase(),
                ),
              )
              .toList();
    }

    return filteredByCategory;
  }

  void _initializeTabController(List<ServiceCategory> categories) {
    final tabCount = categories.length + 1; // +1 for "All" tab

    if (_tabController?.length != tabCount) {
      _tabController?.dispose();
      _tabController = TabController(length: tabCount, vsync: this);

      // Set initial tab based on passed category
      if (widget.initialCategory != null) {
        final initialIndex = categories.indexWhere(
          (cat) => cat.id == widget.initialCategory!.id,
        );
        if (initialIndex != -1) {
          _tabController!.index = initialIndex + 1; // +1 because "All" is first
        }
      }

      _tabController!.addListener(() {
        if (_tabController!.indexIsChanging) {
          setState(() {
            if (_tabController!.index == 0) {
              _selectedCategoryId = 'All';
            } else {
              _selectedCategoryId = categories[_tabController!.index - 1].id;
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(servicesProvider);
    final categoriesAsync = ref.watch(serviceCategoriesProvider);

    return categoriesAsync.when(
      loading:
          () => Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Services',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: const Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, stackTrace) => Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Services',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading categories',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(serviceCategoriesProvider.notifier)
                          .refreshCategories();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
      data: (categories) {
        _initializeTabController(categories);
        _selectedCategoryId ??= 'All';

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Services',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            bottom:
                categories.isNotEmpty
                    ? TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: [
                        const Tab(text: 'All'),
                        ...categories.map(
                          (category) => Tab(text: category.name),
                        ),
                      ],
                    )
                    : null,
          ),
          body: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchBar(
                  hintText: 'Search services here...',
                  controller: _searchController,
                  hintStyle: WidgetStatePropertyAll(
                    Theme.of(context).textTheme.labelMedium!.copyWith(),
                  ),
                  leading: Icon(
                    CupertinoIcons.search,
                    size: 16,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  trailing: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                          });
                        },
                        icon: const Icon(Icons.clear),
                      ),
                  ],
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
                  ),
                  elevation: WidgetStateProperty.all(0),
                  backgroundColor: WidgetStateProperty.all(
                    Colors.grey.shade100,
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),

              // List of services
              Expanded(
                child: servicesAsync.when(
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error:
                      (error, stackTrace) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading services',
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
                  data: (services) {
                    final filteredServices = _getFilteredServices(
                      services,
                      categories,
                    );

                    if (filteredServices.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.search_off,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchController.text.trim().isEmpty
                                    ? (_selectedCategoryId == 'All'
                                        ? 'No services available'
                                        : 'No services available in ${categories.firstOrNullWhere((cat) => cat.id == _selectedCategoryId)?.name ?? 'this category'}')
                                    : 'No services found matching "${_searchController.text.trim()}"',
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        await Future.wait([
                          ref.read(servicesProvider.notifier).refreshServices(),
                          ref
                              .read(serviceCategoriesProvider.notifier)
                              .refreshCategories(),
                        ]);
                      },
                      child: ListView(
                        padding: const EdgeInsets.all(8.0),
                        children:
                            filteredServices
                                .map((service) => ServiceCard(service: service))
                                .toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Reusable card widget for each service
class ServiceCard extends ConsumerWidget {
  final Service service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            // Service image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  service.imageUrl != null && service.imageUrl!.isNotEmpty
                      ? Image.network(
                        service.imageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.content_cut,
                              size: 32,
                              color: Colors.grey,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                      )
                      : Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.content_cut,
                          size: 32,
                          color: Colors.grey,
                        ),
                      ),
            ),
            const SizedBox(width: 16),

            // Service details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
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
                        '${service.timeframe}mins',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'GHS ${service.price.toStringAsFixed(2)}',
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
                final bookingNotifier = ref.read(
                  appointmentBookingProvider.notifier,
                );
                bookingNotifier.clearBookingState();
                bookingNotifier.selectService(service.id);

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
