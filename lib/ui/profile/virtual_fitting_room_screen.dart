import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/app_colors.dart';

class VirtualFittingRoomScreen extends StatefulWidget {
  const VirtualFittingRoomScreen({super.key});

  @override
  _VirtualFittingRoomScreenState createState() =>
      _VirtualFittingRoomScreenState();
}

class _VirtualFittingRoomScreenState extends State<VirtualFittingRoomScreen>
    with TickerProviderStateMixin {
  String? _selectedModel;
  String? _selectedOutfit;
  String _selectedSize = 'M';
  bool _isProcessing = false;

  final List<String> _models = [
    'assets/carousel/slider1.jpg',
    'assets/carousel/slider2.jpg',
    'assets/carousel/slider3.jpg',
  ];

  final List<Map<String, dynamic>> _outfits = [
    {
      'id': '1',
      'image': 'assets/products/product1.jpg',
      'name': 'Classic T-Shirt',
      'price': 1200,
      'type': 'shirt',
      'fit': 95,
      'sizes': ['S', 'M', 'L', 'XL'],
    },
    {
      'id': '2',
      'image': 'assets/products/product2.jpg',
      'name': 'Denim Jacket',
      'price': 3500,
      'type': 'jacket',
      'fit': 88,
      'sizes': ['M', 'L', 'XL'],
    },
    {
      'id': '3',
      'image': 'assets/products/product3.jpg',
      'name': 'Casual Pants',
      'price': 2500,
      'type': 'pants',
      'fit': 92,
      'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
    },
    {
      'id': '4',
      'image': 'assets/products/product4.jpg',
      'name': 'Sport Hoodie',
      'price': 2800,
      'type': 'hoodie',
      'fit': 90,
      'sizes': ['M', 'L', 'XL'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Virtual Fitting Room ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt, color: AppColors.deepOrange),
            onPressed: _capturePhoto,
          ),
        ],
      ),
      body: Column(
        children: [
          // Main Fitting Area
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF8F9FA), Colors.white],
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_selectedModel != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.asset(
                        _selectedModel!,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    )
                  else
                    _buildEmptyState(),

                  if (_isProcessing)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: AppColors.deepOrange,
                              strokeWidth: 3,
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "Processing AI Fitting...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Controls
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Choose Model",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.deepOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          "Size: $_selectedSize",
                          style: TextStyle(
                            color: AppColors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 60.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _models.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return GestureDetector(
                            onTap: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Upload photo feature coming soon!',
                                    ),
                                  ),
                                ),
                            child: Container(
                              width: 60.w,
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () => setState(
                            () => _selectedModel = _models[index - 1],
                          ),
                          child: Container(
                            width: 60.w,
                            margin: EdgeInsets.only(right: 10.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: _selectedModel == _models[index - 1]
                                  ? Border.all(
                                      color: AppColors.deepOrange,
                                      width: 2,
                                    )
                                  : null,
                              image: DecorationImage(
                                image: AssetImage(_models[index - 1]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Try On Clothes",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_selectedOutfit != null)
                        TextButton.icon(
                          onPressed: _showSizeSelector,
                          icon: Icon(Icons.straighten, size: 16.sp),
                          label: Text("Change Size"),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.deepOrange,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _outfits.length,
                      itemBuilder: (context, index) {
                        final item = _outfits[index];
                        final isSelected = _selectedOutfit == item['id'];
                        return GestureDetector(
                          onTap: () => _tryOnOutfit(item),
                          child: Container(
                            width: 100.w,
                            margin: EdgeInsets.only(right: 10.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.deepOrange.withOpacity(0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(10.r),
                              border: isSelected
                                  ? Border.all(color: AppColors.deepOrange)
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  item['image'],
                                  height: 50.h,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(height: 5.h),
                                Text(
                                  item['name'],
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.deepOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(30.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_add,
              size: 60.sp,
              color: Colors.grey.shade400,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "Select a model to start",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Choose from models below",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  void _capturePhoto() {
    if (_selectedModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a model first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12.w),
            Text('Photo saved to gallery! '),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  void _tryOnOutfit(Map<String, dynamic> item) async {
    if (_selectedModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a model first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() => _isProcessing = true);
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      _selectedOutfit = item['id'];
      _isProcessing = false;
    });
    _showFitAnalysis(item);
  }

  void _showSizeSelector() {
    if (_selectedOutfit == null) return;
    final outfit = _outfits.firstWhere((e) => e['id'] == _selectedOutfit);
    final sizes = outfit['sizes'] as List<String>;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Select Size',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            Wrap(
              spacing: 12.w,
              children: sizes.map((size) {
                final isSelected = size == _selectedSize;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedSize = size);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.deepOrange
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.deepOrange
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        size,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _showFitAnalysis(Map<String, dynamic> outfit) {
    final fitScore = outfit['fit'] as int;
    final color = fitScore >= 90
        ? Colors.green
        : fitScore >= 75
        ? Colors.orange
        : Colors.red;
    final message = fitScore >= 90
        ? 'Perfect Fit! This outfit matches your measurements excellently.'
        : fitScore >= 75
        ? 'Good Fit! This outfit should fit you well.'
        : 'Loose Fit. Consider trying a smaller size.';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Icon(Icons.analytics, color: color),
            SizedBox(width: 12.w),
            Text('Fit Analysis'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$fitScore%',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 16.h),
            Divider(),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recommended Size:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  _selectedSize,
                  style: TextStyle(
                    color: AppColors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fit Type:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  outfit['type'].toString().toUpperCase(),
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(' added to cart!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
