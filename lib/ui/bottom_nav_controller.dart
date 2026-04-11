import 'package:flutter/material.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/ui/bottom_nav_pages/cart.dart';
import 'package:jihad/ui/bottom_nav_pages/favourite.dart';
import 'package:jihad/ui/bottom_nav_pages/home.dart';
import 'package:jihad/ui/bottom_nav_pages/profile.dart';
import 'package:jihad/ui/bottom_nav_pages/ai_chat.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavController extends StatefulWidget {
  const BottomNavController({super.key});

  @override
  BottomNavControllerState createState() => BottomNavControllerState();
}

class BottomNavControllerState extends State<BottomNavController> {
  final _pages = [Home(), Favourite(), Cart(), AIChatPage(), Profile()];

  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(25),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, "Home"),
            _buildNavItem(1, Icons.favorite, "Favourite"),
            _buildNavItem(2, Icons.shopping_cart, "Cart"),
            _buildNavItem(3, Icons.smart_toy_outlined, "AI"),
            _buildNavItem(4, Icons.person, "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.deepOrange.withAlpha(25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: isSelected ? AppColors.deepOrange : Colors.grey[600],
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.deepOrange : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
