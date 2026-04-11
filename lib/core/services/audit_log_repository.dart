import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jihad/core/constants/firestore_collections.dart';

class AuditLogRepository {
  final FirebaseFirestore _firestore;

  AuditLogRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> watchAuditLogs() {
    return _firestore
        .collection(FirestoreCollections.auditLogs)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
