import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

class ARTryOnScreen extends StatefulWidget {
  final String? productId;
  final String? productName;

  const ARTryOnScreen({super.key, this.productId, this.productName});

  @override
  State<ARTryOnScreen> createState() => _ARTryOnScreenState();
}

class _ARTryOnScreenState extends State<ARTryOnScreen>
    with SingleTickerProviderStateMixin {
  int _selectedCategory = 0;
  int _selectedProduct = 0;
  bool _faceDetected = false;
  bool _isLoading = true;
  double _productScale = 1.0;
  double _productRotation = 0.0;
  Offset _productPosition = Offset.zero;
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Glasses', 'icon': Icons.visibility, 'color': Colors.blue},
    {'name': 'Watches', 'icon': Icons.watch, 'color': Colors.orange},
    {'name': 'Shoes', 'icon': Icons.directions_walk, 'color': Colors.green},
    {'name': 'Hats', 'icon': Icons.face, 'color': Colors.purple},
    {'name': 'Jewelry', 'icon': Icons.diamond, 'color': Colors.pink},
  ];

  final List<List<Map<String, dynamic>>> _products = [
    // Glasses
    [
      {
        'name': 'Rayban Aviator',
        'price': 8500.0,
        'color': Colors.black,
        'image': 'assets/products/product1.jpg',
      },
      {
        'name': 'Oakley Sport',
        'price': 12000.0,
        'color': Colors.blue,
        'image': 'assets/products/product2.jpg',
      },
      {
        'name': 'Tom Ford Round',
        'price': 15000.0,
        'color': Colors.brown,
        'image': 'assets/products/product3.jpg',
      },
    ],
    // Watches
    [
      {
        'name': 'Apple Watch',
        'price': 45000.0,
        'color': Colors.grey,
        'image': 'assets/products/product4.jpg',
      },
      {
        'name': 'Samsung Galaxy Watch',
        'price': 25000.0,
        'color': Colors.black,
        'image': 'assets/products/product5.jpg',
      },
      {
        'name': 'Casio Classic',
        'price': 5500.0,
        'color': Color(0xFFC0C0C0),
        'image': 'assets/products/product6.jpg',
      },
    ],
    // Shoes
    [
      {
        'name': 'Nike Air Max',
        'price': 15000.0,
        'color': Colors.red,
        'image': 'assets/products/product7.jpg',
      },
      {
        'name': 'Adidas Ultraboost',
        'price': 18000.0,
        'color': Colors.white,
        'image': 'assets/products/product8.jpg',
      },
      {
        'name': 'Converse Chuck',
        'price': 6500.0,
        'color': Colors.black,
        'image': 'assets/products/product1.jpg',
      },
    ],
    // Hats
    [
      {
        'name': 'Baseball Cap',
        'price': 1500.0,
        'color': Colors.blue,
        'image': 'assets/products/product2.jpg',
      },
      {
        'name': 'Fedora Hat',
        'price': 3500.0,
        'color': Colors.brown,
        'image': 'assets/products/product3.jpg',
      },
      {
        'name': 'Beanie',
        'price': 1200.0,
        'color': Colors.grey,
        'image': 'assets/products/product4.jpg',
      },
    ],
    // Jewelry
    [
      {
        'name': 'Gold Necklace',
        'price': 25000.0,
        'color': Colors.amber,
        'image': 'assets/products/product5.jpg',
      },
      {
        'name': 'Diamond Ring',
        'price': 55000.0,
        'color': Colors.white,
        'image': 'assets/products/product6.jpg',
      },
      {
        'name': 'Pearl Earrings',
        'price': 8500.0,
        'color': Colors.white,
        'image': 'assets/products/product7.jpg',
      },
    ],
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Simulate camera initialization and face detection
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _faceDetected = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('AR Try-On 👓'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _showHelpDialog(),
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Realistic Camera Preview with gradient background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade800,
                  Colors.grey.shade900,
                  Colors.black,
                ],
              ),
            ),
            child: _isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color:
                              _categories[_selectedCategory]['color'] as Color,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Initializing Camera...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      // Simulated camera feed with person silhouette
                      Center(
                        child: Container(
                          width: 180.w,
                          height: 280.h,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.grey.shade700,
                                Colors.grey.shade800,
                                Colors.grey.shade900,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(140.r),
                          ),
                        ),
                      ),
                      // Animated scan lines for realism
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Positioned(
                            top: 100.h + (_pulseController.value * 400.h),
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    (_categories[_selectedCategory]['color']
                                            as Color)
                                        .withOpacity(0.5),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ),

          // Face Detection Guide with pulse animation
          if (!_isLoading)
            Positioned(
              top: 100.h,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Container(
                      width: 200.w + (_pulseController.value * 10),
                      height: 260.h + (_pulseController.value * 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _faceDetected
                              ? Colors.green.withOpacity(
                                  0.6 - _pulseController.value * 0.3,
                                )
                              : Colors.orange.withOpacity(
                                  0.6 - _pulseController.value * 0.3,
                                ),
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(130.r),
                      ),
                      child: Center(
                        child: _faceDetected
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green.withOpacity(0.8),
                                size: 40.sp,
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),

          // Face detection status indicator
          if (!_isLoading)
            Positioned(
              top: 80.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: _faceDetected
                        ? Colors.green.withOpacity(0.9)
                        : Colors.orange.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _faceDetected
                            ? Icons.face
                            : Icons.face_retouching_natural,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _faceDetected ? 'Face Detected ✓' : 'Detecting Face...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // AR Product Overlay with realistic 3D effect
          if (!_isLoading && _faceDetected)
            Positioned(
              top: 150.h + _productPosition.dy,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _productPosition += Offset(
                        details.delta.dx / 2,
                        details.delta.dy / 2,
                      );
                    });
                  },
                  child: Transform.scale(
                    scale: _productScale,
                    child: Transform.rotate(
                      angle: _productRotation,
                      child: _buildRealisticAROverlay(),
                    ),
                  ),
                ),
              ),
            ),

          // AR Controls Overlay
          if (!_isLoading && _faceDetected)
            Positioned(top: 400.h, right: 16.w, child: _buildARControls()),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black.withAlpha(200),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category Selector
                  SizedBox(
                    height: 70.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = index;
                              _selectedProduct = 0;
                              _productPosition = Offset.zero;
                              _productScale = 1.0;
                              _productRotation = 0.0;
                            });
                          },
                          child: Container(
                            width: 70.w,
                            margin: EdgeInsets.only(right: 12.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (category['color'] as Color).withAlpha(100)
                                  : Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: isSelected
                                    ? category['color'] as Color
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  category['icon'] as IconData,
                                  color: isSelected
                                      ? category['color'] as Color
                                      : Colors.grey,
                                  size: 24.sp,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  category['name'] as String,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Product Selector
                  SizedBox(
                    height: 100.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _products[_selectedCategory].length,
                      itemBuilder: (context, index) {
                        final product = _products[_selectedCategory][index];
                        final isSelected = _selectedProduct == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedProduct = index;
                            });
                          },
                          child: Container(
                            width: 90.w,
                            margin: EdgeInsets.only(right: 12.w),
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? _categories[_selectedCategory]['color']
                                          as Color
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        product['image'] as String,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  product['name'] as String,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '৳${(product['price'] as double).toStringAsFixed(0)}',
                                  style: TextStyle(
                                    color: isSelected
                                        ? _categories[_selectedCategory]['color']
                                              as Color
                                        : Colors.grey,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _capturePhoto(),
                          icon: const Icon(Icons.camera),
                          label: const Text('Capture'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _addToCart(),
                          icon: const Icon(Icons.shopping_cart),
                          label: const Text('Add to Cart'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                _categories[_selectedCategory]['color']
                                    as Color,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // Enhanced Camera Controls
          Positioned(
            top: 100.h,
            right: 16.w,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _faceDetected = !_faceDetected;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Camera flipped'),
                          duration: Duration(seconds: 1),
                          backgroundColor:
                              _categories[_selectedCategory]['color'] as Color,
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _productPosition = Offset.zero;
                        _productScale = 1.0;
                        _productRotation = 0.0;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Position reset'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.restart_alt, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealisticAROverlay() {
    final product = _products[_selectedCategory][_selectedProduct];
    final category = _categories[_selectedCategory];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Shadow effect for depth
        Positioned(
          bottom: -20.h,
          left: 10.w,
          right: 10.w,
          child: Container(
            height: 30.h,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(50.r),
            ),
          ),
        ),
        // Main product overlay with 3D effect
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                (category['color'] as Color).withOpacity(0.3),
                (category['color'] as Color).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: category['color'] as Color, width: 3),
            boxShadow: [
              BoxShadow(
                color: (category['color'] as Color).withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(5, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 3D Icon with rotation effect
              Transform(
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(0.1)
                  ..rotateY(-0.1),
                alignment: FractionalOffset.center,
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: category['color'] as Color,
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: Colors.white,
                    size: 40.sp,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              // Product info with glow effect
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    Text(
                      product['name'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: category['color'] as Color,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '৳${(product['price'] as double).toStringAsFixed(0)}',
                      style: TextStyle(
                        color: category['color'] as Color,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.white, blurRadius: 5)],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Glowing particles effect
        ...List.generate(3, (index) {
          return Positioned(
            top: -20.h + (index * 15.h),
            right: -10.w + (index * 10.w),
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.3 + (_pulseController.value * 0.4),
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: category['color'] as Color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: category['color'] as Color,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildARControls() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black45, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          // Scale control
          Column(
            children: [
              Icon(Icons.zoom_in, color: Colors.white, size: 20.sp),
              SizedBox(
                height: 100.h,
                width: 40.w,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                    value: _productScale,
                    min: 0.5,
                    max: 2.0,
                    activeColor:
                        _categories[_selectedCategory]['color'] as Color,
                    onChanged: (value) {
                      setState(() {
                        _productScale = value;
                      });
                    },
                  ),
                ),
              ),
              Icon(Icons.zoom_out, color: Colors.white, size: 20.sp),
            ],
          ),
          SizedBox(height: 16.h),
          // Rotation control
          IconButton(
            onPressed: () {
              setState(() {
                _productRotation += math.pi / 4;
              });
            },
            icon: Icon(Icons.rotate_right, color: Colors.white, size: 24.sp),
          ),
          Text(
            'Rotate',
            style: TextStyle(color: Colors.white70, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }

  void _capturePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📸 Photo saved!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _addToCart() {
    final product = _products[_selectedCategory][_selectedProduct];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Cart'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60.sp),
            SizedBox(height: 16.h),
            Text(
              '${product['name']} added to cart!',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              '৳${(product['price'] as double).toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: _categories[_selectedCategory]['color'] as Color,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How AR Try-On Works?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpStep('1', 'Select a category (Glasses, Watches etc.)'),
            _buildHelpStep('2', 'Select a product'),
            _buildHelpStep('3', 'See yourself in camera'),
            _buildHelpStep('4', 'View product in AR'),
            _buildHelpStep('5', 'Capture photo or add to cart'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpStep(String step, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: _categories[_selectedCategory]['color'] as Color,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 13.sp)),
          ),
        ],
      ),
    );
  }
}
