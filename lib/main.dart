import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jihad/ui/splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true, // লেখা যেন খুব বেশি ছোট বা বড় না হয়
      splitScreenMode: true, // Split screen সাপোর্ট করার জন্য
      builder: (context, child) { // builder-এর প্যারামিটারগুলো ব্যবহার করা ভালো অভ্যাস
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