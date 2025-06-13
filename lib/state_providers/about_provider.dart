// lib/providers/about_provider.dart (or state_providers/about_provider.dart)
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kingz_cut_mobile/models/about.dart';
import 'package:kingz_cut_mobile/repositories/about_repository.dart';

class AboutNotifier extends AsyncNotifier<About> {
  final _repo = AboutRepository();

  @override
  Future<About> build() async {
    try {
      log('Building AboutNotifier...');
      final about = await _repo.fetchAbout();
      log('About details fetched successfully: ${about.name}');
      return about; // Return the fetched data, don't call fetchAbout() again
    } catch (e, stackTrace) {
      log('Error in AboutNotifier.build(): $e');
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Optional refresh method
  Future<void> refreshAbout() async {
    try {
      log('Refreshing about data...');
      state = const AsyncLoading();
      state = await AsyncValue.guard(() => _repo.fetchAbout());
    } catch (e) {
      log('Error refreshing about data: $e');
    }
  }
}

final aboutProvider = AsyncNotifierProvider<AboutNotifier, About>(
  AboutNotifier.new,
);
