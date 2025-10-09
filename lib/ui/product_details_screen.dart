import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/utils/cart_service.dart'; // Import the new service

class ProductDetails extends StatefulWidget {
  var _product;
  ProductDetails(this._product);
  
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _currentImageIndex = 0;
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    // Check if product is already in favourites
    _isFavourite = CartService.isFavourite(widget._product);
  }

  void addToCart() {
    CartService.addToCart(widget._product);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget._product["product-name"]} added to cart!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void toggleFavourite() {
    setState(() {
      CartService.toggleFavourite(widget._product);
      _isFavourite = CartService.isFavourite(widget._product);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFavourite ? "Added to favourites!" : "Removed from favourites!"),
          backgroundColor: _isFavourite ? Colors.red : Colors.grey,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: AppColors.deep_orange,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleAvatar(
              backgroundColor: _isFavourite ? Colors.red : Colors.grey,
              child: IconButton(
                onPressed: toggleFavourite,
                icon: Icon(
                  _isFavourite ? Icons.favorite : Icons.favorite_outline,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Images Carousel
              AspectRatio(
                aspectRatio: 1.5,
                child: Stack(
                  children: [
                    CarouselSlider(
                      items: widget._product['product-img']
                          .map<Widget>((item) => Padding(
                            padding: const EdgeInsets.only(left: 3, right: 3),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage(item),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ))
                          .toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        aspectRatio: 1.5,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                      ),
                    ),
                    
                    // Image Indicator
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: 
                          List.generate(widget._product['product-img'].length, (index) {
                            return Container(
                              width: 8,
                              height: 8,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentImageIndex == index 
                                    ? AppColors.deep_orange 
                                    : Colors.grey.withOpacity(0.5),
                              ),
                            );
                          }),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20.h),
              
              // Product Name
              Text(
                widget._product['product-name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 25.sp,
                  color: Colors.black87,
                ),
              ),
              
              SizedBox(height: 10.h),
              
              // Product Description
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    widget._product['product-description'],
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              
              SizedBox(height: 15.h),
              
              // Product Price
              Text(
                "\$${widget._product['product-price'].toString()}",
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 30.sp, 
                  color: AppColors.deep_orange,
                ),
              ),
              
              SizedBox(height: 10.h),
              
              Divider(),
              
              SizedBox(height: 15.h),
              
              // Add to Cart Button
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: ElevatedButton(
                  onPressed: addToCart,
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deep_orange,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}