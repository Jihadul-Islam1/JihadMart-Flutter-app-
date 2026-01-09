import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jihad/ui/login_screen.dart';
import 'package:jihad/ui/bottom_nav_controller.dart';
import 'package:jihad/ui/admin/admin_dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Continuous blinking with scale effect
    _animationController.repeat(reverse: true);

    // Navigate after 3 seconds
    Future.delayed(Duration(seconds: 3), () async {
      if (!mounted) return;
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          // Check if session is valid by reloading user data
          try {
            await user.reload();
            user = FirebaseAuth.instance.currentUser; // Refresh user object
          } catch (e) {
            // If reload fails (e.g. user deleted/disabled), force logout
            await FirebaseAuth.instance.signOut();
            throw Exception("Invalid Session");
          }

          if (user?.email == "admin@gmail.com") {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(builder: (_) => AdminDashboard()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(builder: (_) => BottomNavController()),
            );
          }
        } else {
          throw Exception("User not found");
        }
      } catch (e) {
        // If any error occurs or user not found, go to Login
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 161, 2, 87),
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/logo/logo1.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
