import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashView extends StatefulWidget {
  SplashView({super.key}) {
    if (!Get.isRegistered<SplashController>()) {
      Get.put(SplashController());
    }
  }

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  var controller = Get.find<SplashController>();

  @override
  void dispose() {
    Get.delete<SplashController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Requested Red
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Standard car icon placeholder for an aesthetic look
            Icon(
              Icons.directions_car_filled_rounded,
              size: 100.w,
              color: Colors.white,
            ),
            SizedBox(height: 20.h),
            Text(
              "DRIVE PASS",
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 4.w,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Onboard to your journey",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
                letterSpacing: 1.w,
              ),
            ),
            SizedBox(height: 60.h),
            SizedBox(
              width: 40.w,
              height: 40.w,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            )
          ],
        ),
      ),
    );
  }
}
