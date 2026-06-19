import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jihad/const/app_colors.dart';

import 'package:jihad/core/services/user_role_service.dart';
import 'package:jihad/features/admin/presentation/screens/admin_panel_shell.dart';
import 'package:jihad/features/customer/presentation/screens/customer_panel_shell.dart';
import 'package:jihad/features/vendor/presentation/screens/vendor_panel_shell.dart';
import 'package:jihad/features/shared/presentation/screens/role_gate_screen.dart';
import 'package:jihad/ui/email_auth_screen.dart';
import 'package:jihad/ui/phone_auth_screen.dart';
import 'package:jihad/ui/registration_screen.dart';
import 'package:jihad/ui/admin/admin_login_screen.dart';
import 'package:jihad/ui/vendor/vendor_login_screen.dart';
import 'package:jihad/widgets/customButton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jihad/services/social_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Duration _authTimeout = Duration(seconds: 20);
  static const Duration _roleTimeout = Duration(seconds: 5);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  final SocialAuthService _socialAuthService = SocialAuthService();

  // Focus nodes for keyboard management
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  signIn() async {
    // First, dismiss the keyboard df
    FocusScope.of(context).unfocus();

    // Validation
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (!email.contains('@')) {
      Fluttertoast.showToast(msg: "Please enter a valid email");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(_authTimeout);

      final signedInUser = userCredential.user;
      if (signedInUser != null) {
        final role = await UserRoleService.resolveRole(
          signedInUser,
        ).timeout(_roleTimeout, onTimeout: () => AppRole.customer);
        if (!mounted) return;

        Fluttertoast.showToast(msg: "Login successful!");
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (_) {
              switch (role) {
                case AppRole.admin:
                  return const AdminPanelShell();
                case AppRole.vendor:
                  return const VendorPanelShell();
                case AppRole.customer:
                  return const CustomerPanelShell();
                case AppRole.guest:
                  return const CustomerPanelShell();
              }
            },
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Wrong password provided.");
      } else if (e.code == 'invalid-credential') {
        Fluttertoast.showToast(msg: "Invalid email or password.");
      } else if (e.code == 'network-request-failed') {
        Fluttertoast.showToast(msg: "No internet or Firebase network error.");
      } else {
        Fluttertoast.showToast(msg: "${e.code}: ${e.message}");
      }
    } on TimeoutException {
      Fluttertoast.showToast(
        msg: "Login timed out. Please check your internet connection.",
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Login error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _googleSignIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _socialAuthService.signInWithGoogle();
      if (user != null) {
        Fluttertoast.showToast(msg: "Google Login Successful!");
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => const RoleGateScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Google login error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _facebookSignIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _socialAuthService.signInWithFacebook();
      if (user != null) {
        Fluttertoast.showToast(msg: "Facebook Login Successful!");
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => const RoleGateScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Facebook login error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
      backgroundColor: AppColors.deepOrange,
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
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
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
                              color: AppColors.deepOrange,
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
                                  color: AppColors.deepOrange,
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
                                      color: AppColors.deepOrange,
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
                                  color: AppColors.deepOrange,
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
                                      color: AppColors.deepOrange,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      icon: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        size: 20.w,
                                        color: AppColors.deepOrange,
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
                                  color: AppColors.deepOrange,
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

                          // Social Login Divider
                          Row(
                            children: [
                              Expanded(child: Divider(color: Colors.grey)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text(
                                  "OR",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.grey)),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          // Social Login Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google Button
                              GestureDetector(
                                onTap: _googleSignIn,
                                child: Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.g_mobiledata,
                                        size: 30.sp,
                                        color: Colors.red,
                                      ), // Using Icon as placeholder
                                      SizedBox(width: 5.w),
                                      Text(
                                        "Google",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.w),

                              // Facebook Button
                              GestureDetector(
                                onTap: _facebookSignIn,
                                child: Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.facebook,
                                        size: 30.sp,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "Facebook",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),

                          // Email OTP Button
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => EmailAuthScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.email,
                                color: AppColors.deepOrange,
                              ),
                              label: Text(
                                "Login with Email OTP",
                                style: TextStyle(
                                  color: AppColors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // Phone Login Button
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => PhoneAuthScreen(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.phone,
                                color: AppColors.deepOrange,
                              ),
                              label: Text(
                                "Login with Phone",
                                style: TextStyle(
                                  color: AppColors.deepOrange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),

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
                                        builder: (context) =>
                                            RegistrationScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    " Sign Up",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.deepOrange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20.h),
                          Center(
                            child: Wrap(
                              spacing: 10.w,
                              runSpacing: 8.h,
                              alignment: WrapAlignment.center,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) =>
                                            const VendorLoginScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.storefront_outlined),
                                  label: const Text('Vendor Login'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF167D6A),
                                    side: const BorderSide(
                                      color: Color(0xFF167D6A),
                                    ),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (_) =>
                                            const AdminLoginScreen(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.admin_panel_settings_outlined,
                                  ),
                                  label: const Text('Admin Login'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.deepOrange,
                                    side: BorderSide(
                                      color: AppColors.deepOrange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
