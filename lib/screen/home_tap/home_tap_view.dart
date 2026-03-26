import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import '../../resource/app_resource.dart';
import 'home_tap_controller.dart';
import '../home/home_view.dart';
import '../exam/exam_view.dart';
import '../traffic_sign/traffic_sign_view.dart';
import '../setting/setting_view.dart';

class HomeTapView extends StatefulWidget {
  HomeTapView({super.key}) {
    if (!Get.isRegistered<HomeTapController>()) {
      Get.put(HomeTapController());
    }
  }

  @override
  State<HomeTapView> createState() => _HomeTapViewState();
}

class _HomeTapViewState extends State<HomeTapView> {
  var controller = Get.find<HomeTapController>();

  final List<Widget> _pages = [
    HomeView(),
    ExamView(),
    TrafficSignView(),
    SettingView(),
  ];

  @override
  void dispose() {
    Get.delete<HomeTapController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: IndexedStack(
        index: controller.selectedIndex.value,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: SafeArea(
          child: Container(
            height: 60.h,
            padding: EdgeInsets.only(top: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Img.icNavHome, 'Trang chủ'),
                _buildNavItem(1, Img.icNavExam, 'Thi thử'),
                _buildNavItem(2, Img.icNavSign, 'Biển báo'),
                _buildNavItem(3, Img.icNavProfile, 'Cá nhân'),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    bool isActive = controller.selectedIndex.value == index;
    Color color = isActive ? AppColors.primary : AppColors.textSecondary;

    return GestureDetector(
      onTap: () => controller.changeTabIndex(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 83.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 20.w,
              height: 20.w,
              color: color,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
