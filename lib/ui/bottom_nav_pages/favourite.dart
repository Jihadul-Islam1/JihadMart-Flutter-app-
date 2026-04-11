import 'package:flutter/material.dart';
import 'package:jihad/ui/bottom_nav_controller.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/utils/cart_service.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

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
          backgroundColor: const Color.fromARGB(255, 249, 248, 248),
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
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "My Wishlist",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          if (_favouriteItems.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _clearAllFavourites,
              tooltip: "Clear All",
            ),
        ],
      ),
      body: SafeArea(
        child: _favouriteItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 60.sp,
                        color: AppColors.deepOrange,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Your wishlist is empty",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Tap the heart icon on any product\nto save it for later",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavController(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepOrange,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 15.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        "Explore Products",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_favouriteItems.length} Items",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _addAllToCart,
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            size: 18.sp,
                            color: AppColors.deepOrange,
                          ),
                          label: Text(
                            "Add All to Cart",
                            style: TextStyle(
                              color: AppColors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 15.w,
                        mainAxisSpacing: 15.h,
                      ),
                      itemCount: _favouriteItems.length,
                      itemBuilder: (context, index) {
                        final item = _favouriteItems[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
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
                                          top: Radius.circular(15),
                                        ),
                                        image: DecorationImage(
                                          image: AssetImage(item['images'][0]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8.h,
                                      right: 8.w,
                                      child: GestureDetector(
                                        onTap: () =>
                                            _removeFromFavourites(index),
                                        child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            size: 16.sp,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      "৳${item['price']}",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColors.deepOrange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 35.h,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          CartService.addToCart({
                                            "product-name": item['name'],
                                            "product-price": item['price'],
                                            "product-img": item['images'],
                                          });
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "${item['name']} added to cart",
                                              ),
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.deepOrange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Text(
                                          "Add to Cart",
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
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
    );
  }
}
