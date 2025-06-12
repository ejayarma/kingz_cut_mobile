// lib/providers/service_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/service.dart';
import 'package:kingz_cut_mobile/repositories/service_repository.dart';

class ServiceNotifier extends AsyncNotifier<List<Service>> {
  final _repo = ServiceRepository();

  @override
  Future<List<Service>> build() async {
    return await _repo.fetchServices();
  }

  // Optional: Refresh method for UI triggers
  Future<void> refreshServices() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.fetchServices());
  }
}

final serviceProvider = AsyncNotifierProvider<ServiceNotifier, List<Service>>(
  ServiceNotifier.new,
);
