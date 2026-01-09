import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/utils/cart_service.dart';
import 'package:jihad/utils/recently_viewed_service.dart';
import 'package:jihad/ui/checkout_screen.dart';
import 'package:jihad/ui/size_guide_screen.dart';

class ProductDetails extends StatefulWidget {
  final dynamic _product;
  const ProductDetails(this._product, {Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _currentImageIndex = 0;
  bool _isFavourite = false;
  int _selectedSizeIndex = 1; // Default M
  int _selectedColorIndex = 0;

  final List<String> _sizes = ["S", "M", "L", "XL", "XXL"];
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.black,
    Colors.green,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    _isFavourite = CartService.isFavourite(widget._product);
    // Add to recently viewed
    RecentlyViewedService.addProduct(widget._product);
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
          content: Text(
            _isFavourite ? "Added to favourites!" : "Removed from favourites!",
          ),
          backgroundColor: _isFavourite ? Colors.red : Colors.grey,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _shareProduct(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "Share Product",
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(
                  Icons.facebook,
                  "Facebook",
                  Colors.blue[800]!,
                  context,
                ),
                _buildShareOption(
                  Icons.messenger,
                  "Messenger",
                  Colors.blue,
                  context,
                ),
                _buildShareOption(
                  Icons.chat,
                  "WhatsApp",
                  Colors.green,
                  context,
                ),
                _buildShareOption(
                  Icons.copy,
                  "Copy Link",
                  Colors.grey[700]!,
                  context,
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareOption(Icons.email, "Email", Colors.red, context),
                _buildShareOption(Icons.sms, "SMS", Colors.orange, context),
                _buildShareOption(
                  Icons.telegram,
                  "Telegram",
                  Colors.blue[400]!,
                  context,
                ),
                _buildShareOption(
                  Icons.more_horiz,
                  "More",
                  Colors.grey,
                  context,
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOption(
    IconData icon,
    String label,
    Color color,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Shared via $label!"),
            backgroundColor: color,
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var rawImages = widget._product['product-img'];
    List imageList = (rawImages is List && rawImages.isNotEmpty)
        ? rawImages
        : ["assets/logo/logo1.png"];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom App Bar & Image Carousel
                    Stack(
                      children: [
                        CarouselSlider(
                          items: imageList.map<Widget>((item) {
                            String imagePath = item.toString();
                            bool isNetworkImage = imagePath.startsWith('http');
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                image: DecorationImage(
                                  image: isNetworkImage
                                      ? NetworkImage(imagePath) as ImageProvider
                                      : AssetImage(imagePath),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 350.h,
                            autoPlay: false,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                          ),
                        ),
                        Positioned(
                          top: 20.h,
                          left: 20.w,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.black),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 20.h,
                          right: 20.w,
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: Icon(Icons.share, color: Colors.black),
                                  onPressed: () => _shareProduct(context),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: Icon(
                                    _isFavourite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _isFavourite
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                  onPressed: toggleFavourite,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 20.h,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: DotsIndicator(
                              dotsCount: imageList.isEmpty
                                  ? 1
                                  : imageList.length,
                              position: _currentImageIndex.toDouble(),
                              decorator: DotsDecorator(
                                activeColor: AppColors.deep_orange,
                                color: Colors.grey.withOpacity(0.5),
                                size: Size(8, 8),
                                activeSize: Size(10, 10),
                                spacing: EdgeInsets.all(3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Rating
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  widget._product['product-name'],
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.deep_orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 16.sp,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "4.8",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.deep_orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),

                          // Price
                          Text(
                            "৳${widget._product['product-price']}",
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deep_orange,
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // Description
                          Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            widget._product['product-description'],
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // Size Selector
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Select Size",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SizeGuideScreen(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.straighten,
                                  size: 16.sp,
                                  color: AppColors.deep_orange,
                                ),
                                label: Text(
                                  "Size Guide",
                                  style: TextStyle(
                                    color: AppColors.deep_orange,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(_sizes.length, (index) {
                                bool isSelected = _selectedSizeIndex == index;
                                return GestureDetector(
                                  onTap: () => setState(
                                    () => _selectedSizeIndex = index,
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 15.w),
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.deep_orange
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.deep_orange
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Text(
                                      _sizes[index],
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),

                          SizedBox(height: 20.h),

                          // Color Selector
                          Text(
                            "Select Color",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: List.generate(_colors.length, (index) {
                              bool isSelected = _selectedColorIndex == index;
                              return GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedColorIndex = index),
                                child: Container(
                                  margin: EdgeInsets.only(right: 15.w),
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.deep_orange
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Container(
                                    width: 30.w,
                                    height: 30.w,
                                    decoration: BoxDecoration(
                                      color: _colors[index],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          SizedBox(height: 25.h),

                          // Reviews Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Customer Reviews",
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _showAllReviews(context);
                                },
                                child: Text(
                                  "See All",
                                  style: TextStyle(
                                    color: AppColors.deep_orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),

                          // Review Summary
                          Container(
                            padding: EdgeInsets.all(15.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "4.8",
                                      style: TextStyle(
                                        fontSize: 36.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (index) => Icon(
                                          index < 4
                                              ? Icons.star
                                              : Icons.star_half,
                                          color: Colors.orange,
                                          size: 16.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
                                    Text(
                                      "128 reviews",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: Column(
                                    children: [
                                      _buildRatingBar("5", 0.8),
                                      _buildRatingBar("4", 0.15),
                                      _buildRatingBar("3", 0.03),
                                      _buildRatingBar("2", 0.01),
                                      _buildRatingBar("1", 0.01),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 15.h),

                          // Sample Reviews
                          _buildReviewCard(
                            "Rahim Ahmed",
                            5,
                            "Excellent product! Quality is amazing and delivery was super fast. Highly recommended!",
                            "2 days ago",
                          ),
                          _buildReviewCard(
                            "Fatima Khan",
                            4,
                            "Good product, nice quality. Packaging could be better though.",
                            "1 week ago",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: addToCart,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.deep_orange),
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.deep_orange,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add to cart first then checkout
                        CartService.addToCart(widget._product);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => CheckoutScreen(
                              cartItems: [widget._product],
                              totalAmount: double.parse(
                                widget._product['product-price'].toString(),
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deep_orange,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        "Buy Now",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(String star, double percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Text(
            star,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String name, int rating, String review, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: AppColors.deep_orange.withOpacity(0.1),
                    child: Text(
                      name[0],
                      style: TextStyle(
                        color: AppColors.deep_orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            color: index < rating
                                ? Colors.orange
                                : Colors.grey[300],
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                time,
                style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            review,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _showAllReviews(BuildContext context) {
    final List<Map<String, dynamic>> allReviews = [
      {
        "name": "Rahim Ahmed",
        "rating": 5,
        "review":
            "Excellent product! Quality is amazing and delivery was super fast. Highly recommended!",
        "time": "2 days ago",
      },
      {
        "name": "Fatima Khan",
        "rating": 4,
        "review":
            "Good product, nice quality. Packaging could be better though.",
        "time": "1 week ago",
      },
      {
        "name": "Karim Hossain",
        "rating": 5,
        "review": "Love it! Exactly as described. Will buy again.",
        "time": "2 weeks ago",
      },
      {
        "name": "Nadia Begum",
        "rating": 5,
        "review": "Best purchase I've made. Very happy with the quality.",
        "time": "3 weeks ago",
      },
      {
        "name": "Shakil Rahman",
        "rating": 4,
        "review":
            "Good value for money. Delivery took a bit longer than expected.",
        "time": "1 month ago",
      },
      {
        "name": "Tasnim Akter",
        "rating": 5,
        "review": "Amazing! My favorite product so far.",
        "time": "1 month ago",
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(vertical: 15.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "All Reviews (128)",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(20.w),
                itemCount: allReviews.length,
                itemBuilder: (context, index) {
                  final rev = allReviews[index];
                  return _buildReviewCard(
                    rev['name'],
                    rev['rating'],
                    rev['review'],
                    rev['time'],
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
