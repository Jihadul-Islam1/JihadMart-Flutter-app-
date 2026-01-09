import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/flash_sale_service.dart';

class FlashSaleScreen extends StatefulWidget {
  const FlashSaleScreen({super.key});

  @override
  State<FlashSaleScreen> createState() => _FlashSaleScreenState();
}

class _FlashSaleScreenState extends State<FlashSaleScreen> {
  @override
  Widget build(BuildContext context) {
    final activeSales = FlashSaleService.getActiveFlashSales();
    final upcomingSales = FlashSaleService.getUpcomingFlashSales();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flash Sale ⚡'),
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Active Flash Sales
            if (activeSales.isNotEmpty) ...[
              ...activeSales.map((sale) => _buildActiveSale(sale)),
            ],

            // Upcoming Flash Sales
            if (upcomingSales.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  'আসন্ন ফ্ল্যাশ সেল 🔜',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...upcomingSales.map((sale) => _buildUpcomingSale(sale)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSale(Map<String, dynamic> sale) {
    final timeLeft = FlashSaleService.getRemainingTime(sale['id']);
    final products = sale['products'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sale Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade700, Colors.orange.shade600],
            ),
          ),
          child: Column(
            children: [
              Text(
                sale['name'] as String,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimeBox('${timeLeft.inHours}', 'ঘন্টা'),
                  _buildTimeSeparator(),
                  _buildTimeBox('${timeLeft.inMinutes % 60}', 'মিনিট'),
                  _buildTimeSeparator(),
                  _buildTimeBox('${timeLeft.inSeconds % 60}', 'সেকেন্ড'),
                ],
              ),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${sale['totalSold']}+ বিক্রি হয়েছে',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ],
          ),
        ),

        // Products Grid
        Padding(
          padding: EdgeInsets.all(16.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.7,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final stockProgress = FlashSaleService.getStockProgress(product);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withAlpha(30),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12.r),
                          ),
                          child: Container(
                            height: 120.h,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: Icon(
                              Icons.image,
                              size: 40.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              product['discount'] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Product Details
                    Padding(
                      padding: EdgeInsets.all(10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['name'] as String,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Text(
                                '৳${(product['salePrice'] as double).toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '৳${(product['originalPrice'] as double).toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          // Stock Progress
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.r),
                                child: LinearProgressIndicator(
                                  value: stockProgress,
                                  minHeight: 8.h,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    stockProgress > 0.8
                                        ? Colors.red
                                        : Colors.orange,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${product['sold']}/${product['stock']} বিক্রি',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeBox(String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            value.padLeft(2, '0'),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Text(
        ':',
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUpcomingSale(Map<String, dynamic> sale) {
    final startTime = sale['startTime'] as DateTime;
    final timeUntil = startTime.difference(DateTime.now());

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text('⏰', style: TextStyle(fontSize: 28.sp)),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sale['name'] as String,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${sale['productCount']} প্রোডাক্ট • ${sale['maxDiscount']} পর্যন্ত ছাড়',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                SizedBox(height: 4.h),
                Text(
                  'শুরু হবে: ${_formatTimeUntil(timeUntil)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              FlashSaleService.setReminder(sale['id']);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('রিমাইন্ডার সেট করা হয়েছে! 🔔'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            ),
            child: const Text('রিমাইন্ড'),
          ),
        ],
      ),
    );
  }

  String _formatTimeUntil(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} দিন ${duration.inHours % 24} ঘন্টা পর';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ঘন্টা ${duration.inMinutes % 60} মিনিট পর';
    } else {
      return '${duration.inMinutes} মিনিট পর';
    }
  }
}
