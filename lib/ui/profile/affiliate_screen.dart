import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/affiliate_service.dart';

class AffiliateScreen extends StatefulWidget {
  const AffiliateScreen({super.key});

  @override
  State<AffiliateScreen> createState() => _AffiliateScreenState();
}

class _AffiliateScreenState extends State<AffiliateScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('রেফারাল প্রোগ্রাম 💰'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'ওভারভিউ'),
            Tab(text: 'রেফারালস'),
            Tab(text: 'উইথড্র'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildReferralsTab(),
          _buildWithdrawTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final stats = AffiliateService.getStats();
    final referralCode = AffiliateService.getReferralCode();
    final referralLink = AffiliateService.generateReferralLink();
    final commissionRates = AffiliateService.getCommissionRates();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Cards
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade700, Colors.teal.shade400],
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'মোট আয়',
                      '৳${stats['totalEarnings']}',
                      Icons.account_balance_wallet,
                    ),
                    _buildStatCard(
                      'পেন্ডিং',
                      '৳${stats['pendingEarnings']}',
                      Icons.hourglass_empty,
                    ),
                    _buildStatCard(
                      'উইথড্র যোগ্য',
                      '৳${stats['withdrawableBalance']}',
                      Icons.money,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Divider(color: Colors.white30),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'মোট রেফার',
                      '${stats['totalReferrals']}',
                      Icons.people,
                    ),
                    _buildStatCard(
                      'অ্যাক্টিভ',
                      '${stats['activeReferrals']}',
                      Icons.person_outline,
                    ),
                    _buildStatCard(
                      'কনভার্সন',
                      '${stats['conversionRate']}%',
                      Icons.trending_up,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Referral Code
          Text(
            'আপনার রেফারাল কোড',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.teal.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    referralCode,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.teal.shade700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: referralCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('কোড কপি করা হয়েছে!')),
                    );
                  },
                  icon: Icon(Icons.copy, color: Colors.teal.shade700),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          // Share Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: referralLink));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('লিংক কপি করা হয়েছে!')),
                    );
                  },
                  icon: const Icon(Icons.link),
                  label: const Text('লিংক কপি'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  label: const Text('শেয়ার করুন'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Commission Rates
          Text(
            'কমিশন রেট',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          ...commissionRates.map(
            (rate) => Container(
              margin: EdgeInsets.only(bottom: 8.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withAlpha(30),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rate['category'] as String,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${rate['rate']}%',
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24.sp),
        SizedBox(height: 8.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 11.sp),
        ),
      ],
    );
  }

  Widget _buildReferralsTab() {
    final referrals = AffiliateService.getReferralHistory();

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: referrals.length,
      itemBuilder: (context, index) {
        final referral = referrals[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundColor: Colors.teal.shade100,
                  child: Text(
                    (referral['name'] as String).substring(0, 1),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
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
                            referral['name'] as String,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: referral['status'] == 'active'
                                  ? Colors.green.shade100
                                  : Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              referral['status'] == 'active'
                                  ? 'অ্যাক্টিভ'
                                  : 'পেন্ডিং',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: referral['status'] == 'active'
                                    ? Colors.green.shade700
                                    : Colors.orange.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'যোগ দিয়েছেন: ${_formatDate(referral['joinedDate'] as DateTime)}',
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${referral['totalOrders']} অর্ডার • ৳${referral['commission']} কমিশন',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWithdrawTab() {
    final balance = AffiliateService.getWithdrawableBalance();
    final history = AffiliateService.getWithdrawHistory();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade600, Colors.green.shade400],
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Text(
                  'উইথড্র যোগ্য ব্যালেন্স',
                  style: TextStyle(color: Colors.white70, fontSize: 14.sp),
                ),
                SizedBox(height: 8.h),
                Text(
                  '৳${balance.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: balance >= 500
                      ? () => _showWithdrawDialog()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green.shade700,
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 12.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: const Text('উইথড্র করুন'),
                ),
                SizedBox(height: 8.h),
                Text(
                  'ন্যূনতম উইথড্র: ৳৫০০',
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Withdraw History
          Text(
            'উইথড্র হিস্ট্রি',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),

          ...history.map(
            (item) => Card(
              margin: EdgeInsets.only(bottom: 10.h),
              child: ListTile(
                leading: Container(
                  width: 45.w,
                  height: 45.w,
                  decoration: BoxDecoration(
                    color: _getMethodColor(
                      item['method'] as String,
                    ).withAlpha(30),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      _getMethodIcon(item['method'] as String),
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                ),
                title: Text(
                  '৳${(item['amount'] as double).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                subtitle: Text(
                  '${item['method']} • ${item['account']}\n${_formatDate(item['date'] as DateTime)}',
                  style: TextStyle(fontSize: 12.sp),
                ),
                isThreeLine: true,
                trailing: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: item['status'] == 'completed'
                        ? Colors.green.shade100
                        : Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    item['status'] == 'completed' ? 'সম্পন্ন' : 'প্রসেসিং',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: item['status'] == 'completed'
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getMethodColor(String method) {
    switch (method) {
      case 'bKash':
        return Colors.pink;
      case 'Nagad':
        return Colors.orange;
      case 'Rocket':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getMethodIcon(String method) {
    switch (method) {
      case 'bKash':
        return '📱';
      case 'Nagad':
        return '💳';
      case 'Rocket':
        return '🚀';
      default:
        return '💰';
    }
  }

  void _showWithdrawDialog() {
    String? selectedMethod;
    final amountController = TextEditingController();
    final accountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('উইথড্র করুন'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'পরিমাণ (৳)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              DropdownButtonFormField<String>(
                value: selectedMethod,
                decoration: InputDecoration(
                  labelText: 'মেথড',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                items: ['bKash', 'Nagad', 'Rocket'].map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (value) {
                  setDialogState(() => selectedMethod = value);
                },
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: accountController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'অ্যাকাউন্ট নম্বর',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedMethod != null &&
                    amountController.text.isNotEmpty &&
                    accountController.text.isNotEmpty) {
                  double amount = double.tryParse(amountController.text) ?? 0;
                  if (AffiliateService.withdraw(
                    amount,
                    selectedMethod!,
                    accountController.text,
                  )) {
                    Navigator.pop(context);
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('উইথড্র রিকোয়েস্ট সাবমিট হয়েছে!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('সাবমিট'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
