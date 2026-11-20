import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/core/constants/firestore_collections.dart';
import 'package:jihad/ui/checkout_screen.dart';
import 'package:jihad/utils/cart_service.dart';
import 'package:jihad/utils/recently_viewed_service.dart';

class ProductDetails extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetails(this.product, {super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _currentImageIndex = 0;
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    _isFavourite = CartService.isFavourite(widget.product);
    RecentlyViewedService.addProduct(widget.product);
  }

  String _valueOf(String key, {String fallback = ''}) {
    final value = widget.product[key];
    if (value == null) {
      return fallback;
    }

    final text = value.toString().trim();
    return text.isEmpty ? fallback : text;
  }

  String _productId() {
    final fromProduct = _valueOf('id');
    if (fromProduct.isNotEmpty) {
      return fromProduct;
    }

    // Fallback for old/demo records that may not contain id in map.
    return '${_valueOf('storeId')}_${_valueOf('product-name')}_${_valueOf('product-price')}';
  }

  List<String> _imageList() {
    final rawImages = widget.product['product-img'] ?? widget.product['images'];

    if (rawImages is List && rawImages.isNotEmpty) {
      final cleaned = rawImages
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
      if (cleaned.isNotEmpty) {
        return cleaned;
      }
    }

    if (rawImages is String && rawImages.trim().isNotEmpty) {
      return [rawImages.trim()];
    }

    return ['assets/logo/JihadMartlogo.png'];
  }

  Future<Map<String, dynamic>?> _loadStoreInfo() async {
    final storeId = _valueOf('storeId');
    if (storeId.isEmpty) {
      return null;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.stores)
        .doc(storeId)
        .get();
    return snapshot.data();
  }

  void _toggleFavourite() {
    setState(() {
      CartService.toggleFavourite(widget.product);
      _isFavourite = CartService.isFavourite(widget.product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavourite ? 'Added to favourites' : 'Removed from favourites',
        ),
        backgroundColor: _isFavourite ? Colors.red : Colors.grey,
      ),
    );
  }

  void _addToCart() {
    CartService.addToCart(widget.product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_valueOf('product-name', fallback: 'Product')} added to cart'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _infoChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _shopCard(Map<String, dynamic>? storeData) {
    final storeName = (storeData?['name']?.toString().trim().isNotEmpty ?? false)
        ? storeData!['name'].toString()
        : _valueOf('storeName', fallback: 'Vendor Shop');
    final storeDescription = (storeData?['description']?.toString().trim().isNotEmpty ?? false)
        ? storeData!['description'].toString()
        : 'Official shop for this product.';
    final storePhone = storeData?['phone']?.toString().trim() ?? '';
    final storeStatus = (storeData?['status']?.toString().trim().isNotEmpty ?? false)
        ? storeData!['status'].toString()
        : 'active';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.deepOrange.withOpacity(0.12),
                child: Icon(Icons.storefront_outlined, color: AppColors.deepOrange),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storeName,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      storeDescription,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _infoChip('Status: $storeStatus', AppColors.deepOrange),
              if (storePhone.isNotEmpty) _infoChip('Phone: $storePhone', Colors.blue),
              if (_valueOf('category').isNotEmpty) _infoChip('Category: ${_valueOf('category')}', Colors.green),
              if (_valueOf('brand').isNotEmpty) _infoChip('Brand: ${_valueOf('brand')}', Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _trustSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F4),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFFFE2D1)),
      ),
      child: Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: [
          _infoChip('Fast Delivery', Colors.orange),
          _infoChip('7 Day Return', Colors.teal),
          _infoChip('Secure Payment', Colors.indigo),
          _infoChip('Original Product', Colors.green),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18.sp, color: AppColors.deepOrange),
                SizedBox(width: 6.w),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }

  String _userName() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.trim() ?? '';
    if (displayName.isNotEmpty) {
      return displayName;
    }

    final email = user?.email?.trim() ?? '';
    if (email.isNotEmpty) {
      return email.split('@').first;
    }

    return 'Anonymous';
  }

  Future<void> _openWriteReviewSheet() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to write a review')),
      );
      return;
    }

    int selectedRating = 5;
    final reviewController = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setInnerState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20.w,
                  right: 20.w,
                  top: 18.h,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 4.h,
                        width: 48.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'Write a Review',
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Share your experience about this product.',
                      style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: List.generate(5, (index) {
                        final star = index + 1;
                        return IconButton(
                          onPressed: () => setInnerState(() => selectedRating = star),
                          icon: Icon(
                            star <= selectedRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                          ),
                        );
                      }),
                    ),
                    TextField(
                      controller: reviewController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'How was the product quality, delivery and packaging?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final text = reviewController.text.trim();
                          if (text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please write something first')),
                            );
                            return;
                          }

                          final productId = _productId();
                          await FirebaseFirestore.instance
                              .collection(FirestoreCollections.products)
                              .doc(productId)
                              .collection('reviews')
                              .add({
                            'uid': user.uid,
                            'userName': _userName(),
                            'rating': selectedRating,
                            'comment': text,
                            'createdAt': FieldValue.serverTimestamp(),
                          });

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Review submitted')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepOrange,
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                        ),
                        child: const Text('Submit Review', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _reviewSummary(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    if (docs.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          'No reviews yet. Be the first one to rate this product.',
          style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
        ),
      );
    }

    final ratings = docs
        .map((doc) => (doc.data()['rating'] as num?)?.toDouble() ?? 0)
        .toList();
    final average = ratings.reduce((a, b) => a + b) / ratings.length;
    final count = ratings.length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
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
              color: const Color(0xFFFFF4E8),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 6.w),
                Text(
                  average.toStringAsFixed(1),
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count customer ratings',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Based on verified buyer feedback',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewTile(Map<String, dynamic> review) {
    final userName = (review['userName'] ?? 'User').toString();
    final rating = (review['rating'] as num?)?.toInt() ?? 0;
    final comment = (review['comment'] ?? '').toString();

    return Container(
      margin: EdgeInsets.only(top: 10.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.deepOrange.withOpacity(0.12),
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: AppColors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  userName,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            comment,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey[700], height: 1.4),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = _imageList();
    final price = double.tryParse(_valueOf('product-price', fallback: '0')) ?? 0;
    final productId = _productId();

    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _loadStoreInfo(),
          builder: (context, snapshot) {
            final storeData = snapshot.data;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              color: const Color(0xFFF6F6F6),
                              child: CarouselSlider(
                                items: images.map((imagePath) {
                                  final isNetworkImage = imagePath.startsWith('http');
                                  return Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                      image: DecorationImage(
                                        image: isNetworkImage
                                            ? NetworkImage(imagePath)
                                            : AssetImage(imagePath) as ImageProvider,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                options: CarouselOptions(
                                  height: 330.h,
                                  viewportFraction: 1.0,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentImageIndex = index;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16.h,
                              left: 14.w,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16.h,
                              right: 14.w,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: const Icon(Icons.share, color: Colors.black),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Share action coming soon')),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: Icon(
                                        _isFavourite ? Icons.favorite : Icons.favorite_border,
                                        color: _isFavourite ? Colors.red : Colors.black,
                                      ),
                                      onPressed: _toggleFavourite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 10.h,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: DotsIndicator(
                                  dotsCount: images.isEmpty ? 1 : images.length,
                                  position: _currentImageIndex.toDouble(),
                                  decorator: DotsDecorator(
                                    activeColor: AppColors.deepOrange,
                                    color: Colors.grey.withOpacity(0.4),
                                    size: const Size(7, 7),
                                    activeSize: const Size(10, 10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _valueOf('product-name', fallback: 'Product'),
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Text(
                                    '৳${price.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.deepOrange,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF2EA),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Text(
                                      'Best Seller',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.deepOrange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF4EC),
                                  borderRadius: BorderRadius.circular(14.r),
                                  border: Border.all(color: const Color(0xFFFFDEC5)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.local_offer_outlined, color: AppColors.deepOrange),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        'Free delivery on orders over ৳999 and fast replacement support.',
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.brown[700],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 14.h),
                              _sectionCard(
                                title: 'Shop Details',
                                icon: Icons.storefront_outlined,
                                child: _shopCard(storeData),
                              ),
                              _sectionCard(
                                title: 'Why Buy From Us',
                                icon: Icons.verified_user_outlined,
                                child: _trustSection(),
                              ),
                              _sectionCard(
                                title: 'Product Specs',
                                icon: Icons.tune,
                                child: Wrap(
                                  spacing: 8.w,
                                  runSpacing: 8.h,
                                  children: [
                                    if (_valueOf('category').isNotEmpty)
                                      _infoChip('Category: ${_valueOf('category')}', AppColors.deepOrange),
                                    if (_valueOf('brand').isNotEmpty)
                                      _infoChip('Brand: ${_valueOf('brand')}', Colors.blue),
                                    _infoChip('Stock: ${_valueOf('stock', fallback: '0')}', Colors.green),
                                  ],
                                ),
                              ),
                              _sectionCard(
                                title: 'Product Description',
                                icon: Icons.description_outlined,
                                child: Text(
                                  _valueOf('product-description', fallback: 'No description provided.'),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[700],
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              _sectionCard(
                                title: 'Ratings & Reviews',
                                icon: Icons.reviews_outlined,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton.icon(
                                        onPressed: _openWriteReviewSheet,
                                        icon: const Icon(Icons.rate_review_outlined),
                                        label: const Text('Write Review'),
                                      ),
                                    ),
                                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                      stream: FirebaseFirestore.instance
                                          .collection(FirestoreCollections.products)
                                          .doc(productId)
                                          .collection('reviews')
                                          .orderBy('createdAt', descending: true)
                                          .snapshots(),
                                      builder: (context, reviewSnapshot) {
                                        if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                                          return const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 20),
                                            child: Center(child: CircularProgressIndicator()),
                                          );
                                        }

                                        if (reviewSnapshot.hasError) {
                                          return Container(
                                            margin: EdgeInsets.only(top: 12.h),
                                            padding: EdgeInsets.all(12.w),
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade50,
                                              borderRadius: BorderRadius.circular(12.r),
                                            ),
                                            child: Text(
                                              'Could not load reviews',
                                              style: TextStyle(color: Colors.red.shade700),
                                            ),
                                          );
                                        }

                                        final docs = reviewSnapshot.data?.docs ?? [];
                                        final limited = docs.take(5).toList();

                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _reviewSummary(docs),
                                            ...limited.map((doc) => _reviewTile(doc.data())),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 14,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _addToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deepOrange,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                          label: const Text('Add to Cart', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CheckoutScreen(
                                  cartItems: [widget.product],
                                  subtotalAmount: price,
                                  shippingAmount: 10,
                                  taxAmount: 5,
                                  discountAmount: 0,
                                  totalAmount: price + 15,
                                  shippingAddress: '',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: const Text('Buy Now', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
