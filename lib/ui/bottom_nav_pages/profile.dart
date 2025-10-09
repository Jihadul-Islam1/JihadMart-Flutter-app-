import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  
  bool _isEditing = false;
  bool _isLoading = true;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadUserData();
  }

  // Firebase থেকে user data load করবে
  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection("users-form-data")
            .doc(_currentUser!.email)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          
          setState(() {
            _nameController.text = data['name'] ?? '';
            _phoneController.text = data['phone'] ?? '';
            _ageController.text = data['age'] ?? '';
            _emailController.text = _currentUser!.email ?? '';
            _isLoading = false;
          });
        } else {
          // যদি user data না থাকে, default values set করবে
          setState(() {
            _nameController.text = '';
            _phoneController.text = '';
            _ageController.text = '';
            _emailController.text = _currentUser!.email ?? '';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Firebase এ user data update করবে
  Future<void> _updateUserData() async {
    try {
      if (_currentUser != null) {
        await FirebaseFirestore.instance
            .collection("users-form-data")
            .doc(_currentUser!.email)
            .set({
          "name": _nameController.text,
          "phone": _phoneController.text,
          "age": _ageController.text,
          "email": _currentUser!.email,
          "updatedAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Profile updated successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        
        setState(() {
          _isEditing = false;
        });
      }
    } catch (e) {
      print("Error updating user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating profile. Please try again."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
    _loadUserData(); // Original data reload করবে
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              FirebaseAuth.instance.signOut();
              // এখানে login screen এ navigate করতে পারো
            },
            child: Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
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
          "My Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          if (!_isEditing && !_isLoading)
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.deep_orange),
              onPressed: _toggleEditing,
              tooltip: "Edit Profile",
            ),
          if (!_isLoading)
            IconButton(
              icon: Icon(Icons.logout, color: Colors.red),
              onPressed: _logout,
              tooltip: "Logout",
            ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator(color: AppColors.deep_orange))
            : Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50.sp,
                            backgroundColor: AppColors.deep_orange.withOpacity(0.2),
                            child: Icon(
                              Icons.person,
                              size: 40.sp,
                              color: AppColors.deep_orange,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            _nameController.text.isEmpty ? "User" : _nameController.text,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            _currentUser?.email ?? "No email",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 30.h),
                    
                    // Profile Information
                    Text(
                      "Personal Information",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    // Name Field
                    _buildProfileField(
                      label: "Full Name",
                      icon: Icons.person,
                      controller: _nameController,
                      isEditing: _isEditing,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Email Field (Read-only)
                    _buildProfileField(
                      label: "Email Address",
                      icon: Icons.email,
                      controller: _emailController,
                      isEditing: false, // Email edit করা যাবে না
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Phone Field
                    _buildProfileField(
                      label: "Phone Number",
                      icon: Icons.phone,
                      controller: _phoneController,
                      isEditing: _isEditing,
                      keyboardType: TextInputType.phone,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Age Field
                    _buildProfileField(
                      label: "Age",
                      icon: Icons.cake,
                      controller: _ageController,
                      isEditing: _isEditing,
                      keyboardType: TextInputType.number,
                    ),
                    
                    Spacer(),
                    
                    // Action Buttons
                    if (_isEditing)
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: _updateUserData,
                              child: Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 16.sp,
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
                          SizedBox(height: 10.h),
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: OutlinedButton(
                              onPressed: _cancelEditing,
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    
                    if (!_isEditing)
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: _toggleEditing,
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontSize: 16.sp,
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
                    
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required bool isEditing,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Icon(icon, color: AppColors.deep_orange, size: 20.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  isEditing
                      ? TextFormField(
                          controller: controller,
                          keyboardType: keyboardType,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        )
                      : Text(
                          controller.text.isEmpty ? "Not set" : controller.text,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
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