import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/AppColors.dart';
import '../product_details_screen.dart';
import '../search_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
// Home.dart file এ _carouselImages list টি খুঁজে এই data দিয়ে replace করো:

List<String> _carouselImages = [
  "assets/carousel/slider1.jpg",
  "assets/carousel/slider2.jpg", 
  "assets/carousel/slider3.jpg",
];
  
  var _dotPosition = 0;
  
  // Home.dart file এর ভিতরে _products list টি খুঁজে এই data দিয়ে replace করো:

List _products = [
  {
    "product-name": "Nike Air Max",
    "product-description": "Comfortable running shoes with latest technology",
    "product-price": 120.00,
    "product-img": ["assets/products/product1.jpg"],
  },
  {
    "product-name": "Adidas Ultraboost", 
    "product-description": "Premium running shoes for professional athletes",
    "product-price": 180.00,
    "product-img": ["assets/products/product2.jpg"],
  },
  {
    "product-name": "Puma RS-X",
    "product-description": "Casual sports shoes with modern design",
    "product-price": 90.00,
    "product-img": ["assets/products/product3.jpg"],
  },
  {
    "product-name": "Reebok Classic",
    "product-description": "Vintage style shoes for everyday wear",
    "product-price": 75.00,
    "product-img": ["assets/products/product4.jpg"],
  },
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    hintText: "Search products here",
                    hintStyle: TextStyle(fontSize: 15.sp),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => SearchScreen()),
                  ),
                ),
              ),
              
              SizedBox(height: 10.h),
              
              // Carousel Slider - এখানে পরিবর্তন করেছি
              AspectRatio(
                aspectRatio: 3.0, // aspect ratio একটু কমালাম
                child: CarouselSlider(
                  items: _carouselImages
                      .map((item) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                item,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ))
                      .toList(),
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true, // এইটা true থাকতে হবে
                    viewportFraction: 0.7, // Current slide 70% জুড়ে থাকবে
                    enlargeFactor: 0.2, // Current slide 20% বড় দেখাবে
                    aspectRatio: 16/9,
                    onPageChanged: (val, carouselPageChangedReason) {
                      setState(() {
                        _dotPosition = val;
                      });
                    },
                  ),
                ),
              ),
              
              SizedBox(height: 10.h),
              
              // Dots Indicator
              DotsIndicator(
                dotsCount: _carouselImages.length,
                position: _dotPosition.toDouble(),
                decorator: DotsDecorator(
                  activeColor: AppColors.deep_orange,
                  color: AppColors.deep_orange.withOpacity(0.3),
                  spacing: EdgeInsets.all(3),
                  activeSize: Size(12, 12),
                  size: Size(8, 8),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              
              SizedBox(height: 15.h),
              
              // Section Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Featured Products",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "See All",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 10.h),
              
              // Products Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  scrollDirection: Axis.vertical,
                  itemCount: _products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetails(_products[index]),
                        ),
                      ),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Image
                            Container(
                              height: 120.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(_products[index]["product-img"][0]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 8.h),
                            
                            // Product Name
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Text(
                                "${_products[index]["product-name"]}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            
                            SizedBox(height: 4.h),
                            
                            // Product Description
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Text(
                                "${_products[index]["product-description"]}",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            
                            Spacer(),
                            
                            // Product Price
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              child: Text(
                                "\$${_products[index]["product-price"].toString()}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.deep_orange,
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 8.h),
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
    );
  }
}