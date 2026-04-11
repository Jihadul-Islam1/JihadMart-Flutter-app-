import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/core/constants/firestore_collections.dart';
import 'package:jihad/core/services/order_repository.dart';
import 'package:jihad/features/shared/presentation/screens/order_details_screen.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final OrderRepository _orderRepository = OrderRepository();
  String _selectedStatus = 'All';

  Map<String, dynamic>? _firstOrderItem(Map<String, dynamic> order) {
    final items = (order['items'] as List<dynamic>? ?? []);
    if (items.isEmpty) return null;
    final first = items.first;
    if (first is Map) {
      return first.cast<String, dynamic>();
    }
    return null;
  }

  String _itemImage(Map<String, dynamic> item) {
    final image = item['image'] ?? item['product-img'] ?? item['images'];
    if (image is List && image.isNotEmpty) {
      return image.first.toString();
    }
    if (image is String && image.isNotEmpty) {
      return image;
    }
    return 'assets/products/product1.jpg';
  }

  static const List<String> _statusFilters = [
    'All',
    'Processing',
    'Confirmed',
    'Shipped',
    'Out for Delivery',
    'Delivered',
    'Cancelled',
    'Refunded',
  ];

  Future<void> _updateStatus(
    String orderId,
    String status, {
    String? note,
  }) async {
    try {
      await _orderRepository.updateOrderStatus(
        orderId: orderId,
        status: status,
        note: note,
      );
      if (!mounted) return;
      Fluttertoast.showToast(msg: 'Order marked $status');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Update failed: $e');
    }
  }

  Future<void> _handleStatusAction(String orderId, String status) async {
    String? note;
    if (status == 'Cancelled' || status == 'Refunded') {
      note = await _askForReason(status);
      if (note == null) {
        return;
      }
    }

    await _updateStatus(orderId, status, note: note);
  }

  Future<void> _approveRefund(String orderId) async {
    final note = await _askForReason('Refund Approval');
    if (note == null) {
      return;
    }

    try {
      await _orderRepository.approveRefund(orderId: orderId, note: note);
      if (!mounted) return;
      Fluttertoast.showToast(msg: 'Refund approved');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Approve failed: $e');
    }
  }

  Future<void> _markRefundPaid(String orderId) async {
    final note = await _askForReason('Refund Payout');
    if (note == null) {
      return;
    }

    try {
      await _orderRepository.markRefundPaid(orderId: orderId, note: note);
      if (!mounted) return;
      Fluttertoast.showToast(msg: 'Refund marked paid');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Payout failed: $e');
    }
  }

  Future<void> _handleMenuAction({
    required String orderId,
    required String action,
  }) async {
    if (action == 'approve_refund') {
      await _approveRefund(orderId);
      return;
    }

    if (action == 'refund_paid') {
      await _markRefundPaid(orderId);
      return;
    }

    await _handleStatusAction(orderId, action);
  }

  Future<String?> _askForReason(String status) async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('$status Reason'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Write a short reason',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();
              Navigator.pop(dialogContext, value.isEmpty ? '-' : value);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Order Operations'),
        centerTitle: true,
        backgroundColor: AppColors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 54.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              scrollDirection: Axis.horizontal,
              itemCount: _statusFilters.length,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final filter = _statusFilters[index];
                final active = filter == _selectedStatus;
                return ChoiceChip(
                  selected: active,
                  label: Text(filter),
                  onSelected: (_) {
                    setState(() {
                      _selectedStatus = filter;
                    });
                  },
                );
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection(FirestoreCollections.orders)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Failed to load orders: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allDocs = snapshot.data?.docs ?? [];
                final docs = _selectedStatus == 'All'
                    ? allDocs
                    : allDocs.where((doc) {
                        final status =
                            doc.data()['status']?.toString().toLowerCase() ?? '';
                        return status == _selectedStatus.toLowerCase();
                      }).toList();

                if (docs.isEmpty) {
                  return Center(
                    child: Text(
                      _selectedStatus == 'All'
                          ? 'No orders yet'
                          : 'No $_selectedStatus orders',
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data();
                    final items = (data['items'] as List<dynamic>? ?? []);
                    final status = data['status']?.toString() ?? 'Processing';
                    final total = data['totalAmount'] ?? data['total'] ?? 0;
                    final email = data['userEmail']?.toString() ?? '-';
                    final refundStatus = data['refundStatus']?.toString();
                    final firstItem = _firstOrderItem(data);
                    final previewImage = firstItem == null ? 'assets/products/product1.jpg' : _itemImage(firstItem);
                    final previewName = firstItem?['name']?.toString() ?? firstItem?['product-name']?.toString() ?? 'Product';

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrderDetailsScreen(
                              order: data,
                              orderDocId: doc.id,
                            ),
                          ),
                        );
                      },
                      child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  data['orderId']?.toString() ?? doc.id,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              _StatusChip(status: status),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: previewImage.startsWith('http')
                                    ? Image.network(
                                        previewImage,
                                        width: 52.w,
                                        height: 52.w,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          width: 52.w,
                                          height: 52.w,
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.image_not_supported),
                                        ),
                                      )
                                    : Image.asset(
                                        previewImage,
                                        width: 52.w,
                                        height: 52.w,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      previewName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Items: ${items.length}',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text('Customer: $email'),
                          SizedBox(height: 4.h),
                          Text(
                            'Address: ${data['shippingAddress'] ?? 'Not provided'}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Items: ${items.length} • Total: ৳$total',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          if (refundStatus != null) ...[
                            SizedBox(height: 6.h),
                            Text(
                              'Refund: $refundStatus',
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDate(data['createdAt']),
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12.sp,
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) => _handleMenuAction(
                                  orderId: doc.id,
                                  action: value,
                                ),
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: 'Processing',
                                    child: Text('Mark Processing'),
                                  ),
                                  PopupMenuItem(
                                    value: 'Confirmed',
                                    child: Text('Mark Confirmed'),
                                  ),
                                  PopupMenuItem(
                                    value: 'Shipped',
                                    child: Text('Mark Shipped'),
                                  ),
                                  PopupMenuItem(
                                    value: 'Out for Delivery',
                                    child: Text('Mark Out for Delivery'),
                                  ),
                                  PopupMenuItem(
                                    value: 'Delivered',
                                    child: Text('Mark Delivered'),
                                  ),
                                  PopupMenuItem(
                                    value: 'Cancelled',
                                    child: Text('Cancel Order'),
                                  ),
                                  PopupMenuItem(
                                    value: 'Refunded',
                                    child: Text('Mark Refunded'),
                                  ),
                                  PopupMenuItem(
                                    value: 'approve_refund',
                                    child: Text('Approve Refund'),
                                  ),
                                  PopupMenuItem(
                                    value: 'refund_paid',
                                    child: Text('Mark Refund Paid'),
                                  ),
                                ],
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 8.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.deepOrange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    'Take Action',
                                    style: TextStyle(
                                      color: AppColors.deepOrange,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic createdAt) {
    if (createdAt is Timestamp) {
      final date = createdAt.toDate();
      return '${date.day}/${date.month}/${date.year}';
    }
    return 'Just now';
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final lower = status.toLowerCase();
    Color color;

    if (lower == 'delivered') {
      color = Colors.green;
    } else if (lower == 'shipped' || lower == 'out for delivery') {
      color = Colors.blue;
    } else if (lower == 'confirmed' || lower == 'processing') {
      color = Colors.orange;
    } else if (lower == 'cancelled' || lower == 'refunded') {
      color = Colors.red;
    } else {
      color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}