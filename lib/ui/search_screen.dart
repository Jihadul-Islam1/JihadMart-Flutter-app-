import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/core/constants/firestore_collections.dart';
import 'package:jihad/ui/product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputText = "";

  String _imageUrl(Map<String, dynamic> product) {
    final raw = product['product-img'] ?? product['images'];
    if (raw is List && raw.isNotEmpty) {
      return raw.first.toString();
    }
    if (raw is String && raw.isNotEmpty) {
      return raw;
    }
    return 'assets/products/product1.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Search Products",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              // Search Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Search products...",
                    hintStyle: TextStyle(fontSize: 16.sp),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 15.h,
                    ),
                  ),
                  onChanged: (val) {
                    setState(() {
                      inputText = val;
                    });
                  },
                ),
              ),

              SizedBox(height: 10.h),

              // Search Results Count
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Search real store products",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (inputText.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            inputText = "";
                          });
                        },
                        child: Text(
                          "Clear",
                          style: TextStyle(
                            color: AppColors.deepOrange,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              // Search Results
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection(FirestoreCollections.products)
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Search failed: ${snapshot.error}'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final docs = snapshot.data?.docs ?? [];
                    final filteredProducts = docs
                        .map((doc) => <String, dynamic>{'id': doc.id, ...doc.data()})
                        .where((product) {
                          final searchLower = inputText.toLowerCase().trim();
                          if (searchLower.isEmpty) return true;

                          final productName = (product['product-name'] ?? '').toString().toLowerCase();
                          final productDesc = (product['product-description'] ?? '').toString().toLowerCase();
                          final storeName = (product['storeName'] ?? '').toString().toLowerCase();
                          final category = (product['category'] ?? '').toString().toLowerCase();

                          return productName.contains(searchLower) ||
                              productDesc.contains(searchLower) ||
                              storeName.contains(searchLower) ||
                              category.contains(searchLower);
                        })
                        .toList();

                    if (filteredProducts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 60.sp,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              inputText.isEmpty
                                  ? 'No products available'
                                  : "No products found for '$inputText'",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            if (inputText.isNotEmpty)
                              Text(
                                'Try different keywords',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[400],
                                ),
                              ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final product = filteredProducts[index];
                        final imagePath = _imageUrl(product);
                        final isNetworkImage = imagePath.startsWith('http');

                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.only(bottom: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(12.w),
                            leading: Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: isNetworkImage
                                      ? NetworkImage(imagePath)
                                      : AssetImage(imagePath) as ImageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              product['product-name']?.toString() ?? 'Unnamed product',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4.h),
                                Text(
                                  product['product-description']?.toString() ?? '',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "৳${product['product-price'].toString()}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                    color: AppColors.deepOrange,
                                  ),
                                ),
                                if ((product['storeName'] ?? '').toString().isNotEmpty) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Shop: ${product['storeName']}',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetails(product),
                                ),
                              );
                            },
                          ),
                        );
                      },
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
