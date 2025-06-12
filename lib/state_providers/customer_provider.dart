import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/customer.dart';

class CustomerNotifier extends Notifier<Customer?> {
  void setCustomer(Customer customer) {
    state = customer;
  }

  void clearCustomer() {
    state = null;
  }

  @override
  Customer? build() {
    return null;
  }
}

final customerProvider = NotifierProvider<CustomerNotifier, Customer?>(
  () => CustomerNotifier(),
);

final customerStateProvider = StateProvider<Customer?>((ref) {
  return ref.watch(customerProvider);
});
