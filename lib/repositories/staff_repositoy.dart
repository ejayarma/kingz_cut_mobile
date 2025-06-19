// lib/repositories/staff_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kingz_cut_mobile/models/staff.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffRepository {
  final _staffRef = FirebaseFirestore.instance.collection('staff');

  Future<List<Staff>> fetchStaff() async {
    // final snapshot = await _staffRef.get();
    final snapshot = await _staffRef.where('role', isEqualTo: 'staff').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Staff.fromJson({'id': doc.id, ...data});
    }).toList();
    // return snapshot.docs.map((doc) => Staff.fromJson(doc.data())).toList();
  }

  /// Check if a staff exists by userId
  Future<bool> staffExists(String userId) async {
    final querySnapshot =
        await _staffRef.where('userId', isEqualTo: userId).limit(1).get();
    return querySnapshot.docs.isNotEmpty;
  }
}

// staff repo riverpod provider
final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  return StaffRepository();
});
