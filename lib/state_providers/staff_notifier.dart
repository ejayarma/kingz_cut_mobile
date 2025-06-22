import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/staff.dart';
import 'package:kingz_cut_mobile/repositories/staff_repositoy.dart';

class CurrentStaffNotifier extends AsyncNotifier<Staff?> {
  late final StaffRepository _repo;

  void setStaff(Staff staff) {
    state = AsyncValue.data(staff);
  }

  void clearStaff() {
    state = AsyncValue.data(null);
  }

  @override
  Future<Staff?> build() async {
    _repo = ref.read(staffRepositoryProvider);
    final staff = _repo.getCurrentStaff();
    return staff;
  }
}

final staffNotifier = AsyncNotifierProvider<CurrentStaffNotifier, Staff?>(
  () => CurrentStaffNotifier(),
);

final staffStateProvider = Provider<AsyncValue<Staff?>>((ref) {
  return ref.watch(staffNotifier);
});
