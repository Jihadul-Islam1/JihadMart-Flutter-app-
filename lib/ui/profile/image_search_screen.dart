import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jihad/utils/language_helper.dart';
import 'dart:io';

class ImageSearchScreen extends StatefulWidget {
  const ImageSearchScreen({super.key});

  @override
  _ImageSearchScreenState createState() => _ImageSearchScreenState();
}

class _ImageSearchScreenState extends State<ImageSearchScreen> {
  File? _image;
  final picker = ImagePicker();
  bool _isSearching = false;
  bool _isBangla = false;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final lang = await LanguageHelper.getLanguage();
    setState(() {
      _isBangla = LanguageHelper.isBangla(lang);
    });
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _startSearch();
      }
    });
  }

  void _startSearch() async {
    setState(() {
      _isSearching = true;
    });
    // Simulate API search delay
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _isSearching = false;
    });
  }

  final List<Map<String, dynamic>> _foundProducts = [
    {
      'image': 'assets/products/product1.jpg',
      'name': 'Nike Air Max',
      'price': 12000,
    },
    {
      'image': 'assets/products/product2.jpg',
      'name': 'Adidas Ultraboost',
      'price': 15000,
    },
    {
      'image': 'assets/products/product3.jpg',
      'name': 'Puma RS-X',
      'price': 9500,
    },
    {
      'image': 'assets/products/product4.jpg',
      'name': 'Reebok Classic',
      'price': 8000,
    },
    {
      'image': 'assets/products/product5.jpg',
      'name': 'New Balance 574',
      'price': 11000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera View / Image Preview
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: _image != null
                ? Image.file(_image!, fit: BoxFit.cover)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white54,
                        size: 100.sp,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        _isBangla
                            ? "সার্চ করতে ছবি তুলুন"
                            : "Take a photo to search",
                        style: TextStyle(color: Colors.white, fontSize: 18.sp),
                      ),
                    ],
                  ),
          ),

          // Overlay UI
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        _isBangla ? "ইমেজ সার্চ" : "Image Search",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.history, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                Spacer(),

                // Search Results (Sliding Sheet)
                if (_image != null && !_isSearching)
                  Container(
                    height: 300.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10.h),
                          width: 40.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Row(
                            children: [
                              Text(
                                _isBangla ? "অনুরূপ পণ্য" : "Similar Products",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "12 ${_isBangla ? 'পাওয়া গেছে' : 'found'}",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            itemCount: _foundProducts.length,
                            itemBuilder: (context, index) {
                              final product = _foundProducts[index];
                              return Container(
                                width: 150.w,
                                margin: EdgeInsets.only(
                                  right: 16.w,
                                  bottom: 16.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(color: Colors.grey[200]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.r),
                                          ),
                                          image: DecorationImage(
                                            image: AssetImage(product['image']),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            "৳${product['price']}",
                                            style: TextStyle(
                                              color: AppColors.deepOrange,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                // Controls
                if (_image == null)
                  Padding(
                    padding: EdgeInsets.only(bottom: 40.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.photo_library,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                          onPressed: () => getImage(ImageSource.gallery),
                        ),
                        GestureDetector(
                          onTap: () => getImage(ImageSource.camera),
                          child: Container(
                            width: 70.w,
                            height: 70.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.flash_on,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Loading Indicator
          if (_isSearching)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.deepOrange),
                    SizedBox(height: 20.h),
                    Text(
                      _isBangla
                          ? "ছবি বিশ্লেষণ করা হচ্ছে..."
                          : "Analyzing image...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
