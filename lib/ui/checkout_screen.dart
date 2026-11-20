import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/ui/profile/shipping_address.dart';
import 'package:jihad/ui/payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double subtotalAmount;
  final double shippingAmount;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final String shippingAddress;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.subtotalAmount,
    required this.shippingAmount,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.shippingAddress,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late String _shippingAddress;
  final TextEditingController _promoController = TextEditingController();
  double _discount = 0;
  String _appliedPromo = '';

  final Map<String, double> _promoCodes = {
    'WELCOME50': 50,
    'SAVE100': 100,
    'FLASH20': 0.20, // 20% off
    'FREESHIP': 10, // Free shipping
  };

  @override
  void initState() {
    super.initState();
    _shippingAddress = widget.shippingAddress;
    _discount = widget.discountAmount;
  }

  void _applyPromoCode() {
    final code = _promoController.text.toUpperCase().trim();
    if (_promoCodes.containsKey(code)) {
      setState(() {
        if (code == 'FLASH20') {
          _discount = widget.subtotalAmount * _promoCodes[code]!;
        } else {
          _discount = _promoCodes[code]!;
        }
        _appliedPromo = code;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Promo code applied! You saved ৳${_discount.toStringAsFixed(0)}",
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid promo code"),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          "Checkout",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Section
            Text(
              "Delivery Address",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(15),
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
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.deepOrange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.deepOrange,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Home",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                        Text(
                          _shippingAddress,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ShippingAddress()),
                      );
                      if (result != null) {
                        setState(() {
                          _shippingAddress = result.toString();
                        });
                      }
                    },
                    child: Text(
                      "Change",
                      style: TextStyle(color: AppColors.deepOrange),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 25.h),

            // Promo Code Section
            Text(
              "Promo Code",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(15),
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
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promoController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: "Enter promo code",
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.local_offer,
                          color: AppColors.deepOrange,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _appliedPromo.isEmpty ? _applyPromoCode : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _appliedPromo.isEmpty
                          ? AppColors.deepOrange
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(_appliedPromo.isEmpty ? "Apply" : "Applied",  style: TextStyle( color: _appliedPromo.isEmpty ? Colors.white  : Colors.black,),),          
                  ),
                ],
              ),
            ),
            if (_appliedPromo.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16.sp),
                    SizedBox(width: 5.w),
                    Text(
                      "Code '$_appliedPromo' applied - ৳${_discount.toStringAsFixed(0)} off",
                      style: TextStyle(color: Colors.green, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 25.h),

            // Order Summary
            Text(
              "Order Summary",
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(15),
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
                  _buildSummaryRow(
                    "Subtotal",
                    "৳${widget.subtotalAmount.toStringAsFixed(0)}",
                  ),
                  SizedBox(height: 10.h),
                  _buildSummaryRow(
                    "Shipping",
                    "৳${widget.shippingAmount.toStringAsFixed(0)}",
                  ),
                  SizedBox(height: 10.h),
                  _buildSummaryRow(
                    "Tax",
                    "৳${widget.taxAmount.toStringAsFixed(0)}",
                  ),
                  if (_discount > 0) ...[
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Discount",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          "-৳${_discount.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                  Divider(height: 30.h),
                  _buildSummaryRow(
                    "Total",
                    "৳${(widget.totalAmount - _discount).toStringAsFixed(0)}",
                    isTotal: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            // Proceed to Payment Button
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(
                        cartItems: widget.cartItems,
                        subtotalAmount: widget.subtotalAmount,
                        shippingAmount: widget.shippingAmount,
                        taxAmount: widget.taxAmount,
                        discountAmount: _discount,
                        totalAmount: widget.totalAmount - _discount,
                        shippingAddress: _shippingAddress,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "Proceed to Payment",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.bold,
            color: isTotal ? AppColors.deepOrange : Colors.black87,
          ),
        ),
      ],
    );
  }
}
