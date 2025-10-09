import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jihad/const/AppColors.dart';
import 'package:jihad/ui/bottom_nav_controller.dart';

import 'package:jihad/ui/registration_screen.dart';
import 'package:jihad/widgets/customButton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  // Focus nodes for keyboard management
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  signIn() async {
    // First, dismiss the keyboard df
    FocusScope.of(context).unfocus();

    // Validation
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }

    if (!_emailController.text.contains('@')) {
      Fluttertoast.showToast(msg: "Please enter a valid email");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
      );

      if (userCredential.user != null) {
        Fluttertoast.showToast(msg: "Login successful!");
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => BottomNavController()),
              (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Wrong password provided.");
      } else {
        Fluttertoast.showToast(msg: "Error: ${e.message}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _resetPassword() async {
    FocusScope.of(context).unfocus();

    if (_emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your email first");
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      Fluttertoast.showToast(msg: "Password reset email sent!");
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: "Error: ${e.message}");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error sending reset email");
    }
  }

  // Handle keyboard submit action
  void _handleEmailSubmit() {
    // When user presses next/done on email field, focus moves to password
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _handlePasswordSubmit() {
    // When user presses done on password field, attempt to sign in
    signIn();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deep_orange,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside text fields
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              SizedBox(
                height: 150.h,
                width: ScreenUtil().screenWidth,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Sign In",
                        style: TextStyle(fontSize: 22.sp, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
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
                            "Welcome Back",
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: AppColors.deep_orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Glad to see you back!",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Color(0xFFBBBBBB),
                            ),
                          ),
                          SizedBox(height: 30.h),

                          // Email Field
                          Row(
                            children: [
                              Container(
                                height: 48.h,
                                width: 41.w,
                                decoration: BoxDecoration(
                                  color: AppColors.deep_orange,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.email_outlined,
                                    color: Colors.white,
                                    size: 20.w,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: TextField(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onSubmitted: (_) => _handleEmailSubmit(),
                                  decoration: InputDecoration(
                                    hintText: "example@gmail.com",
                                    hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xFF414041),
                                    ),
                                    labelText: 'EMAIL',
                                    labelStyle: TextStyle(
                                      fontSize: 15.sp,
                                      color: AppColors.deep_orange,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          // Password Field
                          Row(
                            children: [
                              Container(
                                height: 48.h,
                                width: 41.w,
                                decoration: BoxDecoration(
                                  color: AppColors.deep_orange,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.lock_outline,
                                    color: Colors.white,
                                    size: 20.w,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  obscureText: _obscureText,
                                  keyboardType: TextInputType.visiblePassword,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => _handlePasswordSubmit(),
                                  decoration: InputDecoration(
                                    hintText: "Enter your password",
                                    hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xFF414041),
                                    ),
                                    labelText: 'PASSWORD',
                                    labelStyle: TextStyle(
                                      fontSize: 15.sp,
                                      color: AppColors.deep_orange,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureText ? Icons.visibility : Icons.visibility_off,
                                        size: 20.w,
                                        color: AppColors.deep_orange,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _resetPassword,
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.deep_orange,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),

                          // Sign In Button
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : customButton("Sign In", signIn),
                          SizedBox(height: 20.h),

                          // Sign Up Link
                          Center(
                            child: Wrap(
                              children: [
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFBBBBBB),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => RegistrationScreen()
                                      ),
                                    );
                                  },
                                  child: Text(
                                    " Sign Up",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.deep_orange,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}