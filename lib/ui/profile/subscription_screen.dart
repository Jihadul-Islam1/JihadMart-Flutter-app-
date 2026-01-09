import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/subscription_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlan = -1;

  @override
  Widget build(BuildContext context) {
    final plans = SubscriptionService.getPlans();
    final currentSubscription = SubscriptionService.getActiveSubscription();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('সাবস্ক্রিপশন বক্স 📦'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade700,
                      Colors.deepPurple.shade400,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),
                    Icon(
                      Icons.card_giftcard,
                      size: 50.sp,
                      color: Colors.white.withAlpha(200),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'প্রতি মাসে সারপ্রাইজ পণ্য!',
                      style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Current Subscription
          if (currentSubscription != null)
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(16.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade400, Colors.orange.shade400],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'সক্রিয় সাবস্ক্রিপশন',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      currentSubscription['name'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (currentSubscription['nextDelivery'] != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          'পরবর্তী বক্স: ${_formatDate(currentSubscription['nextDelivery'] as DateTime)}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

          // Plans Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: Text(
                'সাবস্ক্রিপশন প্ল্যান বেছে নিন',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Plans
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildPlanCard(plans[index], index),
              childCount: plans.length,
            ),
          ),

          // Benefits Section
          SliverToBoxAdapter(child: _buildBenefitsSection()),

          // How It Works
          SliverToBoxAdapter(child: _buildHowItWorks()),

          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
      bottomNavigationBar: _selectedPlan >= 0
          ? Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(50),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _subscribeToPlan(plans[_selectedPlan]),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'সাবস্ক্রাইব করুন - ৳${(plans[_selectedPlan]['price'] as double).toStringAsFixed(0)}/মাস',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan, int index) {
    final isSelected = _selectedPlan == index;
    final isPopular = plan['isPopular'] == true;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.deepPurple.withAlpha(50),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              children: [
                if (plan['image'] != null)
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.r),
                    ),
                    child: Image.asset(
                      plan['image'],
                      height: 120.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Color(plan['color'] as int).withAlpha(30),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.card_giftcard,
                              color: Color(plan['color'] as int),
                              size: 28.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan['name'] as String,
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '${(plan['products'] as int)} প্রোডাক্ট/মাস',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '৳${(plan['price'] as double).toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              Text(
                                '/মাস',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        plan['description'] as String,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: (plan['features'] as List<String>).map((
                          feature,
                        ) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check,
                                  size: 14.sp,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  feature,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      if (plan['savings'] != null) ...[
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            '💰 সেভ করুন ৳${plan['savings']}/মাস',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (isPopular)
              Positioned(
                top: 0,
                right: 16.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    '🔥 জনপ্রিয়',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (isSelected)
              Positioned(
                top: 16.h,
                right: 16.w,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.deepPurple,
                  size: 24.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsSection() {
    final benefits = [
      {
        'icon': Icons.savings,
        'title': '৪০% সেভ',
        'subtitle': 'রিটেইল মূল্য থেকে',
      },
      {
        'icon': Icons.local_shipping,
        'title': 'ফ্রি ডেলিভারি',
        'subtitle': 'সারাদেশে',
      },
      {
        'icon': Icons.refresh,
        'title': 'যেকোনো সময় বাতিল',
        'subtitle': 'কোনো জরিমানা নেই',
      },
      {
        'icon': Icons.card_giftcard,
        'title': 'এক্সক্লুসিভ পণ্য',
        'subtitle': 'শুধু সাবস্ক্রাইবারদের জন্য',
      },
    ];

    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✨ সাবস্ক্রিপশন সুবিধা',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          Row(
            children: benefits.take(2).map((benefit) {
              return Expanded(
                child: _buildBenefitItem(
                  benefit['icon'] as IconData,
                  benefit['title'] as String,
                  benefit['subtitle'] as String,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 12.h),
          Row(
            children: benefits.skip(2).map((benefit) {
              return Expanded(
                child: _buildBenefitItem(
                  benefit['icon'] as IconData,
                  benefit['title'] as String,
                  benefit['subtitle'] as String,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Icon(icon, size: 28.sp, color: Colors.deepPurple),
        SizedBox(height: 8.h),
        Text(
          title,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
        ),
        Text(
          subtitle,
          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildHowItWorks() {
    final steps = [
      {'step': '1', 'title': 'প্ল্যান বেছে নিন', 'icon': Icons.touch_app},
      {'step': '2', 'title': 'পেমেন্ট করুন', 'icon': Icons.payment},
      {'step': '3', 'title': 'বক্স পান', 'icon': Icons.card_giftcard},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📋 কিভাবে কাজ করে?',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: steps.map((step) {
              return Column(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        step['icon'] as IconData,
                        color: Colors.deepPurple,
                        size: 24.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    step['title'] as String,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _subscribeToPlan(Map<String, dynamic> plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('সাবস্ক্রিপশন নিশ্চিত করুন'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('প্ল্যান: ${plan['name']}'),
            Text('মূল্য: ৳${(plan['price'] as double).toStringAsFixed(0)}/মাস'),
            SizedBox(height: 8.h),
            const Text('প্রতি মাসে আপনার ঠিকানায় বক্স পৌঁছে যাবে।'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('সাবস্ক্রিপশন সফল! পেমেন্ট পেজে যাচ্ছে...'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            child: const Text('পেমেন্ট করুন'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}
