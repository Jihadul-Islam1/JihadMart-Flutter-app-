import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sslcommerz/model/SSLCCustomerInfoInitializer.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:jihad/core/config/app_config.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/utils/cart_service.dart';
import 'package:jihad/core/services/order_repository.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double subtotalAmount;
  final double shippingAmount;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final String shippingAddress;

  const PaymentScreen({
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
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentMethod =
      0; // 0: Card, 1: Bkash, 2: Nagad, 3: Rocket, 4: COD
  final _formKey = GlobalKey<FormState>();
  final OrderRepository _orderRepository = OrderRepository();
  bool _isPaymentInProgress = false;

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
                    _buildSummaryRow("Subtotal", "৳${widget.subtotalAmount}"),
                    SizedBox(height: 10.h),
                    _buildSummaryRow(
                      "Shipping",
                      "৳${widget.shippingAmount}",
                    ),
                    SizedBox(height: 10.h),
                    _buildSummaryRow("Tax", "৳${widget.taxAmount}"),
                    if (widget.discountAmount > 0) ...[
                      SizedBox(height: 10.h),
                      _buildSummaryRow(
                        "Discount",
                        "-৳${widget.discountAmount.toStringAsFixed(0)}",
                      ),
                    ],
                    Divider(height: 30.h),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "Confirm Payment",
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
            Icon(Icons.info_outline, color: AppColors.deepOrange),
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
        prefixIcon: Icon(icon, color: AppColors.deepOrange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.deepOrange, width: 2),
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
            color: isSelected ? AppColors.deepOrange : Colors.transparent,
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
                color: isSelected ? AppColors.deepOrange : Colors.grey,
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
              Icon(Icons.check_circle, color: AppColors.deepOrange),
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

  void _placeOrder() {
    if (_isPaymentInProgress) {
      return;
    }

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

    if (_selectedPaymentMethod == 4) {
      _showProcessingDialog();
      _placeOrderWithRepository(
        paymentMethodName,
        paymentStatus: 'cod_pending',
      );
      return;
    }

    _payWithSslCommerz(paymentMethodName);
  }

  Future<void> _payWithSslCommerz(String paymentMethodName) async {
    final storeId = AppConfig.sslStoreId;
    final storePassword = AppConfig.sslStorePassword;

    if (storeId.isEmpty || storePassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'SSLCommerz credentials missing. Set SSLCOMMERZ_STORE_ID and SSLCOMMERZ_STORE_PASSWORD.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    final customerName = (user?.displayName?.trim().isNotEmpty ?? false)
        ? user!.displayName!.trim()
        : 'Customer';
    final customerEmail = user?.email?.trim().toLowerCase() ?? 'customer@example.com';
    final mobile = _mobileNumberController.text.trim().isNotEmpty
        ? _mobileNumberController.text.trim()
        : '01700000000';
    final tranId = 'JIHAD_${DateTime.now().millisecondsSinceEpoch}';

    setState(() {
      _isPaymentInProgress = true;
    });

    _showProcessingDialog();

    try {
      final sslcz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          store_id: storeId,
          store_passwd: storePassword,
          total_amount: widget.totalAmount,
          currency: SSLCurrencyType.BDT,
          tran_id: tranId,
          product_category: 'Ecommerce',
          sdkType: AppConfig.sslSandboxMode ? SSLCSdkType.TESTBOX : SSLCSdkType.LIVE,
        ),
      ).addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
          customerName: customerName,
          customerEmail: customerEmail,
          customerAddress1: widget.shippingAddress,
          customerCity: 'Dhaka',
          customerState: 'Dhaka',
          customerPostCode: '1207',
          customerCountry: 'Bangladesh',
          customerPhone: mobile,
        ),
      );

      final SSLCTransactionInfoModel result = await sslcz.payNow();
      if (!mounted) {
        return;
      }

      Navigator.pop(context);

      final status = (result.status ?? '').trim();
      final isSuccess = _isSuccessfulStatus(status);
      if (!isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed or cancelled. Status: ${status.isEmpty ? 'unknown' : status}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      _showProcessingDialog();
      await _placeOrderWithRepository(
        paymentMethodName,
        paymentStatus: 'paid',
        paymentGateway: 'sslcommerz',
        paymentTransactionId: result.tranId ?? tranId,
        paymentValidationId: result.valId,
        paymentBankTransactionId: result.bankTranId,
        paymentRaw: result.toJson(),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPaymentInProgress = false;
        });
      }
    }
  }

  bool _isSuccessfulStatus(String status) {
    final normalized = status.toUpperCase();
    return normalized == 'VALID'
        || normalized == 'VALIDATED'
        || normalized == 'SUCCESS'
        || normalized == 'SUCCESSFUL';
  }

  void _showProcessingDialog() {
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
              CircularProgressIndicator(color: AppColors.deepOrange),
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

  }

  Future<void> _placeOrderWithRepository(
    String paymentMethodName, {
    String paymentStatus = 'pending',
    String? paymentGateway,
    String? paymentTransactionId,
    String? paymentValidationId,
    String? paymentBankTransactionId,
    Map<String, dynamic>? paymentRaw,
  }) async {
    try {
      await _orderRepository.createOrder(
        items: widget.cartItems,
        subtotalAmount: widget.subtotalAmount,
        shippingAmount: widget.shippingAmount,
        taxAmount: widget.taxAmount,
        discountAmount: widget.discountAmount,
        totalAmount: widget.totalAmount,
        shippingAddress: widget.shippingAddress,
        paymentMethod: paymentMethodName,
        paymentStatus: paymentStatus,
        paymentGateway: paymentGateway,
        paymentTransactionId: paymentTransactionId,
        paymentValidationId: paymentValidationId,
        paymentBankTransactionId: paymentBankTransactionId,
        paymentRaw: paymentRaw,
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(context);
      CartService.clearCart();

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
                "Thank you for your purchase.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepOrange,
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("Continue Shopping"),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to place order. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
