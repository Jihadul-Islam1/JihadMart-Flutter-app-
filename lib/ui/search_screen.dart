import 'package:flutter/material.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/ui/product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputText = "";

  // Sample products data - তোমার আসল products data দিয়ে replace করবে
  // SearchScreen.dart file এ _allProducts list টি খুঁজে এই data দিয়ে replace করো:

  List<Map<String, dynamic>> _allProducts = [
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
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
  }

  void _filterProducts(String searchText) {
    setState(() {
      if (searchText.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) {
          final productName = product["product-name"].toString().toLowerCase();
          final productDesc = product["product-description"]
              .toString()
              .toLowerCase();
          final searchLower = searchText.toLowerCase();

          return productName.contains(searchLower) ||
              productDesc.contains(searchLower);
        }).toList();
      }
    });
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
                    _filterProducts(val);
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
                      "Found ${_filteredProducts.length} products",
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
                            _filteredProducts = _allProducts;
                          });
                        },
                        child: Text(
                          "Clear",
                          style: TextStyle(
                            color: AppColors.deep_orange,
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
                child: _filteredProducts.isEmpty
                    ? Center(
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
                                  ? "No products available"
                                  : "No products found for '$inputText'",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            if (inputText.isNotEmpty)
                              Text(
                                "Try different keywords",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[400],
                                ),
                              ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredProducts.length,
                        itemBuilder: (BuildContext context, int index) {
                          final product = _filteredProducts[index];
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
                                    image: AssetImage(
                                      product['product-img'][0],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                product['product-name'],
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
                                    product['product-description'],
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
                                      color: AppColors.deep_orange,
                                    ),
                                  ),
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
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
