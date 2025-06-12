// lib/providers/staff_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/staff.dart';
import 'package:kingz_cut_mobile/repositories/staff_repositoy.dart';

class StaffNotifier extends AsyncNotifier<List<Staff>> {
  final _repo = StaffRepository();

  @override
  Future<List<Staff>> build() async {
    return await _repo.fetchStaff();
  }

  // Optional: Refresh method for UI triggers
  Future<void> refreshStaff() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.fetchStaff());
  }
}

final staffProvider = AsyncNotifierProvider<StaffNotifier, List<Staff>>(
  StaffNotifier.new,
);
