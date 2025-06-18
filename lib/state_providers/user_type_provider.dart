import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/enums/user_type.dart';
import 'package:kingz_cut_mobile/repositories/user_type_repository.dart';

class UserTypeNotifier extends AsyncNotifier<UserType?> {
  late final UserTypeRepository _repo;

  @override
  Future<UserType?> build() async {
    _repo = ref.read(userTypeRepositoryProvider);
    return await _repo.loadUserType();
  }

  Future<void> setType(UserType uType) async {
    final current = state.valueOrNull;
    if (current == uType) return;
    await _repo.saveUserType(uType);
    state = AsyncValue.data(uType);
  }
}

final userTypeProvider = AsyncNotifierProvider<UserTypeNotifier, UserType?>(
  UserTypeNotifier.new,
);
