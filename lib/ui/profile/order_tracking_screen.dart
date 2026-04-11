import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/core/services/order_repository.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  static final OrderRepository _orderRepository = OrderRepository();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Order Tracking",
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
                    Icons.local_shipping_outlined,
                    size: 80.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "No Orders to Track",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Place an order to track it here",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
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
              return _buildOrderTrackingCard(context, order);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderTrackingCard(
    BuildContext context,
    Map<String, dynamic> order,
  ) {
    final trackingSteps = _getTrackingSteps();
    final currentStep = _getCurrentStep(order);
    final items = (order['items'] as List<dynamic>? ?? []);

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _formatOrderDate(order['createdAt']),
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(currentStep).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(currentStep),
                  style: TextStyle(
                    color: _getStatusColor(currentStep),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          if (items.isNotEmpty)
            Container(
              height: 60.h,
              margin: EdgeInsets.only(bottom: 15.h),
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
                      border: Border.all(color: Colors.grey.shade200),
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
          Divider(color: Colors.grey[200]),
          SizedBox(height: 15.h),
          ...List.generate(trackingSteps.length, (stepIndex) {
            final step = trackingSteps[stepIndex];
            final isCompleted = stepIndex <= currentStep;
            final isActive = stepIndex == currentStep;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.deepOrange
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.deepOrange.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : Icons.circle,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                    ),
                    if (stepIndex < trackingSteps.length - 1)
                      Container(
                        width: 2,
                        height: 40.h,
                        color: isCompleted
                            ? AppColors.deepOrange
                            : Colors.grey[300],
                      ),
                  ],
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: stepIndex < trackingSteps.length - 1 ? 20.h : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step['title'],
                          style: TextStyle(
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 14.sp,
                            color: isCompleted
                                ? Colors.black87
                                : Colors.grey[500],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          step['description'],
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
          SizedBox(height: 15.h),
          Divider(color: Colors.grey[200]),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.grey[600],
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  order['shippingAddress'] ?? 'Delivery address',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.payment_outlined,
                color: Colors.grey[600],
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                '${order['paymentMethod'] ?? 'Payment'} • ৳${order['totalAmount'] ?? '0'}',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getTrackingSteps() {
    return [
      {
        'title': 'Order Placed',
        'description': 'Your order has been placed successfully',
      },
      {
        'title': 'Order Confirmed',
        'description': 'Seller has confirmed your order',
      },
      {
        'title': 'Shipped',
        'description': 'Your order is on the way',
      },
      {
        'title': 'Out for Delivery',
        'description': 'Order will reach you soon',
      },
      {
        'title': 'Delivered',
        'description': 'Order has been delivered',
      },
    ];
  }

  int _getCurrentStep(Map<String, dynamic> order) {
    final status = (order['status'] as String? ?? 'processing').toLowerCase();
    switch (status) {
      case 'placed':
      case 'processing':
        return 0;
      case 'confirmed':
        return 1;
      case 'shipped':
        return 2;
      case 'out for delivery':
        return 3;
      case 'delivered':
        return 4;
      default:
        return 0;
    }
  }

  String _getStatusText(int step) {
    switch (step) {
      case 0:
        return 'Placed';
      case 1:
        return 'Confirmed';
      case 2:
        return 'Shipped';
      case 3:
        return 'Out for Delivery';
      case 4:
        return 'Delivered';
      default:
        return 'Processing';
    }
  }

  Color _getStatusColor(int step) {
    switch (step) {
      case 0:
      case 1:
        return Colors.orange;
      case 2:
      case 3:
        return Colors.blue;
      case 4:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatOrderDate(dynamic createdAt) {
    if (createdAt is Timestamp) {
      final date = createdAt.toDate();
      return '${date.day}/${date.month}/${date.year}';
    }

    return 'Today';
  }
}
