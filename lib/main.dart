import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jihad/ui/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables from .env (non-fatal if missing)
  try {
    await dotenv.load(fileName: ".env");
  } catch (_) {}
  // On web, Firebase.initializeApp requires explicit FirebaseOptions.
  // Without this, the app can fail to start and show a blank screen.
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
    // Ensure the app still runs even if Firebase fails to init, and log the error.
    debugPrint('Firebase initialization failed: $e');
    debugPrint('$st');
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true, // লেখা যেন খুব বেশি ছোট বা বড় না হয়
      splitScreenMode: true, // Split screen সাপোর্ট করার জন্য
      builder: (context, child) {
        // builder-এর প্যারামিটারগুলো ব্যবহার করা ভালো অভ্যাস
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter E-Commerce',
          theme: ThemeData(
            // Material 3 থিম ব্যবহার করা হচ্ছে
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            useMaterial3: true,
            // আপনি চাইলে এখানে অন্যান্য থিম ডেটাও যোগ করতে পারেন
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
