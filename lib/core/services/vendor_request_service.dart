import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jihad/core/constants/firestore_collections.dart';

class VendorRequestService {
  final FirebaseFirestore _firestore;

  VendorRequestService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> submitRequest({
    required String userId,
    required String email,
    required String name,
    required String storeName,
    required String phone,
    required String businessType,
    String? description,
  }) async {
    final requestId = _firestore.collection(FirestoreCollections.vendorRequests).doc().id;

    await _firestore.collection(FirestoreCollections.vendorRequests).doc(requestId).set({
      'id': requestId,
      'userId': userId,
      'email': email,
      'name': name,
      'storeName': storeName,
      'phone': phone,
      'businessType': businessType,
      'description': description,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}