import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/utils/loyalty_service.dart';

class LoyaltyScreen extends StatefulWidget {
  const LoyaltyScreen({super.key});

  @override
  _LoyaltyScreenState createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen> {
  @override
  Widget build(BuildContext context) {
    int points = LoyaltyService.getPoints();
    String tier = LoyaltyService.getMembershipTier();
    Color tierColor = LoyaltyService.getTierColor();
    int discount = LoyaltyService.getTierDiscount();
    int pointsToNext = LoyaltyService.getPointsToNextTier();
    String nextTier = LoyaltyService.getNextTierName();

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
          "Loyalty Points",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            // Points Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(25.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [tierColor, tierColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: tierColor.withOpacity(0.4),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tier,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "$discount% ছাড়",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "$points",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "পয়েন্ট",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  if (pointsToNext > 0) ...[
                    LinearProgressIndicator(
                      value: points / (points + pointsToNext),
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      minHeight: 8,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "$nextTier পেতে আরো $pointsToNext পয়েন্ট দরকার",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: 25.h),

            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    "পয়েন্ট রিডিম",
                    Icons.redeem,
                    "৳${LoyaltyService.pointsToBDT(points).toStringAsFixed(0)} মূল্যের",
                    () => _showRedeemDialog(),
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: _buildActionCard(
                    "রেফার করুন",
                    Icons.share,
                    "১৫০ পয়েন্ট পান",
                    () => _showReferDialog(),
                  ),
                ),
              ],
            ),

            SizedBox(height: 25.h),

            // Tier Benefits
            Container(
              width: double.infinity,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "মেম্বারশিপ লেভেল",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  ...LoyaltyService.tiers.entries.map((entry) {
                    bool isCurrent = entry.key == tier;
                    return Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? entry.value["color"].withOpacity(0.1)
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(10),
                        border: isCurrent
                            ? Border.all(color: entry.value["color"], width: 2)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.workspace_premium,
                            color: entry.value["color"],
                            size: 24.sp,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  "${entry.value["minPoints"]}+ পয়েন্ট",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "${entry.value["discount"]}% ছাড়",
                            style: TextStyle(
                              color: entry.value["color"],
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                          if (isCurrent) ...[
                            SizedBox(width: 8.w),
                            Icon(
                              Icons.check_circle,
                              color: entry.value["color"],
                              size: 20.sp,
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            SizedBox(height: 25.h),

            // Points History
            Container(
              width: double.infinity,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "পয়েন্ট হিস্টোরি",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  ...LoyaltyService.getPointsHistory().take(5).map((history) {
                    bool isEarned = history["type"] != "redeemed";
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: isEarned
                            ? Colors.green[50]
                            : Colors.red[50],
                        child: Icon(
                          isEarned ? Icons.add : Icons.remove,
                          color: isEarned ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text(
                        history["description"],
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      subtitle: Text(
                        _formatDate(history["date"]),
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      trailing: Text(
                        "${isEarned ? '+' : '-'}${history["points"]}",
                        style: TextStyle(
                          color: isEarned ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    );
                  }),
                  if (LoyaltyService.getPointsHistory().isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Text(
                          "কোনো হিস্টোরি নেই",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
          children: [
            Icon(icon, color: AppColors.deepOrange, size: 30.sp),
            SizedBox(height: 10.h),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            SizedBox(height: 5.h),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey, fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void _showRedeemDialog() {
    int points = LoyaltyService.getPoints();
    double bdtValue = LoyaltyService.pointsToBDT(points);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("পয়েন্ট রিডিম করুন"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("আপনার $points পয়েন্ট আছে"),
            SizedBox(height: 10),
            Text(
              "= ৳${bdtValue.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.deepOrange,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "চেকআউটে পয়েন্ট ব্যবহার করুন",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("ঠিক আছে"),
          ),
        ],
      ),
    );
  }

  void _showReferDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("বন্ধুকে রেফার করুন"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.share, size: 50.sp, color: AppColors.deepOrange),
            SizedBox(height: 15),
            Text("আপনার রেফারেল কোড:"),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "JIHAD2024",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              "প্রতি সফল রেফারেলে ১৫০ পয়েন্ট পাবেন!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("বন্ধ করুন"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("রেফারেল কোড কপি হয়েছে!"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepOrange,
            ),
            child: Text("কপি করুন", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
