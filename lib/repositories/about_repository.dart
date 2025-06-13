// lib/repositories/about_repository.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kingz_cut_mobile/models/about.dart';

class AboutRepository {
  final _aboutRef = FirebaseFirestore.instance.collection('about');

  Future<About> fetchAbout() async {
    try {
      log('Fetching about data from Firestore...');
      
      final docSnapshot = await _aboutRef.doc('business-info').get();

      if (!docSnapshot.exists) {
        log('Business details document not found');
        throw Exception('Business details not found');
      }

      final data = docSnapshot.data();
      if (data == null) {
        log('Business details document data is null');
        throw Exception('Business details data is null');
      }

      log('Raw Firestore data: $data');
      
      final about = About.fromJson(data); // Only call fromJson once
      log('Successfully parsed About model: ${about.name}');
      
      return about; // Return the parsed model, don't call fromJson again
    } catch (e, stackTrace) {
      log('Error in fetchAbout(): $e');
      log('Stack trace: $stackTrace');
      rethrow;
    }
  }
}