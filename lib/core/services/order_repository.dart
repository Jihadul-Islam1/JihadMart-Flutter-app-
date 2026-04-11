import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jihad/core/constants/firestore_collections.dart';

class OrderRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  OrderRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> watchCurrentUserOrders() {
    final user = _auth.currentUser;
    final email = user?.email?.trim().toLowerCase();

    if (email == null || email.isEmpty) {
      return const Stream.empty();
    }

    return _firestore
        .collection(FirestoreCollections.orders)
        .where('userEmail', isEqualTo: email)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchStoreOrders(String storeId) {
    return _firestore
        .collection(FirestoreCollections.orders)
        .where('storeIds', arrayContains: storeId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
    String? note,
  }) async {
    final user = _auth.currentUser;
    final email = user?.email?.trim().toLowerCase() ?? 'system';

    final orderRef = _firestore.collection(FirestoreCollections.orders).doc(orderId);
    final orderSnapshot = await orderRef.get();
    final orderData = orderSnapshot.data() ?? <String, dynamic>{};

    await orderRef.update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
      'statusHistory': FieldValue.arrayUnion([
        {
          'status': status,
          'note': note,
          'actorUid': user?.uid,
          'actorEmail': email,
          'changedAt': DateTime.now().toUtc().toIso8601String(),
        },
      ]),
    });

    await _writeAuditLog(
      action: 'order_status_changed',
      entityType: 'order',
      entityId: orderId,
      actorUid: user?.uid,
      actorEmail: email,
      metadata: {
        'status': status,
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      },
    );

    await _notifyStatusChanged(orderData: orderData, status: status);
  }

  Future<void> requestRefund({
    required String orderId,
    required String reason,
  }) async {
    final user = _auth.currentUser;
    final email = user?.email?.trim().toLowerCase();
    if (email == null || email.isEmpty) {
      throw StateError('No authenticated user found.');
    }

    final orderRef = _firestore.collection(FirestoreCollections.orders).doc(orderId);
    final orderSnapshot = await orderRef.get();
    final orderData = orderSnapshot.data() ?? <String, dynamic>{};

    await orderRef.update({
      'refundStatus': 'requested',
      'refundReason': reason,
      'refundRequestedBy': email,
      'refundRequestedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await _writeAuditLog(
      action: 'order_refund_requested',
      entityType: 'order',
      entityId: orderId,
      actorUid: user?.uid,
      actorEmail: email,
      metadata: {'reason': reason},
    );

    await _createNotification(
      userEmail: email,
      title: 'Refund request submitted',
      message:
          '${orderData['orderId'] ?? 'Your order'} refund request is under review.',
      type: 'refund',
      metadata: {
        'orderId': orderId,
        'refundStatus': 'requested',
      },
    );

    await _createNotification(
      userEmail: 'admin@gmail.com',
      title: 'Refund review needed',
      message:
          'Refund requested for ${orderData['orderId'] ?? orderId}. Please review.',
      type: 'refund',
      metadata: {
        'orderId': orderId,
        'refundStatus': 'requested',
      },
    );
  }

  Future<void> approveRefund({
    required String orderId,
    String? note,
  }) async {
    final user = _auth.currentUser;
    final email = user?.email?.trim().toLowerCase() ?? 'system';

    final orderRef = _firestore.collection(FirestoreCollections.orders).doc(orderId);
    final orderSnapshot = await orderRef.get();
    final orderData = orderSnapshot.data() ?? <String, dynamic>{};

    await orderRef.update({
      'refundStatus': 'approved',
      'refundApprovedBy': email,
      'refundApprovedAt': FieldValue.serverTimestamp(),
      if (note != null && note.trim().isNotEmpty) 'refundApprovalNote': note,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await _writeAuditLog(
      action: 'order_refund_approved',
      entityType: 'order',
      entityId: orderId,
      actorUid: user?.uid,
      actorEmail: email,
      metadata: {
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      },
    );

    final customerEmail = orderData['userEmail']?.toString().trim().toLowerCase();
    if (customerEmail != null && customerEmail.isNotEmpty) {
      await _createNotification(
        userEmail: customerEmail,
        title: 'Refund approved',
        message:
            '${orderData['orderId'] ?? 'Your order'} refund has been approved.',
        type: 'refund',
        metadata: {
          'orderId': orderId,
          'refundStatus': 'approved',
        },
      );
    }
  }

  Future<void> markRefundPaid({
    required String orderId,
    String? note,
  }) async {
    final user = _auth.currentUser;
    final email = user?.email?.trim().toLowerCase() ?? 'system';

    final orderRef = _firestore.collection(FirestoreCollections.orders).doc(orderId);
    final orderSnapshot = await orderRef.get();
    final orderData = orderSnapshot.data() ?? <String, dynamic>{};
    final totalAmount = (orderData['totalAmount'] ?? orderData['total'] ?? 0)
        .toDouble();

    final payoutRef = _firestore.collection(FirestoreCollections.payouts).doc();
    await payoutRef.set({
      'id': payoutRef.id,
      'orderId': orderId,
      'amount': totalAmount,
      'type': 'refund',
      'status': 'paid',
      'paidTo': orderData['userEmail'],
      'paidBy': email,
      'note': note,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await orderRef.update({
      'refundStatus': 'paid',
      'refundPaidAt': FieldValue.serverTimestamp(),
      'refundPayoutId': payoutRef.id,
      'status': 'Refunded',
      'updatedAt': FieldValue.serverTimestamp(),
      'statusHistory': FieldValue.arrayUnion([
        {
          'status': 'Refunded',
          'note': note ?? 'Refund paid to customer',
          'actorUid': user?.uid,
          'actorEmail': email,
          'changedAt': DateTime.now().toUtc().toIso8601String(),
        },
      ]),
    });

    await _writeAuditLog(
      action: 'order_refund_paid',
      entityType: 'order',
      entityId: orderId,
      actorUid: user?.uid,
      actorEmail: email,
      metadata: {
        'payoutId': payoutRef.id,
        'amount': totalAmount,
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      },
    );

    final customerEmail = orderData['userEmail']?.toString().trim().toLowerCase();
    if (customerEmail != null && customerEmail.isNotEmpty) {
      await _createNotification(
        userEmail: customerEmail,
        title: 'Refund paid',
        message:
            '${orderData['orderId'] ?? 'Your order'} refund is completed. Amount ৳${totalAmount.toStringAsFixed(0)}.',
        type: 'refund',
        metadata: {
          'orderId': orderId,
          'refundStatus': 'paid',
          'payoutId': payoutRef.id,
        },
      );
    }
  }

  Future<void> createOrder({
    required List<Map<String, dynamic>> items,
    required double subtotalAmount,
    required double shippingAmount,
    required double taxAmount,
    required double discountAmount,
    required double totalAmount,
    required String shippingAddress,
    required String paymentMethod,
    String paymentStatus = 'pending',
    String? paymentGateway,
    String? paymentTransactionId,
    String? paymentValidationId,
    String? paymentBankTransactionId,
    Map<String, dynamic>? paymentRaw,
  }) async {
    final user = _auth.currentUser;
    final email = user?.email?.trim().toLowerCase();

    if (user == null || email == null || email.isEmpty) {
      throw StateError('No authenticated user found.');
    }

    // Normalize items: extract first image from any supported field and create image field.
    final normalizedItems = items.map((item) {
      final normalized = Map<String, dynamic>.from(item);

      final rawImages = item['images'] ?? item['product-img'];
      if (rawImages is List && rawImages.isNotEmpty) {
        normalized['image'] = rawImages.first.toString();
      } else if (rawImages != null && rawImages.toString().isNotEmpty) {
        normalized['image'] = rawImages.toString();
      } else if (item['image'] != null && item['image'].toString().isNotEmpty) {
        normalized['image'] = item['image'].toString();
      } else {
        normalized['image'] = 'assets/products/product1.jpg';
      }

      return normalized;
    }).toList();

    final storeIds = <String>{};
    for (final item in normalizedItems) {
      final storeId = item['storeId']?.toString();
      if (storeId != null && storeId.isNotEmpty) {
        storeIds.add(storeId);
      }
    }

    final orderRef = _firestore.collection(FirestoreCollections.orders).doc();

    await orderRef.set({
      'id': orderRef.id,
      'orderId': '#${orderRef.id.substring(0, 8).toUpperCase()}',
      'userId': user.uid,
      'userEmail': email,
      'status': 'Processing',
      'statusHistory': [
        {
          'status': 'Processing',
          'note': 'Order placed',
          'actorUid': user.uid,
          'actorEmail': email,
          'changedAt': DateTime.now().toUtc().toIso8601String(),
        },
      ],
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      if (paymentGateway != null && paymentGateway.isNotEmpty)
        'paymentGateway': paymentGateway,
      if (paymentTransactionId != null && paymentTransactionId.isNotEmpty)
        'paymentTransactionId': paymentTransactionId,
      if (paymentValidationId != null && paymentValidationId.isNotEmpty)
        'paymentValidationId': paymentValidationId,
      if (paymentBankTransactionId != null && paymentBankTransactionId.isNotEmpty)
        'paymentBankTransactionId': paymentBankTransactionId,
      if (paymentRaw != null && paymentRaw.isNotEmpty) 'paymentRaw': paymentRaw,
      'items': normalizedItems,
      'storeIds': storeIds.toList(),
      'subtotalAmount': subtotalAmount,
      'shippingAmount': shippingAmount,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await _writeAuditLog(
      action: 'order_created',
      entityType: 'order',
      entityId: orderRef.id,
      actorUid: user.uid,
      actorEmail: email,
      metadata: {
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        if (paymentGateway != null && paymentGateway.isNotEmpty)
          'paymentGateway': paymentGateway,
        if (paymentTransactionId != null && paymentTransactionId.isNotEmpty)
          'paymentTransactionId': paymentTransactionId,
        'totalAmount': totalAmount,
        'storeCount': storeIds.length,
      },
    );

    await _notifyOrderCreated(
      orderId: orderRef.id,
      orderCode: '#${orderRef.id.substring(0, 8).toUpperCase()}',
      userEmail: email,
      totalAmount: totalAmount,
      storeIds: storeIds.toList(),
    );
  }

  Future<void> _notifyOrderCreated({
    required String orderId,
    required String orderCode,
    required String userEmail,
    required double totalAmount,
    required List<String> storeIds,
  }) async {
    await _createNotification(
      userEmail: userEmail,
      title: 'Order placed successfully',
      message: '$orderCode has been placed. Total ৳${totalAmount.toStringAsFixed(0)}',
      type: 'order',
      metadata: {
        'orderId': orderId,
      },
    );

    for (final storeId in storeIds) {
      final storeDoc = await _firestore
          .collection(FirestoreCollections.stores)
          .doc(storeId)
          .get();
      final ownerEmail =
          storeDoc.data()?['ownerEmail']?.toString().trim().toLowerCase();
      if (ownerEmail == null || ownerEmail.isEmpty) {
        continue;
      }

      await _createNotification(
        userEmail: ownerEmail,
        title: 'New order received',
        message: 'A new order $orderCode requires fulfillment.',
        type: 'order',
        metadata: {
          'orderId': orderId,
          'storeId': storeId,
        },
      );
    }
  }

  Future<void> _notifyStatusChanged({
    required Map<String, dynamic> orderData,
    required String status,
  }) async {
    final userEmail = orderData['userEmail']?.toString().trim().toLowerCase();
    if (userEmail == null || userEmail.isEmpty) {
      return;
    }

    final orderCode = orderData['orderId']?.toString() ?? 'order';
    await _createNotification(
      userEmail: userEmail,
      title: 'Order status updated',
      message: '$orderCode is now $status.',
      type: 'order',
      metadata: {
        'orderId': orderData['id'],
        'status': status,
      },
    );
  }

  Future<void> _writeAuditLog({
    required String action,
    required String entityType,
    required String entityId,
    required String? actorUid,
    required String actorEmail,
    Map<String, dynamic>? metadata,
  }) async {
    final ref = _firestore.collection(FirestoreCollections.auditLogs).doc();
    await ref.set({
      'id': ref.id,
      'action': action,
      'entityType': entityType,
      'entityId': entityId,
      'actorUid': actorUid,
      'actorEmail': actorEmail,
      'metadata': metadata ?? const <String, dynamic>{},
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _createNotification({
    required String userEmail,
    required String title,
    required String message,
    required String type,
    Map<String, dynamic>? metadata,
  }) async {
    final ref = _firestore.collection(FirestoreCollections.notifications).doc();
    await ref.set({
      'id': ref.id,
      'userEmail': userEmail,
      'title': title,
      'message': message,
      'type': type,
      'isRead': false,
      'metadata': metadata ?? const <String, dynamic>{},
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}