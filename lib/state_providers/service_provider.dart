import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/service.dart';
import 'package:kingz_cut_mobile/repositories/service_repository.dart';

final serviceRepositoryProvider = Provider((ref) => ServiceRepository());

final servicesProvider =
    StateNotifierProvider<ServiceNotifier, AsyncValue<List<Service>>>((ref) {
      final repo = ref.read(serviceRepositoryProvider);
      return ServiceNotifier(repo);
    });

class ServiceNotifier extends StateNotifier<AsyncValue<List<Service>>> {
  final ServiceRepository _repo;

  ServiceNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      final data = await _repo.fetchServices();
      log('Fetched ${data.length} services');
      log(
        'First service: ${data.isNotEmpty ? data.first.name : 'No services found'}',
      );
      if (data.isEmpty) {
        log('No services found in the database.');
      }
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshServices() async => await fetchServices();
}
