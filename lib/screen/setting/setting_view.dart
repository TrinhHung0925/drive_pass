import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import 'setting_controller.dart';
import 'dart:io';

class SettingView extends StatefulWidget {
  SettingView({super.key}) {
    if (!Get.isRegistered<SettingController>()) {
      Get.put(SettingController());
    }
  }

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  var controller = Get.find<SettingController>();

  @override
  void dispose() {
    Get.delete<SettingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Cài đặt chung",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(),
              SizedBox(height: 32.h),
              _buildSectionTitle("Cài đặt ứng dụng"),
              SizedBox(height: 12.h),
              _buildSettingGroup([
                Obx(
                  () => _buildSettingItem(
                    "Thông báo",
                    Icons.notifications_active_rounded,
                    AppColors.primary,
                    isToggle: true,
                    toggleValue: controller.isNotificationEnabled.value,
                    onToggleChanged: controller.toggleNotification,
                  ),
                ),
                _buildDivider(),
                Obx(
                  () => _buildSettingItem(
                    "Chế độ tối",
                    Icons.dark_mode_rounded,
                    Colors.indigo,
                    isToggle: true,
                    toggleValue: controller.isDarkMode.value,
                    onToggleChanged: controller.toggleDarkMode,
                  ),
                ),
                _buildDivider(),
                Obx(
                  () => _buildSettingItem(
                    "Nhắc nhở học tập",
                    Icons.alarm_rounded,
                    AppColors.accent,
                    isToggle: true,
                    toggleValue: controller.isReminderEnabled.value,
                    onToggleChanged: controller.toggleReminder,
                  ),
                ),
              ]),
              SizedBox(height: 32.h),
              _buildSectionTitle("Thông tin & Hỗ trợ"),
              SizedBox(height: 12.h),
              _buildSettingGroup([
                _buildSettingItem(
                  "Điều khoản sử dụng",
                  Icons.description_rounded,
                  Colors.blueGrey,
                ),
                _buildDivider(),
                _buildSettingItem(
                  "Gửi phản hồi",
                  Icons.feedback_rounded,
                  AppColors.secondary,
                ),
                _buildDivider(),
                _buildSettingItem(
                  "Đánh giá ứng dụng",
                  Icons.star_rounded,
                  AppColors.warning,
                ),
                _buildDivider(),
                _buildSettingItem(
                  "Giới thiệu (Version 1.0.0)",
                  Icons.info_outline_rounded,
                  AppColors.textSecondary,
                  showArrow: false,
                ),
              ]),
              SizedBox(height: 48.h),
              _buildLogoutButton(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(
            () => Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withValues(alpha: 0.2),
                image: DecorationImage(
                  image: controller.userAvatarPath.value.isNotEmpty
                      ? FileImage(File(controller.userAvatarPath.value))
                            as ImageProvider
                      : const NetworkImage(
                          "https://ui-avatars.com/api/?name=User&background=1E88E5&color=fff",
                        ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.userName.value,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    controller.userPhone.value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: controller.goToEditProfile,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit_rounded,
                color: AppColors.primary,
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSettingGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingItem(
    String title,
    IconData icon,
    Color color, {
    bool isToggle = false,
    bool toggleValue = false,
    bool showArrow = true,
    ValueChanged<bool>? onToggleChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: color, size: 22.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (isToggle)
            SizedBox(
              height: 24.h,
              child: Switch(
                value: toggleValue,
                onChanged: onToggleChanged ?? (val) {},
                activeTrackColor: AppColors.primary,
              ),
            )
          else if (showArrow)
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey.shade400,
              size: 18.w,
            ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Divider(height: 1, color: Colors.grey.withOpacity(0.2)),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: AppColors.error, size: 24.w),
            SizedBox(width: 8.w),
            Text(
              "Đăng xuất",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
