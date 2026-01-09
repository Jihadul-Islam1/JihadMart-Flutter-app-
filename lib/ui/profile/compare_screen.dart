import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/compare_service.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  @override
  Widget build(BuildContext context) {
    final comparedItems = CompareService.getCompareList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('প্রোডাক্ট তুলনা 📊'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          if (comparedItems.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  CompareService.clearCompare();
                });
              },
              icon: const Icon(Icons.clear_all, color: Colors.white),
              label: const Text('মুছুন', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: comparedItems.isEmpty
          ? _buildEmptyState()
          : _buildCompareContent(comparedItems),
    );
  }

  Widget _buildEmptyState() {
    final suggestions = CompareService.getComparisonSuggestions();

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          Icon(Icons.compare_arrows, size: 80.sp, color: Colors.grey.shade300),
          SizedBox(height: 16.h),
          Text(
            'তুলনা করতে প্রোডাক্ট যোগ করুন',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'সর্বোচ্চ ৪টি প্রোডাক্ট তুলনা করা যাবে',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          SizedBox(height: 40.h),

          // Suggestions
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'জনপ্রিয় তুলনা',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 16.h),
          ...suggestions.map((suggestion) => _buildSuggestionCard(suggestion)),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(Map<String, dynamic> suggestion) {
    final items = suggestion['items'] as List<String>;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.compare, color: Colors.teal, size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion['category'] as String,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  items.join(' vs '),
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Add demo products to compare
              setState(() {
                CompareService.addDemoComparison();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('দেখুন'),
          ),
        ],
      ),
    );
  }

  Widget _buildCompareContent(List<Map<String, dynamic>> products) {
    final specs = [
      'মূল্য',
      'রেটিং',
      'ব্র্যান্ড',
      'স্টোরেজ',
      'র‍্যাম',
      'ব্যাটারি',
      'ক্যামেরা',
      'ওয়ারেন্টি',
    ];

    return Column(
      children: [
        // Product Headers
        Container(
          height: 180.h,
          color: Colors.white,
          child: Row(
            children: [
              // Specs Label
              SizedBox(
                width: 80.w,
                child: Center(
                  child: Text(
                    'তুলনা',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                ),
              ),
              // Products
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return _buildProductHeader(products[index]);
                  },
                ),
              ),
            ],
          ),
        ),

        Divider(height: 1, color: Colors.grey.shade300),

        // Specs Comparison
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: specs.map((spec) {
                return _buildSpecRow(spec, products);
              }).toList(),
            ),
          ),
        ),

        // Bottom Actions
        Container(
          padding: EdgeInsets.all(16.w),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showAddProductSheet(),
                  icon: const Icon(Icons.add),
                  label: const Text('প্রোডাক্ট যোগ করুন'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductHeader(Map<String, dynamic> product) {
    return Container(
      width: 140.w,
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: [
          // Remove Button
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  CompareService.removeFromCompare(product['id'] as String);
                });
              },
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 16.sp),
              ),
            ),
          ),
          // Product Image
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(Icons.smartphone, size: 30.sp, color: Colors.grey),
          ),
          SizedBox(height: 8.h),
          Text(
            product['name'] as String,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            '৳${(product['price'] as double).toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String spec, List<Map<String, dynamic>> products) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          // Spec Label
          Container(
            width: 80.w,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
            color: Colors.grey.shade50,
            child: Text(
              spec,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
            ),
          ),
          // Values
          Expanded(
            child: Row(
              children: products.map((product) {
                final value = _getSpecValue(spec, product);
                final isBest = _isBestValue(spec, value, products);
                return Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 8.w,
                    ),
                    color: isBest ? Colors.teal.shade50 : Colors.white,
                    child: Column(
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: isBest
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isBest ? Colors.teal : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (isBest)
                          Icon(
                            Icons.check_circle,
                            size: 14.sp,
                            color: Colors.teal,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getSpecValue(String spec, Map<String, dynamic> product) {
    final specs = product['specs'] as Map<String, String>? ?? {};
    switch (spec) {
      case 'মূল্য':
        return '৳${(product['price'] as double).toStringAsFixed(0)}';
      case 'রেটিং':
        return '${product['rating']} ⭐';
      case 'ব্র্যান্ড':
        return specs['brand'] ?? '-';
      case 'স্টোরেজ':
        return specs['storage'] ?? '-';
      case 'র‍্যাম':
        return specs['ram'] ?? '-';
      case 'ব্যাটারি':
        return specs['battery'] ?? '-';
      case 'ক্যামেরা':
        return specs['camera'] ?? '-';
      case 'ওয়ারেন্টি':
        return specs['warranty'] ?? '-';
      default:
        return '-';
    }
  }

  bool _isBestValue(
    String spec,
    String value,
    List<Map<String, dynamic>> products,
  ) {
    if (spec == 'মূল্য') {
      // Lowest price is best
      final prices = products.map((p) => p['price'] as double).toList();
      final minPrice = prices.reduce((a, b) => a < b ? a : b);
      return value.contains(minPrice.toStringAsFixed(0));
    } else if (spec == 'রেটিং') {
      // Highest rating is best
      final ratings = products.map((p) => p['rating'] as double).toList();
      final maxRating = ratings.reduce((a, b) => a > b ? a : b);
      return value.contains(maxRating.toString());
    }
    return false;
  }

  void _showAddProductSheet() {
    final availableProducts = [
      {'id': 'p3', 'name': 'Samsung Galaxy S24', 'price': 89999.0},
      {'id': 'p4', 'name': 'Xiaomi 14', 'price': 69999.0},
      {'id': 'p5', 'name': 'OnePlus 12', 'price': 79999.0},
      {'id': 'p6', 'name': 'Google Pixel 8', 'price': 85999.0},
    ];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'প্রোডাক্ট যোগ করুন',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              ...availableProducts.map((product) {
                final isAdded = CompareService.isInCompare(
                  product['id'] as String,
                );
                return ListTile(
                  leading: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const Icon(Icons.smartphone),
                  ),
                  title: Text(product['name'] as String),
                  subtitle: Text(
                    '৳${(product['price'] as double).toStringAsFixed(0)}',
                  ),
                  trailing: IconButton(
                    onPressed: isAdded
                        ? null
                        : () {
                            setState(() {
                              CompareService.addToCompare(product);
                            });
                            Navigator.pop(context);
                          },
                    icon: Icon(
                      isAdded ? Icons.check_circle : Icons.add_circle_outline,
                      color: isAdded ? Colors.green : Colors.teal,
                    ),
                  ),
                );
              }),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }
}
