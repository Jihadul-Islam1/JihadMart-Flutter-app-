import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:jihad/ui/profile/my_orders.dart';
import 'package:jihad/ui/settings_screen.dart';
import 'package:jihad/ui/support_screen.dart';
import 'package:jihad/ui/bottom_nav_pages/favourite.dart';
import 'package:jihad/utils/recently_viewed_service.dart';
import 'package:jihad/widgets/flash_sale_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jihad/ui/profile/voice_search_screen.dart';
import 'package:jihad/ui/profile/image_search_screen.dart';
import 'package:jihad/ui/profile/all_features_screen.dart';
import 'package:jihad/utils/app_features.dart';
import '../product_details_screen.dart';
import '../search_screen.dart';
import 'package:jihad/ui/login_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<String> _carouselImages = [
    "assets/carousel/slider1.jpg",
    "assets/carousel/slider2.jpg",
    "assets/carousel/slider3.jpg",
    "assets/carousel/slider4.jpg",
    "assets/carousel/slider5.jpg",
    "assets/carousel/slider6.jpg",
  ];

  final List<Map<String, dynamic>> _localProducts = [
    {
      "product-name": "Wireless Headphones",
      "product-price": 2500,
      "product-img": ["assets/products/product1.jpg"],
      "product-description":
          "High quality wireless headphones with noise cancellation.",
    },
    {
      "product-name": "Smart Watch Series 7",
      "product-price": 5500,
      "product-img": ["assets/products/product2.jpg"],
      "product-description":
          "Advanced smartwatch with health tracking features.",
    },
    {
      "product-name": "Running Shoes",
      "product-price": 3200,
      "product-img": ["assets/products/product3.jpg"],
      "product-description": "Comfortable running shoes for daily use.",
    },
    {
      "product-name": "Leather Backpack",
      "product-price": 4500,
      "product-img": ["assets/products/product4.jpg"],
      "product-description":
          "Premium leather backpack with laptop compartment.",
    },
    {
      "product-name": "Digital Camera",
      "product-price": 25000,
      "product-img": ["assets/products/product5.jpg"],
      "product-description":
          "Professional digital camera for photography enthusiasts.",
    },
    {
      "product-name": "Gaming Mouse",
      "product-price": 1500,
      "product-img": ["assets/products/product6.jpg"],
      "product-description": "High precision gaming mouse with RGB lighting.",
    },
    {
      "product-name": "Mechanical Keyboard",
      "product-price": 3500,
      "product-img": ["assets/products/product7.jpg"],
      "product-description": "Mechanical keyboard with blue switches.",
    },
    {
      "product-name": "Sunglasses",
      "product-price": 1200,
      "product-img": ["assets/products/product8.jpg"],
      "product-description": "Stylish sunglasses with UV protection.",
    },
  ];

  var _dotPosition = 0;

  @override
  void initState() {
    super.initState();
    _loadQuickAccessData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: AppColors.deep_orange),
              accountName: Text(
                "Jihad Islam",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text("jihad@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "J",
                  style: TextStyle(
                    fontSize: 40.sp,
                    color: AppColors.deep_orange,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: AppColors.deep_orange),
              title: Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag, color: AppColors.deep_orange),
              title: Text("My Orders"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => MyOrders()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: AppColors.deep_orange),
              title: Text("Wishlist"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => Favourite()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: AppColors.deep_orange),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => SettingsScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.help, color: AppColors.deep_orange),
              title: Text("Help & Support"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => SupportScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.deep_orange),
              title: Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "E-",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
              TextSpan(
                text: "Commerce",
                style: TextStyle(
                  color: AppColors.deep_orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Simulate refresh
            await Future.delayed(Duration(seconds: 2));
            setState(() {});
          },
          color: AppColors.deep_orange,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      readOnly: true,
                      onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => SearchScreen()),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search products...",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.deep_orange,
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.mic, color: Colors.grey),
                              onPressed: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => VoiceSearchScreen(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.camera_alt, color: Colors.grey),
                              onPressed: () => Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => ImageSearchScreen(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 15.h,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Story Highlights
                _buildStoryHighlights(),

                SizedBox(height: 20.h),

                // Quick Access Buttons
                _buildQuickAccessButtons(),

                SizedBox(height: 20.h),

                // Categories
                _buildCategoriesSection(),

                SizedBox(height: 20.h),

                // More Features Section
                _buildMoreFeaturesSection(),

                SizedBox(height: 20.h),

                // Carousel
                AspectRatio(
                  aspectRatio: 2.5,
                  child: CarouselSlider(
                    items: _carouselImages
                        .map(
                          (item) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              image: DecorationImage(
                                image: AssetImage(item),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.85,
                      onPageChanged: (val, carouselReason) {
                        setState(() {
                          _dotPosition = val;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Center(
                  child: DotsIndicator(
                    dotsCount: _carouselImages.isEmpty
                        ? 1
                        : _carouselImages.length,
                    position: _dotPosition.toDouble(),
                    decorator: DotsDecorator(
                      activeColor: AppColors.deep_orange,
                      color: AppColors.deep_orange.withValues(alpha: 0.3),
                      spacing: EdgeInsets.all(2),
                      activeSize: Size(8, 8),
                      size: Size(6, 6),
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Special Offer Banner
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.deep_orange, Colors.orangeAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deep_orange.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Flash Sale!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                "Ends in: 05h 30m 20s",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                "Get up to 50% off",
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  "Shop Now",
                                  style: TextStyle(
                                    color: AppColors.deep_orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.timer, color: Colors.white, size: 60.sp),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                // Flash Sale Section
                FlashSaleWidget(
                  endTime: FlashSaleHelper.getNextFlashSaleEndTime(),
                  products: FlashSaleHelper.getDemoFlashSaleProducts(),
                  onProductTap: (product) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetails(product),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20.h),

                // Recently Viewed
                if (RecentlyViewedService.getRecentlyViewed().isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recently Viewed",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              RecentlyViewedService.clearAll();
                            });
                          },
                          child: Text(
                            "Clear All",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.deep_orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 120.h,
                    child: ListView.builder(
                      padding: EdgeInsets.only(left: 20.w),
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          RecentlyViewedService.getRecentlyViewed().length,
                      itemBuilder: (context, index) {
                        var product =
                            RecentlyViewedService.getRecentlyViewed()[index];

                        // Handle image
                        var imageList = product["product-img"];
                        String imagePath =
                            (imageList is List && imageList.isNotEmpty)
                            ? imageList[0]
                            : "";
                        bool isNetworkImage = imagePath.startsWith('http');

                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => ProductDetails(product),
                            ),
                          ),
                          child: Container(
                            width: 100.w,
                            margin: EdgeInsets.only(right: 12.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12.r),
                                      ),
                                      image: DecorationImage(
                                        image: isNetworkImage
                                            ? NetworkImage(imagePath)
                                            : AssetImage(imagePath)
                                                  as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.w),
                                  child: Text(
                                    "৳${product["product-price"]}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                      color: AppColors.deep_orange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],

                // Top Brands
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    "Top Brands",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 20.w),
                  child: Row(
                    children: [
                      _buildBrandItem("Nike", "assets/logo/nike.png"),
                      _buildBrandItem("Adidas", "assets/logo/adidas.png"),
                      _buildBrandItem("Puma", "assets/logo/puma.png"),
                      _buildBrandItem("Apple", "assets/logo/apple.png"),
                      _buildBrandItem("Samsung", "assets/logo/samsung.png"),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Rewards Banner
                _buildRewardsBanner(),

                SizedBox(height: 20.h),

                // Trending Now Section
                _buildTrendingSection(),

                SizedBox(height: 20.h),

                // New Arrivals
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "New Arrivals",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.deep_orange,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 180.h,
                  child: ListView.builder(
                    padding: EdgeInsets.only(left: 20.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: _localProducts.length,
                    itemBuilder: (context, index) {
                      var product = _localProducts[index];

                      // Handle image
                      var imageList = product["product-img"];
                      String imagePath =
                          (imageList is List && imageList.isNotEmpty)
                          ? imageList[0]
                          : "";
                      bool isNetworkImage = imagePath.startsWith('http');

                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => ProductDetails(product),
                          ),
                        ),
                        child: Container(
                          width: 140.w,
                          margin: EdgeInsets.only(right: 15.w, bottom: 5.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15.r),
                                    ),
                                    image: DecorationImage(
                                      image: isNetworkImage
                                          ? NetworkImage(imagePath)
                                          : AssetImage(imagePath)
                                                as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product["product-name"],
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "৳${product["product-price"]}",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.deep_orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 20.h),

                // Popular Products
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular Products",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "See All",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.deep_orange,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),

                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return Text('Something went wrong');
                    // if (snapshot.connectionState == ConnectionState.waiting)
                    //   return Center(child: CircularProgressIndicator());

                    List allProducts = [];
                    // Add local products
                    allProducts.addAll(_localProducts);

                    if (snapshot.hasData) {
                      for (var doc in snapshot.data!.docs) {
                        allProducts.add(doc.data());
                      }
                    }

                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 15.h,
                      ),
                      itemCount: allProducts.length,
                      itemBuilder: (_, index) {
                        var product = allProducts[index];
                        var imageList = product["product-img"];
                        String imagePath =
                            (imageList is List && imageList.isNotEmpty)
                            ? imageList[0]
                            : "assets/logo/logo1.png";
                        bool isNetworkImage = imagePath.startsWith('http');

                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetails(product),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withValues(alpha: 0.1),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(15.r),
                                          ),
                                          image: DecorationImage(
                                            image: isNetworkImage
                                                ? NetworkImage(imagePath)
                                                      as ImageProvider
                                                : AssetImage(imagePath),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8.h,
                                        right: 8.w,
                                        child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.favorite_border,
                                            size: 18.sp,
                                            color: AppColors.deep_orange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product["product-name"],
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 5.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "৳${product["product-price"]}",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: AppColors.deep_orange,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: AppColors.deep_orange,
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              size: 18.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    List<Map<String, dynamic>> categories = [
      {
        "name": "Electronics",
        "icon": Icons.devices_rounded,
        "image": "assets/carousel/slider1.jpg",
        "color": Color(0xFF2196F3),
        "gradient": [Color(0xFF2196F3), Color(0xFF64B5F6)],
        "count": 1250,
        "trending": true,
      },
      {
        "name": "Fashion",
        "icon": Icons.checkroom_rounded,
        "image": "assets/carousel/slider2.jpg",
        "color": Color(0xFFE91E63),
        "gradient": [Color(0xFFE91E63), Color(0xFFF48FB1)],
        "count": 3420,
        "trending": true,
      },
      {
        "name": "Shoes",
        "icon": Icons.directions_run_rounded,
        "image": "assets/carousel/slider3.jpg",
        "color": Color(0xFFFF9800),
        "gradient": [Color(0xFFFF9800), Color(0xFFFFB74D)],
        "count": 890,
        "trending": false,
      },
      {
        "name": "Watches",
        "icon": Icons.watch_rounded,
        "image": "assets/carousel/slider4.jpg",
        "color": Color(0xFF9C27B0),
        "gradient": [Color(0xFF9C27B0), Color(0xFFCE93D8)],
        "count": 456,
        "trending": false,
      },
      {
        "name": "Home",
        "icon": Icons.chair_rounded,
        "image": "assets/carousel/slider5.jpg",
        "color": Color(0xFF4CAF50),
        "gradient": [Color(0xFF4CAF50), Color(0xFF81C784)],
        "count": 678,
        "trending": false,
      },
      {
        "name": "Beauty",
        "icon": Icons.face_retouching_natural,
        "image": "assets/carousel/slider6.jpg",
        "color": Color(0xFFFF5722),
        "gradient": [Color(0xFFFF5722), Color(0xFFFF8A65)],
        "count": 1120,
        "trending": true,
      },
      {
        "name": "Sports",
        "icon": Icons.sports_basketball_rounded,
        "image": "assets/carousel/slider1.jpg",
        "color": Color(0xFF00BCD4),
        "gradient": [Color(0xFF00BCD4), Color(0xFF4DD0E1)],
        "count": 340,
        "trending": false,
      },
      {
        "name": "Books",
        "icon": Icons.menu_book_rounded,
        "image": "assets/carousel/slider2.jpg",
        "color": Color(0xFF795548),
        "gradient": [Color(0xFF795548), Color(0xFFA1887F)],
        "count": 2100,
        "trending": false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Categories",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () => _showAllCategories(categories),
                child: Row(
                  children: [
                    Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.deep_orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12.sp,
                      color: AppColors.deep_orange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        // Categories List
        SizedBox(
          height: 95.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 15.w),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index];
              return _buildCategoryCard(category);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () => _onCategoryTap(category),
      child: Container(
        width: 72.w,
        margin: EdgeInsets.only(right: 12.w),
        child: Column(
          children: [
            // Category Icon with gradient
            Stack(
              children: [
                Container(
                  width: 58.w,
                  height: 58.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: List<Color>.from(category['gradient']),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: (category['color'] as Color).withValues(
                          alpha: 0.3,
                        ),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    category['icon'],
                    color: Colors.white,
                    size: 26.sp,
                  ),
                ),
                // Trending badge
                if (category['trending'] == true)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Icon(
                        Icons.local_fire_department,
                        color: Colors.white,
                        size: 8.sp,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            // Category name
            Text(
              category['name'],
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            // Product count
            Text(
              "${_formatCount(category['count'])} items",
              style: TextStyle(fontSize: 9.sp, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1)}k";
    }
    return count.toString();
  }

  void _onCategoryTap(Map<String, dynamic> category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(category['icon'], color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text("${category['name']} - ${category['count']} products"),
          ],
        ),
        backgroundColor: category['color'],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showAllCategories(List<Map<String, dynamic>> categories) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Icon(
                    Icons.category_rounded,
                    color: AppColors.deep_orange,
                    size: 24.sp,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "All Categories",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "${categories.length} categories",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 15.h,
                  childAspectRatio: 0.75,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  var category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _onCategoryTap(category);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 55.w,
                          height: 55.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: List<Color>.from(category['gradient']),
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: (category['color'] as Color).withValues(
                                  alpha: 0.25,
                                ),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            category['icon'],
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _formatCount(category['count']),
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.grey[500],
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
    );
  }

  // More Features Section Widget
  Widget _buildMoreFeaturesSection() {
    final features = AppFeatures.getFeatures();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'More Features 🚀',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllFeaturesScreen(),
                    ),
                  );
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.deep_orange,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => feature['screen'] as Widget,
                      ),
                    );
                  },
                  child: Container(
                    width: 140.w,
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: List<Color>.from(feature['gradient']),
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: (feature['gradient'] as List<Color>)[0]
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          feature['icon'] as IconData,
                          color: Colors.white,
                          size: 28.sp,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              feature['title'] as String,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              feature['subtitle'] as String,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 10.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
    );
  }

  Widget _buildBrandItem(String title, String imagePath) {
    return Container(
      margin: EdgeInsets.only(right: 15.w),
      child: Column(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Story Highlights Widget
  Widget _buildStoryHighlights() {
    List<Map<String, dynamic>> stories = [
      {
        "title": "Live Now",
        "subtitle": "🔴 LIVE",
        "gradientColors": [
          Color(0xFFE1306C),
          Color(0xFFF77737),
          Color(0xFFFFDC80),
        ],
        "image": "assets/carousel/slider1.jpg",
        "isLive": true,
        "viewers": 1243,
      },
      {
        "title": "New Arrivals",
        "subtitle": "12 new",
        "gradientColors": [Color(0xFF833AB4), Color(0xFFE1306C)],
        "image": "assets/carousel/slider2.jpg",
        "isNew": true,
        "count": 12,
      },
      {
        "title": "Flash Sale",
        "subtitle": "70% OFF",
        "gradientColors": [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
        "image": "assets/carousel/slider3.jpg",
        "hasTimer": true,
        "endTime": DateTime.now().add(Duration(hours: 5)),
      },
      {
        "title": "Top Picks",
        "subtitle": "Bestsellers",
        "gradientColors": [Color(0xFF4776E6), Color(0xFF8E54E9)],
        "image": "assets/carousel/slider4.jpg",
        "rating": 4.9,
      },
      {
        "title": "Free Shipping",
        "subtitle": "Today only",
        "gradientColors": [Color(0xFF11998E), Color(0xFF38EF7D)],
        "image": "assets/carousel/slider5.jpg",
        "icon": Icons.local_shipping,
      },
      {
        "title": "Trending",
        "subtitle": "🔥 Hot",
        "gradientColors": [Color(0xFFFF416C), Color(0xFFFF4B2B)],
        "image": "assets/carousel/slider6.jpg",
        "trendCount": 5420,
      },
    ];

    return SizedBox(
      height: 110.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          var story = stories[index];
          bool isLive = story['isLive'] == true;
          bool isNew = story['isNew'] == true;

          return GestureDetector(
            onTap: () => _showStoryPopup(context, story),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                children: [
                  Stack(
                    children: [
                      // Gradient border (Instagram style)
                      Container(
                        width: 72.w,
                        height: 72.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: List<Color>.from(story['gradientColors']),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: EdgeInsets.all(3),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.all(2),
                          child: ClipOval(
                            child: Image.asset(
                              story['image'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: (story['gradientColors'] as List)[0],
                                  child: Icon(
                                    story['icon'] ?? Icons.shopping_bag,
                                    color: Colors.white,
                                    size: 28.sp,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      // Live indicator
                      if (isLive)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                "LIVE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      // New count badge
                      if (isNew)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Text(
                              "${story['count']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    story['title'],
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isLive)
                    Text(
                      "${story['viewers']} watching",
                      style: TextStyle(fontSize: 9.sp, color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showStoryPopup(BuildContext context, Map<String, dynamic> story) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 10.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Progress bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              child: LinearProgressIndicator(
                value: 0.3,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: List<Color>.from(story['gradientColors']),
                      ),
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    padding: EdgeInsets.all(2),
                    child: ClipOval(
                      child: Image.asset(
                        story['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story['title'],
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      Text(
                        "Just now",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: Container(
                margin: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(story['image']),
                    fit: BoxFit.cover,
                    onError: (_, __) {},
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20.h,
                      left: 20.w,
                      right: 20.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story['subtitle'] ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.w,
                                vertical: 12.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              "Shop Now",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom actions
            Padding(
              padding: EdgeInsets.all(15.w),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Send message...",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Icon(Icons.favorite_border, color: Colors.white, size: 28.sp),
                  SizedBox(width: 15.w),
                  Icon(Icons.send, color: Colors.white, size: 28.sp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Quick Access Buttons - More Realistic with badges and animations
  // Real-time data holders for quick access
  int _pendingOrdersCount = 0;
  int _wishlistCount = 0;
  double _walletBalance = 0.0;
  int _activeCoupons = 0;
  bool _hasNewRewards = false;

  Future<void> _loadQuickAccessData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // Load pending orders count
      final ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('user-id', isEqualTo: user.email)
          .where('status', whereIn: ['Pending', 'Processing', 'Shipped'])
          .get();

      // Load wishlist count
      final wishlistSnapshot = await FirebaseFirestore.instance
          .collection('users-favourite-items')
          .doc(user.email)
          .collection('items')
          .get();

      if (mounted) {
        setState(() {
          _pendingOrdersCount = ordersSnapshot.docs.length;
          _wishlistCount = wishlistSnapshot.docs.length;
          _walletBalance = 1250.00; // Can be loaded from user profile
          _activeCoupons = 3;
          _hasNewRewards = true;
        });
      }
    } catch (e) {
      // Use default demo values
      if (mounted) {
        setState(() {
          _pendingOrdersCount = 2;
          _wishlistCount = 8;
          _walletBalance = 1250.00;
          _activeCoupons = 3;
          _hasNewRewards = true;
        });
      }
    }
  }

  Widget _buildQuickAccessButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCompactButton(
              icon: Icons.account_balance_wallet_rounded,
              label: "Wallet",
              color: Color(0xFF00C853),
              badge: "৳${_walletBalance.toStringAsFixed(0)}",
              onTap: () => _showWalletBottomSheet(),
            ),
            _buildCompactButton(
              icon: Icons.shopping_bag_rounded,
              label: "Orders",
              color: Color(0xFF2196F3),
              badge: _pendingOrdersCount > 0 ? "$_pendingOrdersCount" : null,
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => MyOrders()),
              ),
            ),
            _buildCompactButton(
              icon: Icons.favorite_rounded,
              label: "Wishlist",
              color: Color(0xFFE91E63),
              badge: _wishlistCount > 0 ? "$_wishlistCount" : null,
              onTap: () => Navigator.push(
                context,
                CupertinoPageRoute(builder: (_) => Favourite()),
              ),
            ),
            _buildCompactButton(
              icon: Icons.confirmation_number_rounded,
              label: "Coupons",
              color: Color(0xFFFF9800),
              badge: _activeCoupons > 0 ? "$_activeCoupons" : null,
              onTap: () => _showCouponsBottomSheet(),
            ),
            _buildCompactButton(
              icon: Icons.stars_rounded,
              label: "Rewards",
              color: Color(0xFFFFD700),
              badge: _hasNewRewards ? "•" : null,
              onTap: () => _showRewardsBottomSheet(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactButton({
    required IconData icon,
    required String label,
    required Color color,
    String? badge,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22.sp),
              ),
              if (badge != null)
                Positioned(
                  top: -4,
                  right: -6,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: badge == "•" ? Colors.red : color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: badge == "•" ? 10.sp : 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // Wallet Bottom Sheet with full details
  void _showWalletBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20.h),
            // Wallet Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF1E3C72).withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "My Wallet",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.verified,
                              color: Colors.greenAccent,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Active",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25.h),
                  Text(
                    "Available Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "৳ ${_walletBalance.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildWalletAction(
                          Icons.add,
                          "Add Money",
                          Colors.greenAccent,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildWalletAction(
                          Icons.send,
                          "Transfer",
                          Colors.blueAccent,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: _buildWalletAction(
                          Icons.history,
                          "History",
                          Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Recent Transactions
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Text(
                    "Recent Transactions",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "See All",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.deep_orange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  _buildTransactionItem(
                    icon: Icons.shopping_bag,
                    title: "Order #12345",
                    subtitle: "2 hours ago",
                    amount: "-৳850.00",
                    isDebit: true,
                  ),
                  _buildTransactionItem(
                    icon: Icons.card_giftcard,
                    title: "Cashback Reward",
                    subtitle: "Yesterday",
                    amount: "+৳50.00",
                    isDebit: false,
                  ),
                  _buildTransactionItem(
                    icon: Icons.account_balance,
                    title: "Added via bKash",
                    subtitle: "3 days ago",
                    amount: "+৳2000.00",
                    isDebit: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletAction(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22.sp),
          SizedBox(height: 5.h),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required bool isDebit,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isDebit ? Colors.red : Colors.green).withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDebit ? Colors.red : Colors.green,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: isDebit ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _showRewardsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8E1), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.amber[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20.h),
            // Points Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "⭐ Your Points",
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        "2,450",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "= ৳245 value",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Icon(
                          Icons.redeem,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Redeem",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            // Ways to earn
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Ways to Earn",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  _buildEarnItem(
                    "🛒",
                    "Shop & Earn",
                    "1 point per ৳10 spent",
                    "+100 pts",
                  ),
                  _buildEarnItem(
                    "⭐",
                    "Write Review",
                    "Review your purchases",
                    "+50 pts",
                  ),
                  _buildEarnItem(
                    "👥",
                    "Refer Friend",
                    "Invite friends to join",
                    "+200 pts",
                  ),
                  _buildEarnItem(
                    "🎂",
                    "Birthday Bonus",
                    "Special birthday reward",
                    "+500 pts",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarnItem(
    String emoji,
    String title,
    String subtitle,
    String points,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 28.sp)),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[500], fontSize: 11.sp),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              points,
              style: TextStyle(
                color: Colors.amber[800],
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCouponsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Icon(
                    Icons.confirmation_number,
                    color: AppColors.deep_orange,
                    size: 28.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    "My Coupons",
                    style: TextStyle(
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
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "3 Available",
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  _buildCouponCard(
                    code: "WELCOME50",
                    discount: "৳50 OFF",
                    minPurchase: "Min. purchase ৳500",
                    expiry: "Expires in 3 days",
                    color: Color(0xFF4CAF50),
                  ),
                  _buildCouponCard(
                    code: "FLASH20",
                    discount: "20% OFF",
                    minPurchase: "Max discount ৳200",
                    expiry: "Expires today!",
                    color: Color(0xFFFF5722),
                    isUrgent: true,
                  ),
                  _buildCouponCard(
                    code: "FREESHIP",
                    discount: "Free Shipping",
                    minPurchase: "On orders above ৳1000",
                    expiry: "Expires in 7 days",
                    color: Color(0xFF2196F3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponCard({
    required String code,
    required String discount,
    required String minPurchase,
    required String expiry,
    required Color color,
    bool isUrgent = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left colored section
          Container(
            width: 100.w,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
            child: Column(
              children: [
                Text(
                  discount.split(' ')[0],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  discount.split(' ').length > 1 ? discount.split(' ')[1] : '',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          // Right info section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Text(
                          code,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Coupon '$code' copied!"),
                              backgroundColor: color,
                            ),
                          );
                        },
                        child: Text(
                          "Copy",
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    minPurchase,
                    style: TextStyle(color: Colors.grey[600], fontSize: 11.sp),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        isUrgent ? Icons.timer : Icons.access_time,
                        size: 14.sp,
                        color: isUrgent ? Colors.red : Colors.grey,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        expiry,
                        style: TextStyle(
                          color: isUrgent ? Colors.red : Colors.grey[600],
                          fontSize: 11.sp,
                          fontWeight: isUrgent
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Rewards Banner
  Widget _buildRewardsBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber[700]!, Colors.orange[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.stars, color: Colors.white, size: 35.sp),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "🎉 Earn Rewards!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    "Shop & earn points. Redeem for discounts!",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Join Now",
                style: TextStyle(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Trending Section
  Widget _buildTrendingSection() {
    List<Map<String, dynamic>> trendingProducts = [
      {
        "product-name": "Smart Watch Pro",
        "product-description":
            "Advanced fitness tracking with heart rate monitor",
        "product-price": 8500.0,
        "product-img": ["assets/products/product5.jpg"],
        "rating": 4.8,
        "sold": 1250,
      },
      {
        "product-name": "Wireless Earbuds",
        "product-description": "Premium sound quality with noise cancellation",
        "product-price": 3500.0,
        "product-img": ["assets/products/product6.jpg"],
        "rating": 4.6,
        "sold": 2340,
      },
      {
        "product-name": "Sports Sneakers",
        "product-description": "Lightweight running shoes for athletes",
        "product-price": 5200.0,
        "product-img": ["assets/products/product7.jpg"],
        "rating": 4.9,
        "sold": 890,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Icon(Icons.local_fire_department, color: Colors.red, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                "Trending Now",
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Spacer(),
              Text(
                "See All",
                style: TextStyle(fontSize: 14.sp, color: AppColors.deep_orange),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20.w),
            itemCount: trendingProducts.length,
            itemBuilder: (context, index) {
              var product = trendingProducts[index];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (_) => ProductDetails(product)),
                ),
                child: Container(
                  width: 160.w,
                  margin: EdgeInsets.only(right: 15.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 100.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              image: DecorationImage(
                                image: AssetImage(product["product-img"][0]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 3.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: Colors.white,
                                    size: 12.sp,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    "HOT",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product["product-name"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 3.w),
                                Text(
                                  "${product['rating']}",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  "${product['sold']}+ sold",
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              "৳${product['product-price'].toStringAsFixed(0)}",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deep_orange,
                              ),
                            ),
                          ],
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
