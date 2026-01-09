import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/brand_service.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'all';
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'all',
    'electronics',
    'fashion',
    'sports',
    'home',
    'beauty',
  ];

  final Map<String, String> _categoryNames = {
    'all': 'All',
    'electronics': 'Electronics',
    'fashion': 'Fashion',
    'sports': 'Sports',
    'home': 'Home',
    'beauty': 'Beauty',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Brands & Shops 🏪'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Brands'),
            Tab(text: 'Following'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(16.w),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search brands...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Category Filter
          Container(
            height: 50.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: FilterChip(
                    label: Text(_categoryNames[category] ?? category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: Colors.indigo.shade100,
                    checkmarkColor: Colors.indigo,
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 8.h),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildAllBrands(), _buildFollowedBrands()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllBrands() {
    List<Map<String, dynamic>> brands = BrandService.getAllBrands();

    // Filter by category
    if (_selectedCategory != 'all') {
      brands = brands.where((b) => b['category'] == _selectedCategory).toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      brands = brands.where((b) {
        final name = (b['name'] as String).toLowerCase();
        return name.contains(_searchController.text.toLowerCase());
      }).toList();
    }

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.85,
      ),
      itemCount: brands.length,
      itemBuilder: (context, index) {
        return _buildBrandCard(brands[index]);
      },
    );
  }

  Widget _buildBrandCard(Map<String, dynamic> brand) {
    final isFollowing = BrandService.isFollowingBrand(brand['id'] as String);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Brand Logo Area
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (brand['color'] as Color).withAlpha(50),
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (brand['color'] as Color).withAlpha(50),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      brand['icon'] as IconData,
                      size: 32.sp,
                      color: brand['color'] as Color,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  if (brand['isVerified'] == true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified, size: 14.sp, color: Colors.blue),
                        SizedBox(width: 4.w),
                        Text(
                          'Verified',
                          style: TextStyle(fontSize: 10.sp, color: Colors.blue),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // Brand Info
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                children: [
                  Text(
                    brand['name'] as String,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${brand['products']} Products',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (isFollowing) {
                            BrandService.unfollowBrand(brand['id'] as String);
                          } else {
                            BrandService.followBrand(brand['id'] as String);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isFollowing
                            ? Colors.grey.shade200
                            : Colors.indigo,
                        foregroundColor: isFollowing
                            ? Colors.black
                            : Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        minimumSize: Size(0, 30.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        isFollowing ? 'Following ✓' : 'Follow',
                        style: TextStyle(fontSize: 11.sp),
                      ),
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

  Widget _buildFollowedBrands() {
    final followedBrands = BrandService.getFollowedBrands();

    if (followedBrands.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.storefront_outlined,
              size: 60.sp,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              'কোনো ব্র্যান্ড অনুসরণ করা হচ্ছে না',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            SizedBox(height: 8.h),
            Text(
              'ব্র্যান্ড অনুসরণ করুন আপডেট পেতে',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: followedBrands.length,
      itemBuilder: (context, index) {
        final brand = followedBrands[index];
        return _buildFollowedBrandItem(brand);
      },
    );
  }

  Widget _buildFollowedBrandItem(Map<String, dynamic> brand) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(20),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: (brand['color'] as Color).withAlpha(30),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              brand['icon'] as IconData,
              color: brand['color'] as Color,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      brand['name'] as String,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (brand['isVerified'] == true) ...[
                      SizedBox(width: 6.w),
                      Icon(Icons.verified, size: 16.sp, color: Colors.blue),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  '${brand['products']} প্রোডাক্ট • ${brand['followers']} অনুসারী',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                if (brand['hasNewProducts'] == true)
                  Container(
                    margin: EdgeInsets.only(top: 6.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '🆕 নতুন প্রোডাক্ট',
                      style: TextStyle(fontSize: 10.sp, color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                BrandService.unfollowBrand(brand['id'] as String);
              });
            },
            icon: const Icon(Icons.notifications_active),
            color: Colors.indigo,
          ),
        ],
      ),
    );
  }
}
