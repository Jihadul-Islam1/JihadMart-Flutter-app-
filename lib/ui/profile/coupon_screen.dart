import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/coupon_service.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('কুপন ও ভাউচার 🎫'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'উপলব্ধ কুপন'),
            Tab(text: 'ব্যবহৃত'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Coupon Input
          Container(
            padding: EdgeInsets.all(16.w),
            color: Colors.purple.shade50,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'কুপন কোড লিখুন',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(
                        Icons.confirmation_number_outlined,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                ElevatedButton(
                  onPressed: () => _applyCoupon(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: const Text('যাচাই'),
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildAvailableCoupons(), _buildUsedCoupons()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableCoupons() {
    final coupons = CouponService.getAvailableCoupons();

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        final coupon = coupons[index];
        return _buildCouponCard(coupon);
      },
    );
  }

  Widget _buildCouponCard(Map<String, dynamic> coupon) {
    final isNew = coupon['isNew'] == true;
    final expiresAt = coupon['expiresAt'] as DateTime;
    final daysLeft = expiresAt.difference(DateTime.now()).inDays;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Coupon Header
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _getCouponGradient(coupon['type'] as String),
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    _getCouponIcon(coupon['type'] as String),
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            coupon['type'] == 'percentage'
                                ? '${(coupon['value'] as double).toStringAsFixed(0)}% ছাড়'
                                : coupon['type'] == 'shipping'
                                ? 'ফ্রি ডেলিভারি'
                                : '৳${(coupon['value'] as double).toStringAsFixed(0)} ছাড়',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isNew) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                'NEW',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        coupon['description'] as String,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Dashed Line
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: List.generate(
                30,
                (index) => Expanded(
                  child: Container(
                    height: 1,
                    color: index.isEven
                        ? Colors.grey.shade300
                        : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),

          // Coupon Footer
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Text(
                              coupon['code'] as String,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(text: coupon['code'] as String),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('কোড কপি করা হয়েছে!'),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.copy,
                              size: 18.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14.sp,
                            color: daysLeft <= 3 ? Colors.red : Colors.grey,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            daysLeft <= 0 ? 'আজই শেষ!' : '$daysLeft দিন বাকি',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: daysLeft <= 3 ? Colors.red : Colors.grey,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 14.sp,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'ন্যূনতম ৳${(coupon['minOrder'] as double).toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _useCoupon(coupon),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 12.h,
                    ),
                  ),
                  child: const Text('ব্যবহার করুন'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsedCoupons() {
    final usedCoupons = CouponService.getUsedCoupons();

    if (usedCoupons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 60.sp, color: Colors.grey.shade300),
            SizedBox(height: 16.h),
            Text(
              'কোনো ব্যবহৃত কুপন নেই',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: usedCoupons.length,
      itemBuilder: (context, index) {
        final coupon = usedCoupons[index];
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coupon['code'] as String,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'সেভ হয়েছে: ৳${(coupon['savedAmount'] as double).toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Text(
                _formatDate(coupon['usedAt'] as DateTime),
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Color> _getCouponGradient(String type) {
    switch (type) {
      case 'percentage':
        return [Colors.purple.shade600, Colors.purple.shade400];
      case 'fixed':
        return [Colors.blue.shade600, Colors.blue.shade400];
      case 'shipping':
        return [Colors.green.shade600, Colors.green.shade400];
      default:
        return [Colors.grey.shade600, Colors.grey.shade400];
    }
  }

  IconData _getCouponIcon(String type) {
    switch (type) {
      case 'percentage':
        return Icons.percent;
      case 'fixed':
        return Icons.attach_money;
      case 'shipping':
        return Icons.local_shipping;
      default:
        return Icons.confirmation_number;
    }
  }

  void _applyCoupon() {
    if (_couponController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('কুপন কোড লিখুন')));
      return;
    }

    final result = CouponService.validateCoupon(
      _couponController.text,
      1000, // Sample order total
      'all',
    );

    if (result != null && result['valid'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'কুপন প্রয়োগ হয়েছে! ৳${result['discount']} ছাড় পাবেন',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result?['message'] ?? 'কুপন বৈধ নয়'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _useCoupon(Map<String, dynamic> coupon) {
    Clipboard.setData(ClipboardData(text: coupon['code'] as String));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${coupon['code']} কপি হয়েছে! চেকআউটে ব্যবহার করুন'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'শপিং করুন',
          textColor: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
