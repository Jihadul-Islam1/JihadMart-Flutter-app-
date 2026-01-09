import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/AppColors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      "title": "Order Confirmed! 🎉",
      "message":
          "Your order #ORD-2025-001 has been confirmed and is being processed.",
      "time": "2 min ago",
      "type": "order",
      "isRead": false,
    },
    {
      "title": "Flash Sale Starting Soon! ⚡",
      "message":
          "Get ready! Flash sale starts in 1 hour with up to 50% off on electronics.",
      "time": "1 hour ago",
      "type": "promo",
      "isRead": false,
    },
    {
      "title": "Order Shipped 📦",
      "message":
          "Your order #ORD-2025-002 has been shipped. Track your delivery now!",
      "time": "3 hours ago",
      "type": "order",
      "isRead": true,
    },
    {
      "title": "New Coupon Available! 🎁",
      "message":
          "Use code SAVE20 to get 20% off on your next purchase. Valid till Dec 31.",
      "time": "Yesterday",
      "type": "promo",
      "isRead": true,
    },
    {
      "title": "Payment Successful ✅",
      "message":
          "Payment of ৳2,500 for order #ORD-2025-003 was successful via bKash.",
      "time": "2 days ago",
      "type": "payment",
      "isRead": true,
    },
    {
      "title": "Order Delivered! 🚚",
      "message":
          "Your order #ORD-2024-099 has been delivered. Please rate your experience!",
      "time": "3 days ago",
      "type": "order",
      "isRead": true,
    },
    {
      "title": "Price Drop Alert! 📉",
      "message":
          "An item in your wishlist is now ৳500 cheaper! Check it out before it's gone.",
      "time": "5 days ago",
      "type": "promo",
      "isRead": true,
    },
  ];

  IconData _getIcon(String type) {
    switch (type) {
      case "order":
        return Icons.shopping_bag_outlined;
      case "promo":
        return Icons.local_offer_outlined;
      case "payment":
        return Icons.payment_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case "order":
        return Colors.blue;
      case "promo":
        return Colors.orange;
      case "payment":
        return Colors.green;
      default:
        return Colors.grey;
    }
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
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var notification in _notifications) {
                  notification['isRead'] = true;
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("All notifications marked as read"),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: Text(
              "Mark all read",
              style: TextStyle(color: AppColors.deep_orange, fontSize: 12.sp),
            ),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80.sp,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "No Notifications",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "You're all caught up!",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(20.w),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return Dismissible(
                  key: Key(notification['title'] + index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.w),
                    margin: EdgeInsets.only(bottom: 15.h),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _notifications.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Notification deleted"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        notification['isRead'] = true;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15.h),
                      padding: EdgeInsets.all(15.w),
                      decoration: BoxDecoration(
                        color: notification['isRead']
                            ? Colors.white
                            : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                        border: notification['isRead']
                            ? null
                            : Border.all(
                                color: AppColors.deep_orange.withOpacity(0.3),
                              ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: _getColor(
                                notification['type'],
                              ).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIcon(notification['type']),
                              color: _getColor(notification['type']),
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification['title'],
                                        style: TextStyle(
                                          fontWeight: notification['isRead']
                                              ? FontWeight.w600
                                              : FontWeight.bold,
                                          fontSize: 14.sp,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    if (!notification['isRead'])
                                      Container(
                                        width: 8.w,
                                        height: 8.w,
                                        decoration: const BoxDecoration(
                                          color: AppColors.deep_orange,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  notification['message'],
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  notification['time'],
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
