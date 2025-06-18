import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/app_config.dart';
import 'package:kingz_cut_mobile/enums/user_type.dart';
import 'package:kingz_cut_mobile/repositories/app_config_repository.dart';

class AppConfigNotifier extends AsyncNotifier<AppConfig?> {
  late final AppConfigRepository _repo;

  @override
  Future<AppConfig?> build() async {
    _repo = ref.read(appConfigRepositoryProvider);
    return await _repo.load();
  }

  Future<void> setUserType(UserType type) async {
    final current = state.valueOrNull;
    final updated = (current ?? AppConfig(userType: type, hasOnboarded: false))
        .copyWith(userType: type);
    await _repo.save(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> setOnboarded(bool onboarded) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(hasOnboarded: onboarded);
    await _repo.save(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> reset() async {
    await _repo.clear();
    state = const AsyncValue.data(null);
  }
}

final appConfigProvider = AsyncNotifierProvider<AppConfigNotifier, AppConfig?>(
  () {
    return AppConfigNotifier();
  },
);
