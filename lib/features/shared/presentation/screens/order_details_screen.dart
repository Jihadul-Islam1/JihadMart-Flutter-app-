import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/app_colors.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;
  final String? orderDocId;

  const OrderDetailsScreen({
    super.key,
    required this.order,
    this.orderDocId,
  });

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
    final items = (order['items'] as List<dynamic>? ?? []);
    final statusHistory =
        (order['statusHistory'] as List<dynamic>? ?? []).cast<dynamic>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
        backgroundColor: AppColors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: order['orderId']?.toString() ?? orderDocId ?? 'Order',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRow('Status', order['status']?.toString() ?? 'Processing'),
                  _buildRow('Payment', order['paymentMethod']?.toString() ?? '-'),
                  _buildRow(
                    'Total',
                    '৳${(order['totalAmount'] ?? order['total'] ?? 0).toString()}',
                  ),
                  _buildRow(
                    'Address',
                    order['shippingAddress']?.toString() ?? 'Not provided',
                  ),
                  _buildRow('Date', _formatDate(order['createdAt'])),
                  if (order['refundStatus'] != null)
                    _buildRow('Refund', order['refundStatus'].toString()),
                  if (order['refundPayoutId'] != null)
                    _buildRow('Payout', order['refundPayoutId'].toString()),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            _buildSection(
              title: 'Items (${items.length})',
              child: Column(
                children: items.map((dynamic raw) {
                  final item = (raw as Map).cast<String, dynamic>();
                  final imageUrl = _getItemImageUrl(item);
                  final isNetworkImage = imageUrl.startsWith('http');
                  final qty = item['quantity'] ?? 1;
                  final name = item['name'] ?? 'Item';
                  final price = item['price'] ?? item['product-price'] ?? 0;

                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Container(
                            width: 54.w,
                            height: 54.w,
                            color: Colors.grey.shade200,
                            child: isNetworkImage
                                ? Image.network(imageUrl, fit: BoxFit.cover)
                                : Image.asset(imageUrl, fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            '$name x$qty',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                        Text(
                          '৳$price',
                          style: TextStyle(
                            color: AppColors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 12.h),
            _buildSection(
              title: 'Status Timeline',
              child: statusHistory.isEmpty
                  ? const Text('No status history yet')
                  : Column(
                      children: statusHistory.map((dynamic raw) {
                        final step = (raw as Map).cast<String, dynamic>();
                        final status = step['status']?.toString() ?? '-';
                        final note = step['note']?.toString() ?? '';
                        final actor = step['actorEmail']?.toString() ?? 'system';
                        final changedAt = step['changedAt']?.toString() ?? '-';

                        return Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 8.h),
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                status,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                              if (note.isNotEmpty)
                                Padding(
                                  padding: EdgeInsets.only(top: 4.h),
                                  child: Text(
                                    note,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              SizedBox(height: 4.h),
                              Text(
                                '$actor • $changedAt',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90.w,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic createdAt) {
    if (createdAt is Timestamp) {
      final d = createdAt.toDate();
      return '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
    }

    return 'Unknown';
  }
}
