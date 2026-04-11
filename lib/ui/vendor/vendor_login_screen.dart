import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jihad/core/services/user_role_service.dart';
import 'package:jihad/features/shared/presentation/screens/role_gate_screen.dart';
import 'package:jihad/ui/admin/admin_login_screen.dart';

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({super.key});

  @override
  State<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  Future<void> _signInVendor() async {
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill all fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final role = await UserRoleService.resolveCurrentRole();
      if (role == AppRole.vendor) {
        if (!mounted) return;
        Fluttertoast.showToast(msg: 'Vendor login successful!');
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => const RoleGateScreen()),
          (route) => false,
        );
        return;
      }

      await FirebaseAuth.instance.signOut();
      if (!mounted) return;

      if (role == AppRole.admin) {
        Fluttertoast.showToast(msg: 'This account is admin. Use Admin Login.');
      } else {
        Fluttertoast.showToast(
          msg: 'This account is not approved as vendor yet.',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'No user found for that email');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Wrong password provided');
      } else {
        Fluttertoast.showToast(msg: 'Error: ${e.message}');
      }
     } catch (e) {
       Fluttertoast.showToast(msg: 'Something went wrong: $e');
     } finally {
       if (mounted) {
         setState(() {
           _isLoading = false;
         });
       }
     }
   }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0E2E28), Color(0xFF0A1A17)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Vendor Access',
                  style: TextStyle(
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Login with your approved seller account to manage products and orders.',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 24.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Vendor Email',
                          prefixIcon: Icon(Icons.alternate_email_outlined),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _signInVendor,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF167D6A),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          icon: _isLoading
                              ? SizedBox(
                                  width: 18.w,
                                  height: 18.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.storefront_outlined),
                          label: Text(_isLoading ? 'Signing in...' : 'Login as Vendor'),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const AdminLoginScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.admin_panel_settings_outlined),
                        label: const Text('Switch to Admin Login'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Colors.white70),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Not a vendor yet? Use "Become a Seller" from customer profile.',
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
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
    );
  }
}
