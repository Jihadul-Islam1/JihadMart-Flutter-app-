import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:jihad/utils/order_service.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = OrderService().orders;

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
      body: orders.isEmpty
          ? Center(
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
            )
          : ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order =
                    orders[orders.length - 1 - index]; // Show latest first
                return _buildOrderTrackingCard(context, order, index);
              },
            ),
    );
  }

  Widget _buildOrderTrackingCard(
    BuildContext context,
    Map<String, dynamic> order,
    int index,
  ) {
    // Simulate different tracking statuses based on order index
    final List<Map<String, dynamic>> trackingSteps = _getTrackingSteps(index);
    final int currentStep = _getCurrentStep(index);

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
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order['orderId'] ??
                        'ORD-${DateTime.now().millisecondsSinceEpoch}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    order['date'] ?? 'Today',
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

          // Product Images
          if (order['items'] != null && (order['items'] as List).isNotEmpty)
            Container(
              height: 60.h,
              margin: EdgeInsets.only(bottom: 15.h),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: (order['items'] as List).length,
                itemBuilder: (context, itemIndex) {
                  var item = order['items'][itemIndex];
                  return Container(
                    margin: EdgeInsets.only(right: 10.w),
                    width: 60.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                      image: DecorationImage(
                        image: AssetImage(item['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),

          Divider(color: Colors.grey[200]),
          SizedBox(height: 15.h),

          // Tracking Timeline
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
                            ? AppColors.deep_orange
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: AppColors.deep_orange.withOpacity(0.3),
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
                            ? AppColors.deep_orange
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
                        if (isCompleted && step['time'] != null) ...[
                          SizedBox(height: 4.h),
                          Text(
                            step['time'],
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
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

          // Delivery Info
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
                  order['address'] ?? 'Delivery address',
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
                '${order['paymentMethod'] ?? 'Payment'} • ৳${order['total'] ?? '0'}',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getTrackingSteps(int orderIndex) {
    return [
      {
        'title': 'Order Placed',
        'description': 'Your order has been placed successfully',
        'time': 'Today, 10:30 AM',
      },
      {
        'title': 'Order Confirmed',
        'description': 'Seller has confirmed your order',
        'time': 'Today, 10:45 AM',
      },
      {
        'title': 'Shipped',
        'description': 'Your order is on the way',
        'time': orderIndex > 0 ? 'Today, 2:00 PM' : null,
      },
      {
        'title': 'Out for Delivery',
        'description': 'Order will reach you soon',
        'time': orderIndex > 1 ? 'Today, 5:30 PM' : null,
      },
      {
        'title': 'Delivered',
        'description': 'Order has been delivered',
        'time': orderIndex > 2 ? 'Today, 6:15 PM' : null,
      },
    ];
  }

  int _getCurrentStep(int orderIndex) {
    // Simulate different progress based on order position
    if (orderIndex == 0) return 1; // Latest order - just confirmed
    if (orderIndex == 1) return 2; // Second order - shipped
    if (orderIndex == 2) return 3; // Third order - out for delivery
    return 4; // Older orders - delivered
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
}
