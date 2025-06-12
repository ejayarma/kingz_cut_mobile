// lib/repositories/about_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kingz_cut_mobile/models/about.dart';

class AboutRepository {
  final _aboutRef = FirebaseFirestore.instance.collection('about');

  Future<About> fetchAbout() async {
    final docSnapshot = await _aboutRef.doc('business-details').get();

    if (!docSnapshot.exists) {
      throw Exception('Business details not found');
    }

    return About.fromJson(docSnapshot.data()!);
  }
}
