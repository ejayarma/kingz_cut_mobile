// lib/repositories/service_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kingz_cut_mobile/models/service.dart';

class ServiceRepository {
  final _servicesRef = FirebaseFirestore.instance.collection('services');

  Future<List<Service>> fetchServices() async {
    final snapshot = await _servicesRef.get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Service.fromJson({'id': doc.id, ...data});
    }).toList();
  }
}
