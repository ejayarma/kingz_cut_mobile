// lib/repositories/staff_repository.dart
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kingz_cut_mobile/models/staff.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffRepository {
  // final _staffRef = FirebaseFirestore.instance.collection('staff');
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  StaffRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final String _staffCollection = 'staff';

  Future<List<Staff>> fetchStaff() async {
    // final snapshot = await _staffRef.get();
    final snapshot =
        await _firestore
            .collection(_staffCollection)
            .where('role', isEqualTo: 'staff')
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Staff.fromJson({'id': doc.id, ...data});
    }).toList();
    // return snapshot.docs.map((doc) => Staff.fromJson(doc.data())).toList();
  }

  /// Check if a staff exists by userId
  Future<bool> staffExists(String userId) async {
    final querySnapshot =
        await _firestore
            .collection(_staffCollection)
            .where('userId', isEqualTo: userId)
            .limit(1)
            .get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<Staff?> getStaffByUserId(String uid) async {
    // Example with Firestore
    final querySnapshot =
        await _firestore
            .collection(_staffCollection)
            .where('userId', isEqualTo: uid)
            .limit(1)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final data = doc.data();
      return Staff.fromJson({...data, 'id': doc.id});
    } else {
      return null;
    }
  }

  Future<Staff?> getStaff(String staffId) async {
    // Example with Firestore
    final querySnapshot =
        await _firestore.collection(_staffCollection).doc(staffId).get();

    if (querySnapshot.exists) {
      final data = querySnapshot.data()!;
      return Staff.fromJson({...data, 'id': querySnapshot.id});
    } else {
      return null;
    }
  }

  /// Update an existing staff
  Future<void> updateStaff(String staffId, Staff staff) async {
    // Update Firestore
    await _firestore.collection(_staffCollection).doc(staffId).update({
      ...staff.toJson(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    // Prepare non-null fields for update
    final Map<String, dynamic> userUpdateData = {
      // 'uid': customer.userId,
      'email': staff.email,
      'displayName': staff.name,
      'phoneNumber': staff.phone,
      if (staff.imageUrl != null) 'photoURL': staff.imageUrl,
    };

    final data = {'userId': staff.userId, 'updateData': userUpdateData};

    log("staff update api data: $data");

    // Call external API if there is any data to update
    if (userUpdateData.isNotEmpty) {
      final response = await Dio().put(
        'https://kingz-cut-admin.vercel.app/api/users',
        data: data,
      );
      log("staff update response: ${response.data?.toString()}");
    }
  }

  Future<Staff?> getCurrentStaff() async {
    if (_auth.currentUser == null) {
      return null; // No user is currently authenticated
    }
    final doc =
        await _firestore
            .collection(_staffCollection)
            .doc(_auth.currentUser?.uid)
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      return Staff.fromJson({...data, 'id': doc.id});
    } else {
      return null;
    }
  }
}

// staff repo riverpod provider
final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  return StaffRepository();
});
