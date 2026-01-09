import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:jihad/utils/order_statistics_service.dart';

class OrderStatisticsScreen extends StatefulWidget {
  @override
  _OrderStatisticsScreenState createState() => _OrderStatisticsScreenState();
}

class _OrderStatisticsScreenState extends State<OrderStatisticsScreen> {
  @override
  void initState() {
    super.initState();
    OrderStatisticsService.addDemoData();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> stats = OrderStatisticsService.getStatistics();

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
          "অর্ডার পরিসংখ্যান",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards Row 1
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "মোট অর্ডার",
                    "${stats['totalOrders']}",
                    Icons.shopping_bag,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: _buildStatCard(
                    "মোট খরচ",
                    "৳${stats['totalSpent'].toStringAsFixed(0)}",
                    Icons.payments,
                    Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),

            // Summary Cards Row 2
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    "সেভ করেছেন",
                    "৳${stats['totalSaved'].toStringAsFixed(0)}",
                    Icons.savings,
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: _buildStatCard(
                    "গড় অর্ডার",
                    "৳${stats['averageOrderValue'].toStringAsFixed(0)}",
                    Icons.analytics,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            SizedBox(height: 25.h),

            // Order Status
            Text(
              "অর্ডার স্ট্যাটাস",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.h),
            Container(
              padding: EdgeInsets.all(20.w),
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
                  _buildStatusRow(
                    "সম্পন্ন",
                    stats['completedOrders'],
                    Colors.green,
                    stats['totalOrders'],
                  ),
                  SizedBox(height: 15.h),
                  _buildStatusRow(
                    "পেন্ডিং",
                    stats['pendingOrders'],
                    Colors.orange,
                    stats['totalOrders'],
                  ),
                  SizedBox(height: 15.h),
                  _buildStatusRow(
                    "বাতিল",
                    stats['cancelledOrders'],
                    Colors.red,
                    stats['totalOrders'],
                  ),
                  SizedBox(height: 15.h),
                  _buildStatusRow(
                    "রিটার্ন",
                    stats['returnedOrders'],
                    Colors.grey,
                    stats['totalOrders'],
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.h),

            // Category Spending
            Text(
              "ক্যাটাগরি অনুযায়ী খরচ",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.h),
            Container(
              padding: EdgeInsets.all(20.w),
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
                  _buildCategoryRow(
                    "Shoes",
                    18000,
                    Icons.directions_run,
                    Colors.blue,
                  ),
                  Divider(height: 25.h),
                  _buildCategoryRow(
                    "Fashion",
                    12000,
                    Icons.checkroom,
                    Colors.pink,
                  ),
                  Divider(height: 25.h),
                  _buildCategoryRow(
                    "Electronics",
                    8000,
                    Icons.devices,
                    Colors.indigo,
                  ),
                  Divider(height: 25.h),
                  _buildCategoryRow("Watches", 6000, Icons.watch, Colors.amber),
                  Divider(height: 25.h),
                  _buildCategoryRow(
                    "Furniture",
                    1000,
                    Icons.chair,
                    Colors.brown,
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.h),

            // Loyalty & Rewards
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.deep_orange, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Icon(Icons.stars, color: Colors.white, size: 40.sp),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "লয়্যালটি পয়েন্ট অর্জিত",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          "${stats['loyaltyPointsEarned']} পয়েন্ট",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "রিডিম করুন",
                      style: TextStyle(
                        color: AppColors.deep_orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25.h),

            // Recent Orders
            Text(
              "সাম্প্রতিক অর্ডার",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.h),
            ...(stats['orderHistory'] as List).take(5).map((order) {
              return Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.deep_orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        color: AppColors.deep_orange,
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['category'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            "${order['itemCount']} items",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "৳${order['amount'].toStringAsFixed(0)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          "-৳${order['discount'].toStringAsFixed(0)}",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(15.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.h),
          Text(
            title,
            style: TextStyle(color: Colors.grey, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String title, int count, Color color, int total) {
    double percentage = total > 0 ? count / total : 0;

    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyle(fontSize: 14.sp)),
                  Text(
                    "$count",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(
    String title,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Text(title, style: TextStyle(fontSize: 14.sp)),
        ),
        Text(
          "৳${amount.toStringAsFixed(0)}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
        ),
      ],
    );
  }
}
