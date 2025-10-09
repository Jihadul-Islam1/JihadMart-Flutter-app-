import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jihad/utils/cart_service.dart'; // Import the new service
import 'package:jihad/ui/bottom_nav_controller.dart'; 

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<Map<String, dynamic>> get _cartItems {
    return CartService.getCartItems();
  }

  double get _totalPrice {
    return CartService.getTotalPrice();
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity']++;
      _updateCart();
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
      } else {
        _removeItem(index);
        return;
      }
      _updateCart();
    });
  }

  void _removeItem(int index) {
    setState(() {
      String itemName = _cartItems[index]['name'];
      CartService.removeFromCart(index);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$itemName removed from cart"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _clearCart() {
    setState(() {
      CartService.clearCart();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cart cleared"),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _updateCart() {
    // Cart is automatically updated through CartService
  }

  void _checkout() {
    if (_cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Your cart is empty"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Order Confirmation"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total Amount: \$$_totalPrice"),
            SizedBox(height: 10),
            Text("Number of items: ${_cartItems.length}"),
            SizedBox(height: 10),
            Text("Proceed with checkout?"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                CartService.clearCart();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Order placed successfully!"),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: Text("Confirm Order"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deep_orange,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "My Cart",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          if (_cartItems.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _clearCart,
              tooltip: "Clear Cart",
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Cart Items Count
            if (_cartItems.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Items in cart: ${_cartItems.length}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Total: \$$_totalPrice",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.deep_orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            // Cart Items List
            Expanded(
              child: _cartItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 80.sp,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "Your cart is empty",
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Add some products to your cart",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[400],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavController(), // তোমার main navigation
      ),
    );
                            },
                            child: Text("Continue Shopping"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.deep_orange,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 12.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.only(bottom: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              children: [
                                // Product Image
                                Container(
                                  width: 80.w,
                                  height: 80.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: AssetImage(item['images'][0]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                
                                // Product Details and Controls
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "\$${item['price']}",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppColors.deep_orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      
                                      // Quantity Controls
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.remove, size: 18.sp),
                                                  onPressed: () => _decrementQuantity(index),
                                                  padding: EdgeInsets.zero,
                                                  constraints: BoxConstraints(),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12.w,
                                                    vertical: 4.h,
                                                  ),
                                                  child: Text(
                                                    item['quantity'].toString(),
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.add, size: 18.sp),
                                                  onPressed: () => _incrementQuantity(index),
                                                  padding: EdgeInsets.zero,
                                                  constraints: BoxConstraints(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Spacer(),
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => _removeItem(index),
                                            tooltip: "Remove item",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            
            // Checkout Section
            if (_cartItems.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount:",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "\$$_totalPrice",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.deep_orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: _checkout,
                        child: Text(
                          "Proceed to Checkout",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deep_orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
}