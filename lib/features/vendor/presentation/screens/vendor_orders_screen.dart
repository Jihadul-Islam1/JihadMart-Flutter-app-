import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/core/constants/firestore_collections.dart';
import 'package:jihad/core/services/order_repository.dart';
import 'package:jihad/features/shared/presentation/screens/order_details_screen.dart';

class VendorOrdersScreen extends StatefulWidget {
  const VendorOrdersScreen({super.key});

  @override
  State<VendorOrdersScreen> createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<VendorOrdersScreen> {
  final OrderRepository _orderRepository = OrderRepository();

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

  Future<void> _handleVendorStatusUpdate(String orderId, String status) async {
    String? note;
    if (status == 'Cancelled') {
      note = await _askForReason(status);
      if (note == null) {
        return;
      }
    }

    await _orderRepository.updateOrderStatus(
      orderId: orderId,
      status: status,
      note: note,
    );
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

  Future<Map<String, dynamic>?> _loadVendorContext() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final userDoc = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(user.email)
        .get();

    final data = userDoc.data();
    final storeId = data?['storeId']?.toString();
    if (storeId == null || storeId.isEmpty) {
      return null;
    }

    return {
      'storeId': storeId,
      'storeName': data?['storeName']?.toString() ?? 'My Store',
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _loadVendorContext(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final vendorContext = snapshot.data;
        if (vendorContext == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF6F7FB),
            appBar: AppBar(
              title: const Text('Vendor Orders'),
              centerTitle: true,
              backgroundColor: AppColors.deepOrange,
              foregroundColor: Colors.white,
            ),
            body: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Vendor access not activated yet. Submit the seller request and wait for admin approval.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final storeId = vendorContext['storeId'] as String;
        final storeName = vendorContext['storeName'] as String;

        return Scaffold(
          backgroundColor: const Color(0xFFF6F7FB),
          appBar: AppBar(
            title: Text('$storeName Orders'),
            centerTitle: true,
            backgroundColor: AppColors.deepOrange,
            foregroundColor: Colors.white,
          ),
          body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _orderRepository.watchStoreOrders(storeId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Failed to load orders: ${snapshot.error}'),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          size: 64.sp,
                          color: AppColors.deepOrange,
                        ),
                        SizedBox(height: 12.h),
                        const Text('No store orders yet'),
                        SizedBox(height: 8.h),
                        const Text('New customer orders will appear here.'),
                      ],
                    ),
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
                  final currentStatus = data['status']?.toString() ?? 'Processing';
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
                    child: Padding(
                      padding: EdgeInsets.all(14.w),
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
                              _StatusChip(status: currentStatus),
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
                          Text(
                            'Customer: ${data['userEmail'] ?? 'Unknown'}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Address: ${data['shippingAddress'] ?? 'Not provided'}',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Items: ${items.length} • Total: ৳${data['totalAmount'] ?? 0}',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (data['refundStatus'] != null) ...[
                            SizedBox(height: 6.h),
                            Text(
                              'Refund: ${data['refundStatus']}',
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                          SizedBox(height: 12.h),
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
                                onSelected: (nextStatus) async {
                                  await _handleVendorStatusUpdate(
                                    doc.id,
                                    nextStatus,
                                  );
                                },
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
                                    'Update Status',
                                    style: TextStyle(
                                      color: AppColors.deepOrange,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));
                },
              );
            },
          ),
        );
      },
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
