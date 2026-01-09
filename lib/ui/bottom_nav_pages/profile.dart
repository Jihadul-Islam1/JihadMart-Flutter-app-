import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/ui/admin/add_product_screen.dart';
import 'package:jihad/ui/profile/my_orders.dart';
import 'package:jihad/ui/profile/shipping_address.dart';
import 'package:jihad/ui/profile/coupons_screen.dart';
import 'package:jihad/ui/profile/notifications_screen.dart';
import 'package:jihad/ui/profile/order_tracking_screen.dart';
import 'package:jihad/ui/profile/wallet_screen.dart';
import 'package:jihad/ui/profile/return_request_screen.dart';
import 'package:jihad/ui/profile/loyalty_screen.dart';
import 'package:jihad/ui/profile/gift_card_screen.dart';
import 'package:jihad/ui/profile/address_book_screen.dart';
import 'package:jihad/ui/profile/order_statistics_screen.dart';
import 'package:jihad/ui/profile/daily_deals_screen.dart';
import 'package:jihad/ui/profile/live_chat_screen.dart';
import 'package:jihad/ui/profile/price_alert_screen.dart';
import 'package:jihad/ui/product_compare_screen.dart';
import 'package:jihad/ui/size_guide_screen.dart';
import 'package:jihad/ui/support_screen.dart';
import 'package:jihad/ui/login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isEditing = false;
  bool _isLoading = true;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  // Firebase থেকে user data load করবে
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("users-form-data")
            .doc(_currentUser!.email)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

          setState(() {
            _nameController.text = data['name'] ?? '';
            _phoneController.text = data['phone'] ?? '';
            _ageController.text = data['age'] ?? '';
            _emailController.text = _currentUser!.email ?? '';
            _isLoading = false;
          });
        } else {
          // যদি user data না থাকে, default values set করবে
          setState(() {
            _nameController.text = '';
            _phoneController.text = '';
            _ageController.text = '';
            _emailController.text = _currentUser!.email ?? '';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading user data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Firebase এ user data update করবে
  Future<void> _updateUserData() async {
    try {
      if (_currentUser != null) {
        await FirebaseFirestore.instance
            .collection("users-form-data")
            .doc(_currentUser!.email)
            .set({
              "name": _nameController.text,
              "phone": _phoneController.text,
              "age": _ageController.text,
              "email": _currentUser!.email,
              "updatedAt": FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Profile updated successfully!"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          setState(() {
            _isEditing = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error updating user data: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating profile. Please try again."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.deep_orange),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section
                  Container(
                    padding: EdgeInsets.only(
                      top: 50.h,
                      bottom: 30.h,
                      left: 20.w,
                      right: 20.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.deep_orange,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deep_orange.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Profile",
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isEditing = !_isEditing;
                                });
                              },
                              icon: Icon(
                                _isEditing ? Icons.close : Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50.r,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 47.r,
                                backgroundColor: Colors.grey[200],
                                child: Icon(
                                  Icons.person,
                                  size: 50.sp,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                            if (_isEditing)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 20.sp,
                                    color: AppColors.deep_orange,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        Text(
                          _nameController.text.isNotEmpty
                              ? _nameController.text
                              : "User Name",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _emailController.text,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Body Section
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        if (_isEditing) ...[
                          _buildTextField(
                            "Full Name",
                            _nameController,
                            Icons.person,
                          ),
                          SizedBox(height: 15.h),
                          _buildTextField(
                            "Phone Number",
                            _phoneController,
                            Icons.phone,
                          ),
                          SizedBox(height: 15.h),
                          _buildTextField(
                            "Age",
                            _ageController,
                            Icons.calendar_today,
                          ),
                          SizedBox(height: 25.h),
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: _updateUserData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.deep_orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          _buildInfoTile(
                            "Phone",
                            _phoneController.text,
                            Icons.phone,
                          ),
                          _buildInfoTile(
                            "Age",
                            _ageController.text,
                            Icons.calendar_today,
                          ),
                          SizedBox(height: 20.h),
                          _buildMenuTile(
                            "My Orders",
                            Icons.shopping_bag_outlined,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => MyOrders()),
                              );
                            },
                          ),
                          _buildMenuTile(
                            "Order Tracking",
                            Icons.local_shipping_outlined,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderTrackingScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuTile(
                            "Shipping Address",
                            Icons.location_on_outlined,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ShippingAddress(),
                                ),
                              );
                            },
                          ),
                          _buildMenuTile(
                            "My Coupons",
                            Icons.local_offer_outlined,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CouponsScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuTile(
                            "Notifications",
                            Icons.notifications_outlined,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NotificationsScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuTile(
                            "My Wallet",
                            Icons.account_balance_wallet_outlined,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WalletScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuTile("Loyalty Points", Icons.stars, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoyaltyScreen(),
                              ),
                            );
                          }),
                          _buildMenuTile("Gift Cards", Icons.card_giftcard, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GiftCardScreen(),
                              ),
                            );
                          }),
                          _buildMenuTile(
                            "Address Book",
                            Icons.location_city,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddressBookScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuTile(
                            "Compare Products",
                            Icons.compare_arrows,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductCompareScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuTile(
                            "Order Statistics",
                            Icons.bar_chart,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrderStatisticsScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuTile(
                            "Daily Deals",
                            Icons.local_fire_department,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DailyDealsScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuTile(
                            "Price Alerts",
                            Icons.notifications_active,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PriceAlertScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuTile("Live Chat", Icons.chat_bubble, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LiveChatScreen(),
                              ),
                            );
                          }),
                          _buildMenuTile(
                            "Help & Support",
                            Icons.help_outline,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SupportScreen(),
                                ),
                              );
                            },
                          ),
                          _buildMenuTile("Return/Refund", Icons.replay, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReturnRequestScreen(),
                              ),
                            );
                          }),
                          _buildMenuTile("Size Guide", Icons.straighten, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SizeGuideScreen(),
                              ),
                            );
                          }),
                          _buildMenuTile(
                            "Admin Panel",
                            Icons.admin_panel_settings_outlined,
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddProductScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: OutlinedButton.icon(
                              onPressed: () => _showLogoutDialog(),
                              icon: Icon(Icons.logout, color: Colors.red),
                              label: Text(
                                "Logout",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.deep_orange),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.deep_orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.deep_orange, size: 20.sp),
          ),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              ),
              Text(
                value.isNotEmpty ? value : "Not set",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(String title, IconData icon, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.black87, size: 20.sp),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 10.w),
            Text("Logout"),
          ],
        ),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
