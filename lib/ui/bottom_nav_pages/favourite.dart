import 'package:flutter/material.dart';
import 'package:jihad/ui/bottom_nav_pages/home.dart'; // Home screen এর import
import 'package:jihad/ui/bottom_nav_controller.dart'; // BottomNavController এর import
import 'package:jihad/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/utils/cart_service.dart'; // আমরা আগেই এই service তৈরি করেছি

class Favourite extends StatefulWidget {
  @override
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<Map<String, dynamic>> get _favouriteItems {
    return CartService.getFavouriteItems();
  }

  void _removeFromFavourites(int index) {
    setState(() {
      String itemName = _favouriteItems[index]['name'];
      // CartService দিয়ে remove করছি
      CartService.toggleFavourite({
        "product-name": itemName,
        "product-price": _favouriteItems[index]['price'],
        "product-img": _favouriteItems[index]['images'],
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$itemName removed from favourites"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _clearAllFavourites() {
    setState(() {
      // সব favourites একবারে remove করছি
      while (_favouriteItems.isNotEmpty) {
        CartService.toggleFavourite({
          "product-name": _favouriteItems[0]['name'],
          "product-price": _favouriteItems[0]['price'],
          "product-img": _favouriteItems[0]['images'],
        });
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All favourites cleared"),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _addAllToCart() {
    int addedCount = 0;
    
    for (var item in _favouriteItems) {
      CartService.addToCart({
        "product-name": item['name'],
        "product-price": item['price'],
        "product-img": item['images'],
      });
      addedCount++;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$addedCount items added to cart from favourites"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "My Favourites",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          if (_favouriteItems.isNotEmpty)
            PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Colors.black),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.shopping_cart),
                    title: Text("Add All to Cart"),
                    onTap: () {
                      Navigator.pop(context);
                      _addAllToCart();
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text("Clear All", style: TextStyle(color: Colors.red)),
                    onTap: () {
                      Navigator.pop(context);
                      _clearAllFavourites();
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
      body: SafeArea(
        child: _favouriteItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      size: 80.sp,
                      color: Colors.grey[300],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "No Favourites Yet",
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "Add products to your favourites",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
  onPressed: () {
    // Bottom navigation এর home index (0) এ navigate করবে
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavController(), // তোমার main navigation
      ),
    );
  },
  child: Text("Browse Products"),
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.deep_orange,
    padding: EdgeInsets.symmetric(
      horizontal: 24.w,
      vertical: 12.h,
    ),
  ),
),
                  ],
                ),
              )
            : Column(
                children: [
                  // Favourites Count
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Favourite items: ${_favouriteItems.length}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _addAllToCart,
                          icon: Icon(Icons.shopping_cart, size: 16.sp),
                          label: Text("Add All to Cart"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deep_orange,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Favourites List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: _favouriteItems.length,
                      itemBuilder: (context, index) {
                        final item = _favouriteItems[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.only(bottom: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              children: [
                                // Product Image
                                Container(
                                  width: 80.w,
                                  height: 80.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: AssetImage(item['images'][0]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                
                                // Product Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "\$${item['price']}",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.deep_orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      
                                      // Action Buttons
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              // Add to cart from favourites
                                              CartService.addToCart({
                                                "product-name": item['name'],
                                                "product-price": item['price'],
                                                "product-img": item['images'],
                                              });
                                              
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("${item['name']} added to cart"),
                                                  backgroundColor: Colors.green,
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                            child: Text("Add to Cart"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.deep_orange,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 6.h,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => _removeFromFavourites(index),
                                            tooltip: "Remove from favourites",
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
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}