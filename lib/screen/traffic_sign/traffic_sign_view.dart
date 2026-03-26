import 'package:flutter/material.dart';
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
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          physics: const BouncingScrollPhysics(),
          children: [
            _buildTrafficSignCategory(
              "Biển báo nguy hiểm",
              "112 biển",
              Icons.warning_amber_rounded,
              AppColors.warning,
            ),
            _buildTrafficSignCategory(
              "Biển báo cấm",
              "63 biển",
              Icons.do_not_disturb_alt_rounded,
              AppColors.error,
            ),
            _buildTrafficSignCategory(
              "Biển hiệu lệnh",
              "24 biển",
              Icons.assistant_direction_rounded,
              AppColors.primary,
            ),
            _buildTrafficSignCategory(
              "Biển chỉ dẫn",
              "101 biển",
              Icons.info_outline_rounded,
              AppColors.secondary,
            ),
            _buildTrafficSignCategory(
              "Biển phụ",
              "25 biển",
              Icons.list_alt_rounded,
              Colors.blueGrey,
            ),
            _buildTrafficSignCategory(
              "Vạch kẻ đường",
              "20 vạch",
              Icons.edit_road_rounded,
              Colors.brown,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrafficSignCategory(String title, String count, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
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
    );
  }
}
