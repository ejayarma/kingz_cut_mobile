// lib/providers/about_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/about.dart';
import 'package:kingz_cut_mobile/repositories/about_repository.dart';

class AboutNotifier extends AsyncNotifier<About> {
  final _repo = AboutRepository();

  @override
  Future<About> build() async {
    return await _repo.fetchAbout();
  }

  // Optional refresh method
  Future<void> refreshAbout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.fetchAbout());
  }
}

final aboutProvider = AsyncNotifierProvider<AboutNotifier, About>(
  AboutNotifier.new,
);
