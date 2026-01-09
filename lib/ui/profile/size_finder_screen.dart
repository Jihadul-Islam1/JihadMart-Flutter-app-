import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizeFinderScreen extends StatefulWidget {
  final String? category;

  const SizeFinderScreen({super.key, this.category});

  @override
  State<SizeFinderScreen> createState() => _SizeFinderScreenState();
}

class _SizeFinderScreenState extends State<SizeFinderScreen> {
  String _selectedCategory = 'shirts';
  String _gender = 'male';

  // Measurements in cm
  double _height = 170;
  double _weight = 70;
  double _chest = 100;
  double _waist = 85;
  double _hip = 95;
  double _footLength = 26;

  String? _recommendedSize;
  bool _showResult = false;

  final Map<String, List<Map<String, dynamic>>> _sizeCharts = {
    'shirts': [
      {
        'size': 'S',
        'chest': [86, 91],
        'height': [160, 170],
      },
      {
        'size': 'M',
        'chest': [91, 97],
        'height': [165, 175],
      },
      {
        'size': 'L',
        'chest': [97, 102],
        'height': [170, 180],
      },
      {
        'size': 'XL',
        'chest': [102, 107],
        'height': [175, 185],
      },
      {
        'size': 'XXL',
        'chest': [107, 112],
        'height': [180, 190],
      },
    ],
    'pants': [
      {
        'size': '28',
        'waist': [71, 74],
        'hip': [87, 91],
      },
      {
        'size': '30',
        'waist': [76, 79],
        'hip': [92, 96],
      },
      {
        'size': '32',
        'waist': [81, 84],
        'hip': [97, 101],
      },
      {
        'size': '34',
        'waist': [86, 89],
        'hip': [102, 106],
      },
      {
        'size': '36',
        'waist': [91, 94],
        'hip': [107, 111],
      },
    ],
    'shoes': [
      {
        'size': '39',
        'length': [24.5, 25],
      },
      {
        'size': '40',
        'length': [25, 25.5],
      },
      {
        'size': '41',
        'length': [25.5, 26],
      },
      {
        'size': '42',
        'length': [26, 26.5],
      },
      {
        'size': '43',
        'length': [26.5, 27],
      },
      {
        'size': '44',
        'length': [27, 27.5],
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Size Finder 📏'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Selection
            Text(
              'Select Category',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildCategoryChip(
                  'shirts',
                  'Shirts/T-Shirts',
                  Icons.checkroom,
                ),
                SizedBox(width: 8.w),
                _buildCategoryChip(
                  'pants',
                  'Pants/Jeans',
                  Icons.accessibility_new,
                ),
                SizedBox(width: 8.w),
                _buildCategoryChip('shoes', 'Shoes', Icons.directions_walk),
              ],
            ),
            SizedBox(height: 24.h),

            // Gender Selection
            Text(
              'Gender',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                _buildGenderChip('male', 'Male', Icons.male),
                SizedBox(width: 12.w),
                _buildGenderChip('female', 'Female', Icons.female),
              ],
            ),
            SizedBox(height: 24.h),

            // Measurements
            Container(
              padding: EdgeInsets.all(16.w),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Measurements (cm)',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  if (_selectedCategory == 'shirts' ||
                      _selectedCategory == 'pants') ...[
                    _buildSlider(
                      'Height',
                      _height,
                      140,
                      200,
                      (value) => setState(() => _height = value),
                      Icons.height,
                    ),
                    SizedBox(height: 16.h),
                    _buildSlider(
                      'Weight (kg)',
                      _weight,
                      40,
                      120,
                      (value) => setState(() => _weight = value),
                      Icons.fitness_center,
                    ),
                  ],

                  if (_selectedCategory == 'shirts') ...[
                    SizedBox(height: 16.h),
                    _buildSlider(
                      'Chest',
                      _chest,
                      70,
                      130,
                      (value) => setState(() => _chest = value),
                      Icons.accessibility,
                    ),
                  ],

                  if (_selectedCategory == 'pants') ...[
                    SizedBox(height: 16.h),
                    _buildSlider(
                      'Waist',
                      _waist,
                      60,
                      120,
                      (value) => setState(() => _waist = value),
                      Icons.straighten,
                    ),
                    SizedBox(height: 16.h),
                    _buildSlider(
                      'Hip',
                      _hip,
                      70,
                      130,
                      (value) => setState(() => _hip = value),
                      Icons.airline_seat_legroom_extra,
                    ),
                  ],

                  if (_selectedCategory == 'shoes') ...[
                    SizedBox(height: 16.h),
                    _buildSlider(
                      'Foot Length',
                      _footLength,
                      22,
                      30,
                      (value) => setState(() => _footLength = value),
                      Icons.directions_walk,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Find Size Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _findSize,
                icon: const Icon(Icons.search),
                label: const Text('Find My Size'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ),

            // Result
            if (_showResult) ...[SizedBox(height: 24.h), _buildResultCard()],

            // Size Chart
            SizedBox(height: 24.h),
            _buildSizeChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String value, String label, IconData icon) {
    final isSelected = _selectedCategory == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _selectedCategory = value;
          _showResult = false;
        }),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? Colors.teal : Colors.grey.shade300,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24.sp,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderChip(String value, String label, IconData icon) {
    final isSelected = _gender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _gender = value),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? Colors.teal : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20.sp, color: Colors.teal),
                SizedBox(width: 8.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '${value.round()} ${label.contains('kg') ? 'kg' : 'cm'}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: Colors.teal,
          inactiveColor: Colors.teal.shade100,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _findSize() {
    String size = 'M'; // Default

    if (_selectedCategory == 'shirts') {
      for (var chart in _sizeCharts['shirts']!) {
        final chestRange = chart['chest'] as List<int>;
        if (_chest >= chestRange[0] && _chest <= chestRange[1]) {
          size = chart['size'] as String;
          break;
        }
      }
    } else if (_selectedCategory == 'pants') {
      for (var chart in _sizeCharts['pants']!) {
        final waistRange = chart['waist'] as List<int>;
        if (_waist >= waistRange[0] && _waist <= waistRange[1]) {
          size = chart['size'] as String;
          break;
        }
      }
    } else if (_selectedCategory == 'shoes') {
      for (var chart in _sizeCharts['shoes']!) {
        final lengthRange = chart['length'] as List<double>;
        if (_footLength >= lengthRange[0] && _footLength <= lengthRange[1]) {
          size = chart['size'] as String;
          break;
        }
      }
    }

    setState(() {
      _recommendedSize = size;
      _showResult = true;
    });
  }

  Widget _buildResultCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal.shade400, Colors.teal.shade600],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withAlpha(80),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 50.sp),
          SizedBox(height: 12.h),
          Text(
            'Your Recommended Size',
            style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            _recommendedSize ?? 'M',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(50),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '${_selectedCategory == 'shirts'
                  ? 'Shirt'
                  : _selectedCategory == 'pants'
                  ? 'Pant'
                  : 'Shoe'} Size',
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeChart() {
    final chart = _sizeCharts[_selectedCategory] ?? [];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.table_chart, size: 20.sp, color: Colors.teal),
              SizedBox(width: 8.w),
              Text(
                'Size Chart',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateColor.resolveWith(
                (states) => Colors.teal.shade50,
              ),
              columns: _getTableColumns(),
              rows: chart.map((item) {
                return DataRow(
                  selected: _recommendedSize == item['size'],
                  cells: _getTableCells(item),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<DataColumn> _getTableColumns() {
    if (_selectedCategory == 'shirts') {
      return [
        const DataColumn(label: Text('Size')),
        const DataColumn(label: Text('Chest (cm)')),
        const DataColumn(label: Text('Height (cm)')),
      ];
    } else if (_selectedCategory == 'pants') {
      return [
        const DataColumn(label: Text('Size')),
        const DataColumn(label: Text('Waist (cm)')),
        const DataColumn(label: Text('Hip (cm)')),
      ];
    } else {
      return [
        const DataColumn(label: Text('Size')),
        const DataColumn(label: Text('Foot Length (cm)')),
      ];
    }
  }

  List<DataCell> _getTableCells(Map<String, dynamic> item) {
    if (_selectedCategory == 'shirts') {
      return [
        DataCell(Text(item['size'] as String)),
        DataCell(Text('${item['chest'][0]} - ${item['chest'][1]}')),
        DataCell(Text('${item['height'][0]} - ${item['height'][1]}')),
      ];
    } else if (_selectedCategory == 'pants') {
      return [
        DataCell(Text(item['size'] as String)),
        DataCell(Text('${item['waist'][0]} - ${item['waist'][1]}')),
        DataCell(Text('${item['hip'][0]} - ${item['hip'][1]}')),
      ];
    } else {
      return [
        DataCell(Text(item['size'] as String)),
        DataCell(Text('${item['length'][0]} - ${item['length'][1]}')),
      ];
    }
  }
}
