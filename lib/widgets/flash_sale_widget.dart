import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlashSaleWidget extends StatefulWidget {
  final DateTime endTime;
  final List<Map<String, dynamic>> products;
  final Function(Map<String, dynamic>)? onProductTap;

  FlashSaleWidget({
    required this.endTime,
    required this.products,
    this.onProductTap,
  });

  @override
  _FlashSaleWidgetState createState() => _FlashSaleWidgetState();
}

class _FlashSaleWidgetState extends State<FlashSaleWidget> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _calculateTimeLeft());
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    setState(() {
      _timeLeft = widget.endTime.difference(now);
      if (_timeLeft.isNegative) {
        _timeLeft = Duration.zero;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (_timeLeft == Duration.zero || widget.products.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[700]!, Colors.orange[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with timer
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Row(
              children: [
                Icon(Icons.flash_on, color: Colors.yellow, size: 28.sp),
                SizedBox(width: 8.w),
                Text(
                  "⚡ ফ্ল্যাশ সেল",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timer, color: Colors.white, size: 16.sp),
                      SizedBox(width: 5.w),
                      Text(
                        _formatDuration(_timeLeft),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Products horizontal scroll
          SizedBox(
            height: 180.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                return _buildFlashSaleProduct(widget.products[index]);
              },
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildFlashSaleProduct(Map<String, dynamic> product) {
    double originalPrice =
        product["original-price"] ?? product["product-price"];
    double salePrice = product["sale-price"] ?? originalPrice * 0.7;
    int discountPercent = ((1 - salePrice / originalPrice) * 100).round();

    return GestureDetector(
      onTap: () => widget.onProductTap?.call(product),
      child: Container(
        width: 130.w,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image with discount badge
            Stack(
              children: [
                Container(
                  height: 90.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child:
                        product["product-img"] != null &&
                            (product["product-img"] as List).isNotEmpty
                        ? Image.asset(
                            product["product-img"][0],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Icons.shopping_bag,
                              size: 40.sp,
                              color: Colors.grey[400],
                            ),
                          )
                        : Icon(
                            Icons.shopping_bag,
                            size: 40.sp,
                            color: Colors.grey[400],
                          ),
                  ),
                ),
                Positioned(
                  top: 5,
                  left: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "-$discountPercent%",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Product info
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product["product-name"] ?? "Product",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Text(
                        "৳${salePrice.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        "৳${originalPrice.toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  // Stock progress
                  LinearProgressIndicator(
                    value: 0.3 + (0.5 * (1 - (product.hashCode % 10) / 10)),
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(Colors.orange),
                    minHeight: 4,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    "সীমিত স্টক!",
                    style: TextStyle(fontSize: 9.sp, color: Colors.orange[700]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class to generate flash sale data
class FlashSaleHelper {
  static DateTime getNextFlashSaleEndTime() {
    // Flash sale ends at next 6 hours mark
    final now = DateTime.now();
    final hours = (now.hour ~/ 6 + 1) * 6;
    return DateTime(now.year, now.month, now.day, hours);
  }

  static List<Map<String, dynamic>> getDemoFlashSaleProducts() {
    return [
      {
        "product-name": "Nike Air Max",
        "product-description":
            "Comfortable running shoes with latest Air Max technology. Perfect for daily wear and sports.",
        "product-price": 12000.0,
        "original-price": 15000.0,
        "sale-price": 9000.0,
        "product-img": ["assets/products/product1.jpg"],
      },
      {
        "product-name": "Adidas Ultra",
        "product-description":
            "Premium Ultraboost running shoes for professional athletes. Maximum comfort and performance.",
        "product-price": 18000.0,
        "original-price": 22000.0,
        "sale-price": 11000.0,
        "product-img": ["assets/products/product2.jpg"],
      },
      {
        "product-name": "Puma RS-X",
        "product-description":
            "Casual sports shoes with modern retro design. Lightweight and stylish for everyday use.",
        "product-price": 9000.0,
        "original-price": 12000.0,
        "sale-price": 6000.0,
        "product-img": ["assets/products/product3.jpg"],
      },
      {
        "product-name": "Reebok Classic",
        "product-description":
            "Vintage style classic shoes for everyday wear. Timeless design with modern comfort.",
        "product-price": 7500.0,
        "original-price": 10000.0,
        "sale-price": 5000.0,
        "product-img": ["assets/products/product4.jpg"],
      },
    ];
  }
}
