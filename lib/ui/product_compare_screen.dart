import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/AppColors.dart';

class ProductCompareScreen extends StatefulWidget {
  const ProductCompareScreen({super.key});

  @override
  State<ProductCompareScreen> createState() => _ProductCompareScreenState();
}

class _ProductCompareScreenState extends State<ProductCompareScreen> {
  final List<Map<String, dynamic>> _availableProducts = [
    {
      "product-name": "Nike Air Max",
      "product-description": "Comfortable running shoes with latest technology",
      "product-price": 4500,
      "product-img": ["assets/products/product1.jpg"],
      "brand": "Nike",
      "rating": 4.8,
      "reviews": 128,
      "material": "Synthetic",
      "weight": "280g",
    },
    {
      "product-name": "Adidas Ultraboost",
      "product-description": "Premium running shoes for professional athletes",
      "product-price": 6500,
      "product-img": ["assets/products/product2.jpg"],
      "brand": "Adidas",
      "rating": 4.7,
      "reviews": 95,
      "material": "Primeknit",
      "weight": "310g",
    },
    {
      "product-name": "Puma RS-X",
      "product-description": "Casual sports shoes with modern design",
      "product-price": 3500,
      "product-img": ["assets/products/product3.jpg"],
      "brand": "Puma",
      "rating": 4.5,
      "reviews": 72,
      "material": "Mesh",
      "weight": "290g",
    },
    {
      "product-name": "Reebok Classic",
      "product-description": "Vintage style shoes for everyday wear",
      "product-price": 2800,
      "product-img": ["assets/products/product4.jpg"],
      "brand": "Reebok",
      "rating": 4.3,
      "reviews": 54,
      "material": "Leather",
      "weight": "320g",
    },
  ];

  List<Map<String, dynamic>> _selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Compare Products",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_selectedProducts.isNotEmpty)
            TextButton(
              onPressed: () {
                setState(() => _selectedProducts.clear());
              },
              child: Text(
                "Clear All",
                style: TextStyle(color: AppColors.deep_orange, fontSize: 14.sp),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Selected products for comparison
          if (_selectedProducts.isNotEmpty)
            Container(
              height: 120.h,
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _selectedProducts.length,
                itemBuilder: (context, index) {
                  final product = _selectedProducts[index];
                  return Stack(
                    children: [
                      Container(
                        width: 100.w,
                        margin: EdgeInsets.only(right: 10.w, top: 10.h),
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.deep_orange),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                product['product-img'][0],
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              product['product-name'],
                              style: TextStyle(fontSize: 10.sp),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 5.w,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedProducts.remove(product);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

          // Compare button
          if (_selectedProducts.length >= 2)
            Padding(
              padding: EdgeInsets.all(15.w),
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton.icon(
                  onPressed: () => _showComparisonResult(context),
                  icon: const Icon(Icons.compare_arrows),
                  label: Text(
                    "Compare ${_selectedProducts.length} Products",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deep_orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),

          // Available products to select
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                Text(
                  "Select Products to Compare",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  "${_selectedProducts.length}/4",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              itemCount: _availableProducts.length,
              itemBuilder: (context, index) {
                final product = _availableProducts[index];
                final isSelected = _selectedProducts.contains(product);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedProducts.remove(product);
                      } else if (_selectedProducts.length < 4) {
                        _selectedProducts.add(product);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Maximum 4 products can be compared"),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.deep_orange
                            : Colors.transparent,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 70.w,
                          height: 70.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(product['product-img'][0]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['product-name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                product['brand'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 14.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "${product['rating']}",
                                    style: TextStyle(fontSize: 12.sp),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "৳${product['product-price']}",
                                    style: TextStyle(
                                      color: AppColors.deep_orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: isSelected,
                          activeColor: AppColors.deep_orange,
                          onChanged: (value) {
                            setState(() {
                              if (value == true &&
                                  _selectedProducts.length < 4) {
                                _selectedProducts.add(product);
                              } else if (value == false) {
                                _selectedProducts.remove(product);
                              }
                            });
                          },
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

  void _showComparisonResult(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: EdgeInsets.all(15.w),
              child: Column(
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    "Product Comparison",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 20.w,
                    columns: [
                      const DataColumn(label: Text("Feature")),
                      ..._selectedProducts.map(
                        (p) => DataColumn(
                          label: SizedBox(
                            width: 80.w,
                            child: Text(
                              p['product-name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                    rows: [
                      _buildDataRow(
                        "Image",
                        _selectedProducts
                            .map(
                              (p) => Image.asset(
                                p['product-img'][0],
                                width: 60.w,
                                height: 60.h,
                              ),
                            )
                            .toList(),
                      ),
                      _buildDataRow(
                        "Price",
                        _selectedProducts
                            .map(
                              (p) => Text(
                                "৳${p['product-price']}",
                                style: TextStyle(
                                  color: AppColors.deep_orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      _buildDataRow(
                        "Brand",
                        _selectedProducts.map((p) => Text(p['brand'])).toList(),
                      ),
                      _buildDataRow(
                        "Rating",
                        _selectedProducts
                            .map(
                              (p) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 16,
                                  ),
                                  Text(" ${p['rating']}"),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      _buildDataRow(
                        "Reviews",
                        _selectedProducts
                            .map((p) => Text("${p['reviews']}"))
                            .toList(),
                      ),
                      _buildDataRow(
                        "Material",
                        _selectedProducts
                            .map((p) => Text(p['material'] ?? "N/A"))
                            .toList(),
                      ),
                      _buildDataRow(
                        "Weight",
                        _selectedProducts
                            .map((p) => Text(p['weight'] ?? "N/A"))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String label, List<Widget> cells) {
    return DataRow(
      cells: [
        DataCell(
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        ...cells.map((c) => DataCell(c)),
      ],
    );
  }
}
