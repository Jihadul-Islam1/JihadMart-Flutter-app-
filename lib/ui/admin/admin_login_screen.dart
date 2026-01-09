import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:jihad/ui/admin/admin_dashboard.dart';
import 'package:jihad/widgets/customButton.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  signInAdmin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }

    // Hardcoded check for Admin
    if (_emailController.text.trim().toLowerCase() == "admin@gmail.com" &&
        _passwordController.text.trim() == "admin1") {
      setState(() {
        _isLoading = true;
      });

      try {
        // Authenticate with Firebase to ensure we have a valid user session
        // We use the specific admin credentials
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: "admin@gmail.com",
            password: "admin1",
          );
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            // Create if not exists
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: "admin@gmail.com",
              password: "admin1",
            );
          } else {
            // If wrong password for existing account or other error
            Fluttertoast.showToast(msg: "Firebase Auth Error: ${e.message}");
            // We might still want to allow access if it's just a password mismatch on firebase
            // but correct hardcoded pass? No, let's keep it synced.
            setState(() {
              _isLoading = false;
            });
            return;
          }
        }

        Fluttertoast.showToast(msg: "Welcome Admin!");
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => AdminDashboard()),
          (route) => false,
        );
      } catch (e) {
        Fluttertoast.showToast(msg: "Something went wrong: $e");
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Invalid Admin Credentials");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deep_orange,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 100.h),
            Text(
              "Admin Panel",
              style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Container(
                width: ScreenUtil().screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.r),
                    topRight: Radius.circular(28.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          "Admin Login",
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: AppColors.deep_orange,
                          ),
                        ),
                        SizedBox(height: 20.h),

                        // Email Field
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "admin@gmail.com",
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        SizedBox(height: 10.h),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: "admin1",
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 40.h),

                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : customButton(
                                "Login as Admin",
                                () => signInAdmin(),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
