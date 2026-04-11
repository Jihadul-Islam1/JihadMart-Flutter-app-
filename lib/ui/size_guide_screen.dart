import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/const/app_colors.dart';

class SizeGuideScreen extends StatefulWidget {
  final String? category;
  const SizeGuideScreen({super.key, this.category});

  @override
  State<SizeGuideScreen> createState() => _SizeGuideScreenState();
}

class _SizeGuideScreenState extends State<SizeGuideScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Size Guide",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.deepOrange,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.deepOrange,
          tabs: const [
            Tab(text: "Shoes"),
            Tab(text: "Shirts"),
            Tab(text: "Pants"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildShoeSizeGuide(),
          _buildShirtSizeGuide(),
          _buildPantsSizeGuide(),
        ],
      ),
    );
  }

  Widget _buildShoeSizeGuide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMeasurementTip(
            "How to Measure",
            "Place your foot on paper, mark heel and longest toe, measure the distance.",
            Icons.straighten,
          ),
          SizedBox(height: 20.h),
          _buildSizeTable(
            "Men's Shoe Sizes",
            ["BD", "US", "UK", "EU", "Foot (cm)"],
            [
              ["38", "6", "5.5", "38", "24"],
              ["39", "7", "6.5", "39", "24.5"],
              ["40", "7.5", "7", "40", "25"],
              ["41", "8", "7.5", "41", "25.5"],
              ["42", "9", "8.5", "42", "26"],
              ["43", "10", "9.5", "43", "27"],
              ["44", "11", "10.5", "44", "28"],
              ["45", "12", "11.5", "45", "29"],
            ],
          ),
          SizedBox(height: 20.h),
          _buildSizeTable(
            "Women's Shoe Sizes",
            ["BD", "US", "UK", "EU", "Foot (cm)"],
            [
              ["35", "5", "3", "35", "22"],
              ["36", "6", "4", "36", "22.5"],
              ["37", "7", "5", "37", "23"],
              ["38", "8", "6", "38", "24"],
              ["39", "9", "7", "39", "24.5"],
              ["40", "10", "8", "40", "25"],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShirtSizeGuide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMeasurementTip(
            "How to Measure",
            "Measure chest around the fullest part, waist at natural waistline.",
            Icons.accessibility_new,
          ),
          SizedBox(height: 20.h),
          _buildSizeTable(
            "Men's Shirt Sizes",
            ["Size", "Chest (in)", "Waist (in)", "Shoulder (in)"],
            [
              ["S", "34-36", "28-30", "17"],
              ["M", "38-40", "32-34", "18"],
              ["L", "42-44", "36-38", "19"],
              ["XL", "46-48", "40-42", "20"],
              ["XXL", "50-52", "44-46", "21"],
            ],
          ),
          SizedBox(height: 20.h),
          _buildSizeTable(
            "Women's Shirt Sizes",
            ["Size", "Bust (in)", "Waist (in)", "Hip (in)"],
            [
              ["XS", "31-32", "24-25", "34-35"],
              ["S", "33-34", "26-27", "36-37"],
              ["M", "35-36", "28-29", "38-39"],
              ["L", "37-39", "30-32", "40-42"],
              ["XL", "40-42", "33-35", "43-45"],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPantsSizeGuide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMeasurementTip(
            "How to Measure",
            "Measure waist at natural waistline, inseam from crotch to ankle.",
            Icons.height,
          ),
          SizedBox(height: 20.h),
          _buildSizeTable(
            "Men's Pants Sizes",
            ["Size", "Waist (in)", "Hip (in)", "Inseam (in)"],
            [
              ["28", "28", "36", "30"],
              ["30", "30", "38", "30"],
              ["32", "32", "40", "32"],
              ["34", "34", "42", "32"],
              ["36", "36", "44", "32"],
              ["38", "38", "46", "32"],
            ],
          ),
          SizedBox(height: 20.h),
          _buildSizeTable(
            "Women's Pants Sizes",
            ["Size", "Waist (in)", "Hip (in)", "Inseam (in)"],
            [
              ["XS/26", "25-26", "35-36", "30"],
              ["S/28", "27-28", "37-38", "30"],
              ["M/30", "29-30", "39-40", "31"],
              ["L/32", "31-32", "41-42", "31"],
              ["XL/34", "33-34", "43-44", "32"],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementTip(String title, String description, IconData icon) {
    return Container(
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.blue, size: 24.sp),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeTable(
    String title,
    List<String> headers,
    List<List<String>> data,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
              columnSpacing: 20.w,
              columns: headers
                  .map(
                    (h) => DataColumn(
                      label: Text(
                        h,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              rows: data
                  .map(
                    (row) => DataRow(
                      cells: row
                          .map(
                            (cell) => DataCell(
                              Text(cell, style: TextStyle(fontSize: 12.sp)),
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
