import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import 'traffic_sign_controller.dart';

class TrafficSignView extends StatefulWidget {
  TrafficSignView({super.key}) {
    if (!Get.isRegistered<TrafficSignController>()) {
      Get.put(TrafficSignController());
    }
  }

  @override
  State<TrafficSignView> createState() => _TrafficSignViewState();
}

class _TrafficSignViewState extends State<TrafficSignView> {
  var controller = Get.find<TrafficSignController>();

  @override
  void dispose() {
    Get.delete<TrafficSignController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Biển báo giao thông",
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
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          physics: const BouncingScrollPhysics(),
          itemCount: controller.categoryNames.length,
          itemBuilder: (context, index) {
            final name = controller.categoryNames[index];
            final count = controller.signCount(name);
            final iconData = _iconForCategory(name);
            final color = _colorForCategory(name);
            return _buildTrafficSignCategory(name, "$count biển", iconData, color);
          },
        ),
      ),
    );
  }

  IconData _iconForCategory(String name) {
    if (name.contains("cấm")) return Icons.do_not_disturb_alt_rounded;
    if (name.contains("nguy hiểm")) return Icons.warning_amber_rounded;
    if (name.contains("hiệu lệnh")) return Icons.assistant_direction_rounded;
    if (name.contains("chỉ dẫn")) return Icons.info_outline_rounded;
    if (name.contains("phụ")) return Icons.list_alt_rounded;
    return Icons.traffic_rounded;
  }

  Color _colorForCategory(String name) {
    if (name.contains("cấm")) return AppColors.error;
    if (name.contains("nguy hiểm")) return AppColors.warning;
    if (name.contains("hiệu lệnh")) return AppColors.primary;
    if (name.contains("chỉ dẫn")) return AppColors.secondary;
    if (name.contains("phụ")) return Colors.blueGrey;
    return Colors.teal;
  }

  Widget _buildTrafficSignCategory(String title, String count, IconData icon, Color color) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: null,
      onPressed: () => controller.goToDetail(title),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28.w),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    count,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 20.w),
          ],
        ),
      ),
    );
  }
}
