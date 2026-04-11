import 'package:email_otp/email_otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jihad/core/config/app_config.dart';
import 'package:jihad/const/app_colors.dart';
import 'package:jihad/features/shared/presentation/screens/role_gate_screen.dart';

class EmailAuthScreen extends StatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  _EmailAuthScreenState createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isOTPSent = false;
  bool _hasConfiguredOtp = false;

  // Send OTP
  Future<void> _sendOTP() async {
    if (_emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter email address");
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
      await AppConfig.load();

      final smtpHost = AppConfig.emailOtpSmtpHost.trim();
      final smtpUsername = AppConfig.emailOtpSmtpUsername.trim();
      final smtpPassword = AppConfig.emailOtpSmtpPassword.trim();
      final appEmail = AppConfig.emailOtpAppEmail.trim();

      if (smtpHost.isEmpty || smtpUsername.isEmpty || smtpPassword.isEmpty || appEmail.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
          msg: 'Email OTP SMTP config missing. Set EMAIL_OTP_APP_EMAIL, EMAIL_OTP_SMTP_HOST, EMAIL_OTP_SMTP_USERNAME, and EMAIL_OTP_SMTP_PASSWORD.',
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }

      EmailOTP.config(
        appName: AppConfig.emailOtpAppName.isEmpty ? 'Jihad Mart' : AppConfig.emailOtpAppName,
        appEmail: appEmail,
        otpLength: 6,
        otpType: OTPType.numeric,
      );

      final secureType = switch (AppConfig.emailOtpSmtpSecureType.toLowerCase()) {
        'ssl' => SecureType.ssl,
        'none' => SecureType.none,
        _ => SecureType.tls,
      };

      EmailOTP.setSMTP(
        emailPort: AppConfig.emailOtpSmtpPort == 465
            ? EmailPort.port465
            : (AppConfig.emailOtpSmtpPort == 25 ? EmailPort.port25 : EmailPort.port587),
        secureType: secureType,
        host: smtpHost,
        username: smtpUsername,
        password: smtpPassword,
      );

      _hasConfiguredOtp = true;

      final bool result = await EmailOTP.sendOTP(
        email: _emailController.text.trim(),
      );

      if (result) {
        setState(() {
          _isOTPSent = true;
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: "OTP Sent to your email!");
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: "Failed to send OTP. Try again.");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  // Verify OTP
  Future<void> _verifyOTP() async {
    if (_otpController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter OTP");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (!_hasConfiguredOtp) {
        Fluttertoast.showToast(msg: 'Please send OTP first.');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final bool result = await EmailOTP.verifyOTP(otp: _otpController.text);

      if (result) {
        Fluttertoast.showToast(msg: "Email Verified Successfully!");

        // Since we can't "Login" to Firebase with just OTP (without password),
        // We will redirect to Registration Screen to complete profile
        // Or if you want to simulate login, you can go to Home.
        // Here we go to Home for demo purposes.

        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (_) => const RoleGateScreen()),
          (route) => false,
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: "Invalid OTP");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error verifying OTP: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepOrange,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 150.h,
              width: ScreenUtil().screenWidth,
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    Text(
                      "Email OTP Login",
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
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        _isOTPSent ? "Enter OTP" : "Enter Email Address",
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: AppColors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        _isOTPSent
                            ? "We have sent a 6-digit code to ${_emailController.text}"
                            : "We will send an OTP to verify your email",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.h),

                      if (!_isOTPSent)
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "example@gmail.com",
                            labelText: "Email Address",
                            prefixIcon: Icon(
                              Icons.email,
                              color: AppColors.deepOrange,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        )
                      else
                        TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            hintText: "123456",
                            labelText: "OTP",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: AppColors.deepOrange,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),

                      SizedBox(height: 30.h),

                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : (_isOTPSent ? _verifyOTP : _sendOTP),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  _isOTPSent ? "Verify OTP" : "Send OTP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                  ),
                                ),
                        ),
                      ),
                    ],
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
