import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/utils/gift_card_service.dart';

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({super.key});

  @override
  _GiftCardScreenState createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends State<GiftCardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _codeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    GiftCardService.addDemoGiftCard(); // Add demo card for testing
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          "Gift Cards",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.deepOrange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.deepOrange,
          tabs: [
            Tab(text: "My Cards"),
            Tab(text: "Redeem"),
            Tab(text: "Buy"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildMyCardsTab(), _buildRedeemTab(), _buildBuyTab()],
      ),
    );
  }

  Widget _buildMyCardsTab() {
    List<Map<String, dynamic>> myCards = GiftCardService.getMyGiftCards();
    double totalBalance = GiftCardService.getTotalGiftCardBalance();

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          // Total Balance Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(25.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.deepOrange, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepOrange.withOpacity(0.4),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "মোট Gift Card ব্যালেন্স",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "৳${totalBalance.toStringAsFixed(0)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "${myCards.length} টি কার্ড",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 25.h),

          // My Cards List
          if (myCards.isEmpty)
            _buildEmptyState(
              "কোনো Gift Card নেই",
              "নতুন কার্ড Redeem করুন বা কিনুন",
              Icons.card_giftcard,
            )
          else
            ...myCards.map((card) => _buildGiftCardItem(card)),
        ],
      ),
    );
  }

  Widget _buildGiftCardItem(Map<String, dynamic> card) {
    Map<String, dynamic> design = card["design"];
    DateTime expiresAt = card["expiresAt"];
    int daysLeft = expiresAt.difference(DateTime.now()).inDays;

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(design["color"]),
            Color(design["color"]).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(design["color"]).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(design["icon"], style: TextStyle(fontSize: 30.sp)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    design["name"],
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              "৳${card["balance"]}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "ব্যালেন্স",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card["code"],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12.sp,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  "$daysLeft দিন বাকি",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRedeemTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Icon(Icons.card_giftcard, size: 80.sp, color: AppColors.deepOrange),
          SizedBox(height: 20.h),
          Text(
            "Gift Card Redeem করুন",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.h),
          Text(
            "আপনার ১৬-ডিজিট কোড দিন",
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
          SizedBox(height: 30.h),
          TextField(
            controller: _codeController,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: "XXXX-XXXX-XXXX-XXXX",
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 18.h,
              ),
            ),
            textCapitalization: TextCapitalization.characters,
          ),
          SizedBox(height: 25.h),
          SizedBox(
            width: double.infinity,
            height: 55.h,
            child: ElevatedButton(
              onPressed: () => _redeemCard(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              child: Text(
                "Redeem করুন",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 15.w),
                Expanded(
                  child: Text(
                    "Gift Card কোড সাধারণত ইমেইল বা SMS এ পাওয়া যায়",
                    style: TextStyle(color: Colors.blue[700], fontSize: 13.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "পরিমাণ বাছুন",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: GiftCardService.denominations.map((amount) {
              return GestureDetector(
                onTap: () => _showBuyDialog(amount),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.w,
                    vertical: 15.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Text(
                    "৳$amount",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 30.h),
          Text(
            "ডিজাইন বাছুন",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15.h),
          ...GiftCardService.designs.map((design) {
            return GestureDetector(
              onTap: () => _showBuyDialog(
                1000,
                designIndex: GiftCardService.designs.indexOf(design),
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Color(design["color"]).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(design["color"]).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Text(design["icon"], style: TextStyle(fontSize: 30.sp)),
                    SizedBox(width: 15.w),
                    Text(
                      design["name"],
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Container(
      padding: EdgeInsets.all(40.w),
      child: Column(
        children: [
          Icon(icon, size: 60.sp, color: Colors.grey[400]),
          SizedBox(height: 20.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _redeemCard() {
    String code = _codeController.text.trim().toUpperCase();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("কোড দিন"), backgroundColor: Colors.red),
      );
      return;
    }

    bool success = GiftCardService.redeemGiftCard(code);

    if (success) {
      setState(() {});
      _codeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gift Card সফলভাবে Redeem হয়েছে! 🎉"),
          backgroundColor: Colors.green,
        ),
      );
      _tabController.animateTo(0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid কোড বা ইতিমধ্যে ব্যবহৃত"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showBuyDialog(int amount, {int designIndex = 0}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Gift Card কিনুন"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "৳$amount",
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.deepOrange,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: "প্রাপকের নাম",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: "প্রাপকের ইমেইল",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: "বার্তা (ঐচ্ছিক)",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("বাতিল"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Gift Card কেনা সম্পন্ন! 🎁"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepOrange,
            ),
            child: Text(
              "৳$amount দিয়ে কিনুন",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
