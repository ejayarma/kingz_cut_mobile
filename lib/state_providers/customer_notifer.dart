import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/customer.dart';
import 'package:kingz_cut_mobile/repositories/customer_repository.dart';

class CustomerNotifier extends AsyncNotifier<Customer?> {
  late final CustomerRepository _repo;

  void setCustomer(Customer customer) {
    state = AsyncValue.data(customer);
  }

  void clearCustomer() {
    state = AsyncValue.data(null);
  }

  @override
  Future<Customer?> build() async {
    _repo = ref.read(customerRepositoryProvider);
    final customer = await _repo.getCurrentCustomer();
    return customer;
  }
}

final customerNotifier = AsyncNotifierProvider<CustomerNotifier, Customer?>(
  () => CustomerNotifier(),
);

final customerStateProvider = Provider<AsyncValue<Customer?>>((ref) {
  return ref.watch(customerNotifier);
});
