import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jihad/core/config/app_config.dart';
import 'package:jihad/ui/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  bool _startupStarted = false;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_startupStarted) {
        return;
      }
      _startupStarted = true;
      _initializeAndNavigate();
    });
  }

  Future<void> _initializeAndNavigate() async {
    await AppConfig.load();
    debugPrint(
      'AppConfig loaded: IMGBB key present = ${AppConfig.imgbbApiKey.isNotEmpty}',
    );

    try {
      if (kIsWeb) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyAQC9d7XEDX0yS7MhBRNgal3I8AUN0GVgU",
            authDomain: "jihad-ecommerce.firebaseapp.com",
            projectId: "jihad-ecommerce",
            storageBucket: "jihad-ecommerce.firebasestorage.app",
            messagingSenderId: "152901593043",
            appId: "1:152901593043:web:debfea2337ef40d95d3126",
            measurementId: "G-R1343P5P9H",
          ),
        );
      } else {
        await Firebase.initializeApp();
      }
    } catch (e, st) {
      debugPrint('Firebase initialization failed: $e');
      debugPrint('$st');
    }

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (_) => const LoginScreen()),
    );
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Image.asset(
                        'assets/logo/JihadMartlogo.png',
                        width: 270,
                        height: 270,
                        fit: BoxFit.contain,
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
