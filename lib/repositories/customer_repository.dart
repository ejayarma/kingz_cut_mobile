import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/customer.dart';

class CustomerRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CustomerRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  final String _customersCollection = 'customers';

  /// Create a new customer (let Firestore auto-generate ID)
  Future<String> createCustomer(Customer customer) async {
    final docRef = await _firestore
        .collection(_customersCollection)
        .add(customer.toJson());
    return docRef.id;
  }

  Future<Customer?> getCustomerByUid(String uid) async {
    // Example with Firestore
    final doc =
        await FirebaseFirestore.instance
            .collection(_customersCollection)
            .doc(uid)
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      return Customer.fromJson({'id': doc.id, ...data});
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
  Future<String?> createCustomerFromFirebaseUser(User firebaseUser) async {
    final userId = firebaseUser.uid;

    // Check if customer already exists
    if (await customerExists(userId)) {
      return null; // Already exists; no action taken
    }

    final customer = Customer(
      active: true,
      email: firebaseUser.email ?? '',
      id: '', // Let Firestore generate the ID
      imageUrl: firebaseUser.photoURL,
      name: firebaseUser.displayName ?? '',
      phone: firebaseUser.phoneNumber ?? '',
      userId: userId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final docId = await createCustomer(customer);
    return docId;
  }
}
