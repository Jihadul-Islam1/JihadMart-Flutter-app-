import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/store_service.dart';

class StoreLocatorScreen extends StatefulWidget {
  const StoreLocatorScreen({super.key});

  @override
  State<StoreLocatorScreen> createState() => _StoreLocatorScreenState();
}

class _StoreLocatorScreenState extends State<StoreLocatorScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> stores;
    switch (_selectedFilter) {
      case 'open':
        stores = StoreLocatorService.getOpenStores();
        break;
      case 'pickup':
        stores = StoreLocatorService.getStoresWithPickup();
        break;
      default:
        stores = StoreLocatorService.getNearbyStores();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('স্টোর খুঁজুন 📍'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search & Filter
          Container(
            padding: EdgeInsets.all(16.w),
            color: Colors.blue.shade600,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'এলাকা বা স্টোর খুঁজুন...',
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    _buildFilterChip('all', 'সব', Icons.store),
                    SizedBox(width: 8.w),
                    _buildFilterChip('open', 'খোলা আছে', Icons.access_time),
                    SizedBox(width: 8.w),
                    _buildFilterChip(
                      'pickup',
                      'পিকআপ',
                      Icons.shopping_bag_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Nearest Store Banner
          if (stores.isNotEmpty)
            Container(
              margin: EdgeInsets.all(16.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade500, Colors.green.shade300],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.near_me,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'নিকটতম স্টোর',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          stores.first['name'] as String,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${stores.first['distance']} km দূরে',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _openDirections(stores.first),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green.shade700,
                    ),
                    child: const Text('রাস্তা দেখুন'),
                  ),
                ],
              ),
            ),

          // Stores List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                return _buildStoreCard(store);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, IconData icon) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withAlpha(50),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? Colors.blue.shade600 : Colors.white,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue.shade600 : Colors.white,
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCard(Map<String, dynamic> store) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.store,
                        color: Colors.blue.shade600,
                        size: 28.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  store['name'] as String,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: store['isOpen'] == true
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  store['isOpen'] == true ? 'খোলা' : 'বন্ধ',
                                  style: TextStyle(
                                    color: store['isOpen'] == true
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            store['address'] as String,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Stats Row
                Row(
                  children: [
                    _buildStoreInfo(
                      Icons.star,
                      '${store['rating']}',
                      Colors.amber,
                    ),
                    SizedBox(width: 16.w),
                    _buildStoreInfo(
                      Icons.location_on,
                      '${store['distance']} km',
                      Colors.blue,
                    ),
                    SizedBox(width: 16.w),
                    _buildStoreInfo(
                      Icons.access_time,
                      store['openHours'] as String,
                      Colors.grey,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Features
                Row(
                  children: [
                    if (store['hasPickup'] == true)
                      _buildFeatureChip('পিকআপ', Icons.shopping_bag_outlined),
                    if (store['hasTryRoom'] == true)
                      _buildFeatureChip('ট্রায়াল রুম', Icons.checkroom),
                    if (store['hasParking'] == true)
                      _buildFeatureChip('পার্কিং', Icons.local_parking),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _callStore(store),
                    icon: const Icon(Icons.phone_outlined),
                    label: const Text('কল করুন'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade600,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openDirections(store),
                    icon: const Icon(Icons.directions),
                    label: const Text('রাস্তা দেখুন'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
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

  Widget _buildStoreInfo(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: color),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: Colors.blue.shade600),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: Colors.blue.shade700),
          ),
        ],
      ),
    );
  }

  void _callStore(Map<String, dynamic> store) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('কলিং ${store['phone']}...')));
  }

  void _openDirections(Map<String, dynamic> store) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${store['name']} এ যাওয়ার রাস্তা দেখানো হচ্ছে...'),
      ),
    );
  }
}
