import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/core/services/order_repository.dart';
import 'package:jihad/features/shared/presentation/screens/order_details_screen.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  final OrderRepository _orderRepository = OrderRepository();

  /// Get image URL from both old and new order item formats
  String _getItemImageUrl(Map<String, dynamic> item) {
    // Try new format: single image field
    if (item['image'] != null && item['image'].toString().isNotEmpty) {
      final imageStr = item['image'].toString();
      if (imageStr.startsWith('http')) {
        return imageStr;
      }
    }

    // Try old format: images array
    final images = item['images'];
    if (images is List && images.isNotEmpty) {
      final firstImage = images[0].toString();
      if (firstImage.startsWith('http')) {
        return firstImage;
      }
      if (firstImage.isNotEmpty) {
        return firstImage;
      }
    }

    // Fallback to default asset
    return 'assets/products/product1.jpg';
  }

  Future<void> _requestRefund(String orderId) async {
    final controller = TextEditingController();

    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Request Refund'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Why do you want a refund?',
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
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    controller.dispose();
    if (reason == null) {
      return;
    }

    try {
      await _orderRepository.requestRefund(orderId: orderId, reason: reason);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Refund request submitted')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Refund request failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Orders",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _orderRepository.watchCurrentUserOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.deepOrange),
            );
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80.sp,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "No orders yet",
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Start shopping to see your orders here",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(20.w),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data();
              final items = (order['items'] as List<dynamic>? ?? []);
              final status = (order['status'] ?? '').toString();
              final refundStatus = order['refundStatus']?.toString();
              final canRequestRefund =
                  status.toLowerCase() == 'delivered' &&
                  (refundStatus == null || refundStatus.isEmpty);

              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailsScreen(
                          order: order,
                          orderDocId: orders[index].id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Order Header
                      Padding(
                        padding: EdgeInsets.all(15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    order['orderId'] ?? 'Order',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                Text(
                                    _formatOrderDate(order['createdAt']),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                            _buildStatusBadge(status),
                          ],
                        ),
                      ),
                      Divider(height: 1),
                      // Product Images
                      if (items.isNotEmpty)
                        Container(
                          height: 80.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 10.h,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: items.length,
                            itemBuilder: (context, itemIndex) {
                              final item = items[itemIndex] as Map<String, dynamic>;
                              final imageUrl = _getItemImageUrl(item);
                              final isNetworkImage = imageUrl.startsWith('http');
                              
                              return Container(
                                margin: EdgeInsets.only(right: 10.w),
                                width: 60.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  image: DecorationImage(
                                    image: isNetworkImage
                                        ? NetworkImage(imageUrl)
                                        : AssetImage(imageUrl) as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      Divider(height: 1),
                      // Payment Method
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.w,
                          vertical: 10.h,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.payment,
                              color: AppColors.deepOrange,
                              size: 20.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "Payment: ${order['paymentMethod'] ?? 'Payment'}",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1),
                      // Order Footer
                      Padding(
                        padding: EdgeInsets.all(15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Amount",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Text(
                                  "৳${order['totalAmount'] ?? order['total'] ?? 0}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                    color: AppColors.deepOrange,
                                  ),
                                ),
                                if (refundStatus != null)
                                  Text(
                                    'Refund: $refundStatus',
                                    style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${items.length} Items",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                if (canRequestRefund)
                                  TextButton(
                                    onPressed: () =>
                                        _requestRefund(orders[index].id),
                                    child: const Text('Request Refund'),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));
            },
          );
        },
      ),
    );
  }

  String _formatOrderDate(dynamic createdAt) {
    if (createdAt is Timestamp) {
      final date = createdAt.toDate();
      return '${date.day}/${date.month}/${date.year}';
    }

    return 'Today';
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    Color bgColor;

    switch (status) {
      case "Delivered":
        color = Colors.green;
        bgColor = Colors.green.withOpacity(0.1);
        break;
      case "Processing":
        color = Colors.orange;
        bgColor = Colors.orange.withOpacity(0.1);
        break;
      case "Cancelled":
        color = Colors.red;
        bgColor = Colors.red.withOpacity(0.1);
        break;
      default:
        color = Colors.grey;
        bgColor = Colors.grey.withOpacity(0.1);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12.sp,
        ),
      ),
    );
  }
}
