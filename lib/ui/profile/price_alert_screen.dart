import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:jihad/utils/price_alert_service.dart';

class PriceAlertScreen extends StatefulWidget {
  const PriceAlertScreen({super.key});

  @override
  _PriceAlertScreenState createState() => _PriceAlertScreenState();
}

class _PriceAlertScreenState extends State<PriceAlertScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    PriceAlertService.addDemoAlerts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          "Price Alerts",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.deep_orange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.deep_orange,
          tabs: [
            Tab(text: "Active (${PriceAlertService.getAlertCount()})"),
            Tab(text: "Triggered (${PriceAlertService.getTriggeredCount()})"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildActiveAlerts(), _buildTriggeredAlerts()],
      ),
    );
  }

  Widget _buildActiveAlerts() {
    List<Map<String, dynamic>> alerts = PriceAlertService.getPriceAlerts();

    if (alerts.isEmpty) {
      return _buildEmptyState(
        "No Price Alerts",
        "Set Price Alerts on your favorite products. We'll notify you when prices drop!",
        Icons.notifications_none,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(15.w),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        return _buildAlertCard(alerts[index], false);
      },
    );
  }

  Widget _buildTriggeredAlerts() {
    List<Map<String, dynamic>> triggered =
        PriceAlertService.getTriggeredAlerts();

    if (triggered.isEmpty) {
      return _buildEmptyState(
        "No Price Drops Yet",
        "Products with price drops will appear here",
        Icons.trending_down,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(15.w),
      itemCount: triggered.length,
      itemBuilder: (context, index) {
        return _buildAlertCard(triggered[index], true);
      },
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert, bool isTriggered) {
    List images = alert['productImages'] ?? [];
    double currentPrice = alert['currentPrice'] ?? 0;
    double targetPrice = alert['targetPrice'] ?? 0;
    double? newPrice = alert['newPrice'];

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: isTriggered ? Border.all(color: Colors.green, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          if (isTriggered)
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.celebration, color: Colors.white, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(
                    "Price Dropped! 🎉",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Row(
              children: [
                Container(
                  width: 70.w,
                  height: 70.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: images.isNotEmpty
                        ? Image.asset(
                            images[0],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.shopping_bag,
                              color: Colors.grey,
                            ),
                          )
                        : const Icon(Icons.shopping_bag, color: Colors.grey),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['productName'],
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          Text(
                            "Current: ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            isTriggered && newPrice != null
                                ? "৳${newPrice.toStringAsFixed(0)}"
                                : "৳${currentPrice.toStringAsFixed(0)}",
                            style: TextStyle(
                              color: isTriggered ? Colors.green : Colors.black,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isTriggered && newPrice != null) ...[
                            SizedBox(width: 8.w),
                            Text(
                              "৳${currentPrice.toStringAsFixed(0)}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "Target: ৳${targetPrice.toStringAsFixed(0)}",
                        style: TextStyle(
                          color: AppColors.deep_orange,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isTriggered)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        PriceAlertService.removePriceAlert(alert['id']);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Alert removed"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Added to Cart!"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.deep_orange,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 8.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Buy",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80.sp, color: Colors.grey[300]),
          SizedBox(height: 20.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
