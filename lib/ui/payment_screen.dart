import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:jihad/utils/cart_service.dart';
import 'package:jihad/utils/order_service.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  const PaymentScreen({
    Key? key,
    required this.cartItems,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentMethod =
      0; // 0: Card, 1: Bkash, 2: Nagad, 3: Rocket, 4: COD
  final _formKey = GlobalKey<FormState>();

  // Card Controllers
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderNameController =
      TextEditingController();

  // Mobile Banking Controllers
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _transactionIdController =
      TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _cardHolderNameController.dispose();
    _mobileNumberController.dispose();
    _transactionIdController.dispose();
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
          "Payment",
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payment Method Section
              Text(
                "Choose Payment Method",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              _buildPaymentOption(
                0,
                "Credit/Debit Card",
                imagePath: "assets/logo/card.png",
              ),
              SizedBox(height: 10.h),
              _buildPaymentOption(
                1,
                "Bkash",
                imagePath: "assets/logo/bkash.png",
              ),
              SizedBox(height: 10.h),
              _buildPaymentOption(
                2,
                "Nagad",
                imagePath: "assets/logo/nagad.png",
              ),
              SizedBox(height: 10.h),
              _buildPaymentOption(
                3,
                "Rocket",
                imagePath: "assets/logo/rocket.png",
              ),
              SizedBox(height: 10.h),
              _buildPaymentOption(4, "Cash on Delivery", icon: Icons.money),

              SizedBox(height: 25.h),

              // Dynamic Payment Form
              _buildPaymentForm(),

              SizedBox(height: 25.h),

              // Order Summary
              Text(
                "Total Amount",
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
                      "Total to Pay",
                      "৳${widget.totalAmount}",
                      isTotal: true,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30.h),

              // Confirm Payment Button
              SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  child: Text(
                    "Confirm Payment",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deep_orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    if (_selectedPaymentMethod == 0) {
      // Card Payment Form
      return Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Card Details",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.h),
            _buildTextField(
              "Card Number",
              _cardNumberController,
              Icons.credit_card,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "Expiry Date",
                    _expiryDateController,
                    Icons.calendar_today,
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: _buildTextField(
                    "CVV",
                    _cvvController,
                    Icons.lock,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            _buildTextField(
              "Card Holder Name",
              _cardHolderNameController,
              Icons.person,
            ),
          ],
        ),
      );
    } else if (_selectedPaymentMethod >= 1 && _selectedPaymentMethod <= 3) {
      // Mobile Banking Form (Bkash, Nagad, Rocket)
      String providerName = _selectedPaymentMethod == 1
          ? "Bkash"
          : (_selectedPaymentMethod == 2 ? "Nagad" : "Rocket");
      return Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$providerName Details",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15.h),
            _buildTextField(
              "Mobile Number",
              _mobileNumberController,
              Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 15.h),
            // In a real app, this might be a PIN or OTP field, or just a confirmation
            Text(
              "You will be redirected to the $providerName gateway to complete the payment.",
              style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
            ),
          ],
        ),
      );
    } else {
      // Cash on Delivery
      return Container(
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
            Icon(Icons.info_outline, color: AppColors.deep_orange),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                "Pay with cash upon delivery.",
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $label";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.deep_orange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.deep_orange, width: 2),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    int value,
    String title, {
    String? imagePath,
    IconData? icon,
  }) {
    bool isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.deep_orange : Colors.transparent,
            width: 2,
          ),
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
            if (imagePath != null)
              Image.asset(
                imagePath,
                width: 50.w,
                height: 30.h,
                fit: BoxFit.contain,
              )
            else
              Icon(
                icon ?? Icons.payment,
                color: isSelected ? AppColors.deep_orange : Colors.grey,
                size: 30.sp,
              ),
            SizedBox(width: 15.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.black : Colors.grey[600],
              ),
            ),
            Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.deep_orange),
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
            color: isTotal ? AppColors.deep_orange : Colors.black87,
          ),
        ),
      ],
    );
  }

  void _placeOrder() {
    if (_selectedPaymentMethod != 4) {
      // If not Cash on Delivery
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    // Get payment method name
    String paymentMethodName = "";
    switch (_selectedPaymentMethod) {
      case 0:
        paymentMethodName = "Credit/Debit Card";
        break;
      case 1:
        paymentMethodName = "Bkash";
        break;
      case 2:
        paymentMethodName = "Nagad";
        break;
      case 3:
        paymentMethodName = "Rocket";
        break;
      case 4:
        paymentMethodName = "Cash on Delivery";
        break;
    }

    // Simulate order placement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.deep_orange),
              SizedBox(height: 20.h),
              Text(
                "Processing Payment...",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    String orderId =
        "#OD${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";
    String orderDate =
        "${DateTime.now().day} ${_getMonthName(DateTime.now().month)}, ${DateTime.now().year}";

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog

      // Save order to OrderService
      OrderService().placeOrder({
        'orderId': orderId,
        'date': orderDate,
        'status': 'Processing',
        'total': widget.totalAmount,
        'paymentMethod': paymentMethodName,
        'items': widget.cartItems,
      });

      CartService.clearCart(); // Clear the cart

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60.sp),
              SizedBox(height: 20.h),
              Text(
                "Order Placed Successfully!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Text(
                "Thank you for your purchase.\nYour order ID is $orderId",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close success dialog
                  Navigator.of(
                    context,
                  ).popUntil((route) => route.isFirst); // Go back to Home
                },
                child: Text("Continue Shopping"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deep_orange,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _getMonthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }
}
