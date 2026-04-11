import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jihad/core/constants/firestore_collections.dart';

class VendorApprovalService {
  final FirebaseFirestore _firestore;

  VendorApprovalService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> watchPendingRequests() {
    return _firestore
        .collection(FirestoreCollections.vendorRequests)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> approveRequest({
    required String requestId,
    required String userId,
    required String email,
    required String storeName,
    required String name,
    required String phone,
    required String businessType,
  }) async {
    final storeId = _firestore.collection(FirestoreCollections.stores).doc().id;

    final batch = _firestore.batch();

    final requestRef = _firestore
        .collection(FirestoreCollections.vendorRequests)
        .doc(requestId);
    batch.update(requestRef, {
      'status': 'approved',
      'reviewedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final userRef = _firestore.collection(FirestoreCollections.users).doc(email);
    batch.set(userRef, {
      'id': userId,
      'email': email,
      'name': name,
      'phone': phone,
      'role': 'vendor',
      'storeId': storeId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    final storeRef = _firestore.collection(FirestoreCollections.stores).doc(storeId);
    batch.set(storeRef, {
      'id': storeId,
      'ownerId': userId,
      'ownerEmail': email,
      'name': storeName,
      'slug': _slugify(storeName),
      'description': businessType,
      'status': 'active',
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  Future<void> rejectRequest({
    required String requestId,
    String? reason,
  }) async {
    await _firestore.collection(FirestoreCollections.vendorRequests).doc(requestId).update({
      'status': 'rejected',
      'rejectionReason': reason,
      'reviewedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  String _slugify(String input) {
    final slug = input.toLowerCase().trim().replaceAll(RegExp(r'[^a-z0-9\s-]'), '');
    return slug.replaceAll(RegExp(r'\s+'), '-').replaceAll(RegExp(r'-+'), '-');
  }
}