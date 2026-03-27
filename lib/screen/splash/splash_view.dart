import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../resource/app_colors.dart';
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
      backgroundColor: AppColors.background, // Match Figma's light background #F6F7F8
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Icon
                Container(
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.directions_car_filled_rounded,
                    size: 80.w,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 32.h),
                
                // Main Title
                Text(
                  "GPLX B2",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: 1.w,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                
                // Subtitle
                Text(
                  "Học lái xe thông minh",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5.w,
                  ),
                ),
                SizedBox(height: 60.h),
                
                // Loading Indicator
                SizedBox(
                  width: 80.w,
                  height: 80.w,
                  child: Lottie.asset(
                    'assets/loading.json',
                    fit: BoxFit.contain,
                  ),
                )
              ],
            ),
          ),
          
          // Version Text at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 40.h,
            child: Center(
              child: Text(
                "Phiên bản 2.4.0",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
