import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/service_category.dart';
import 'package:kingz_cut_mobile/repositories/service_category_repository.dart';

final serviceCategoryRepositoryProvider = Provider(
  (ref) => ServiceCategoryRepository(),
);

final serviceCategoriesProvider = StateNotifierProvider<
  ServiceCategoryNotifier,
  AsyncValue<List<ServiceCategory>>
>((ref) {
  final repo = ref.read(serviceCategoryRepositoryProvider);
  return ServiceCategoryNotifier(repo);
});

class ServiceCategoryNotifier
    extends StateNotifier<AsyncValue<List<ServiceCategory>>> {
  final ServiceCategoryRepository _repo;

  ServiceCategoryNotifier(this._repo) : super(const AsyncValue.loading()) {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final data = await _repo.getAllCategories();
      log('Fetched ${data.length} service categories');
      log(
        'First category: ${data.isNotEmpty ? data.first.name : 'No categories found'}',
      );
      if (data.isEmpty) {
        log('No service categories found in the database.');
      }
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refreshCategories() async => await fetchCategories();
}
