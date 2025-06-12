// lib/repositories/staff_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kingz_cut_mobile/models/staff.dart';

class StaffRepository {
  final _staffRef = FirebaseFirestore.instance.collection('staff');

  Future<List<Staff>> fetchStaff() async {
    final snapshot = await _staffRef.get();

    return snapshot.docs.map((doc) => Staff.fromJson(doc.data())).toList();
  }
}
