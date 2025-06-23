import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import '../models/customer.dart';

class CustomerRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CustomerRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final String _customersCollection = 'customers';

  /// Create a new customer (let Firestore auto-generate ID)
  Future<Customer> createCustomer(Customer customer) async {
    final docRef = await _firestore
        .collection(_customersCollection)
        .add(customer.toJson());
    return Customer.fromJson({'id': docRef.id, ...customer.toJson()});
  }

  Future<Customer?> getCustomerByUserId(String uid) async {
    // Example with Firestore
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection(_customersCollection)
            .where('userId', isEqualTo: uid)
            .limit(1)
            .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final data = doc.data();
      return Customer.fromJson({...data, 'id': doc.id});
    } else {
      return null;
    }
  }

  Future<Customer?> getCurrentCustomer() async {
    if (_auth.currentUser == null) {
      return null; // No user is currently authenticated
    }
    final doc =
        await FirebaseFirestore.instance
            .collection(_customersCollection)
            .doc(_auth.currentUser?.uid)
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      return Customer.fromJson({...data, 'id': doc.id});
    } else {
      return null;
    }
  }

  /// Update an existing customer
  Future<void> updateCustomer(String customerId, Customer customer) async {
    await _firestore
        .collection(_customersCollection)
        .doc(customerId)
        .update(customer.toJson());
  }

  /// Delete a customer
  Future<void> deleteCustomer(String customerId) async {
    await _firestore.collection(_customersCollection).doc(customerId).delete();
  }

  /// Check if a customer exists by userId
  Future<bool> customerExists(String userId) async {
    final querySnapshot =
        await _firestore
            .collection(_customersCollection)
            .where('userId', isEqualTo: userId)
            .limit(1)
            .get();
    return querySnapshot.docs.isNotEmpty;
  }

  /// Create a customer from a Firebase user (if not already existing)
  Future<Customer> createCustomerFromFirebaseUser(
    User firebaseUser, {
    String? displayName,
  }) async {
    // Use the provided displayName if available, otherwise fall back to user.displayName
    final name = displayName ?? firebaseUser.displayName ?? '';
    final userId = firebaseUser.uid;

    Customer? customer = await getCustomerByUserId(userId);
    // Check if customer already exists
    if (customer != null) {
      if (customer.active) {
        return customer; // Customer already exists and is active
      }
    }

    // Create a new customer
    customer = Customer(
      active: true,
      email: firebaseUser.email ?? '',
      id: '', // Let Firestore generate the ID
      imageUrl: firebaseUser.photoURL,
      name: name,
      phone: firebaseUser.phoneNumber ?? '',
      userId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await createCustomer(customer);
    return customer;
  }

  Future<List<Customer>> fetchCustomers() async {
    final snapshot = await _firestore.collection(_customersCollection).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      log('Fetched customer: ${data['name']} with ID: ${doc.id}');
      return Customer.fromJson({...data, 'id': doc.id});
    }).toList();
  }
}

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepository();
});
