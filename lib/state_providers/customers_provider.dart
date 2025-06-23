import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/customer.dart';
import 'package:kingz_cut_mobile/repositories/customer_repository.dart';

final customersProvider =
    StateNotifierProvider<CustomerNotifier, AsyncValue<List<Customer>>>((ref) {
      final repo = ref.read(customerRepositoryProvider);
      return CustomerNotifier(repo);
    });

class CustomerNotifier extends StateNotifier<AsyncValue<List<Customer>>> {
  final CustomerRepository _repo;

  CustomerNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchCustomers();
  }

  

  // Fetch customers from the repository and update the state
  Future<void> fetchCustomers() async {
    try {
      final data = await _repo.fetchCustomers();
      log('Fetched ${data.length} customers');
      log(
        'First customer: ${data.isNotEmpty ? data.first.name : 'No customers found'}',
      );
      if (data.isEmpty) {
        log('No customers found in the database.');
      }
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshCustomers() async => await fetchCustomers();
}
