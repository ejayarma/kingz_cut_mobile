import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kingz_cut_mobile/models/service_category.dart';

class ServiceCategoryRepository {
  final _collection = FirebaseFirestore.instance.collection(
    'serviceCategories',
  );

  Future<List<ServiceCategory>> getAllCategories() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return ServiceCategory.fromJson({'id': doc.id, ...data});
    }).toList();
  }
}
