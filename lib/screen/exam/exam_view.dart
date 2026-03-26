import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import 'exam_controller.dart';

class ExamView extends StatefulWidget {
  ExamView({super.key}) {
    if (!Get.isRegistered<ExamController>()) {
      Get.put(ExamController());
    }
  }

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {
  var controller = Get.find<ExamController>();

  @override
  void dispose() {
    Get.delete<ExamController>();
    super.dispose();
  }

  // Mock exam data: 0=not started, 1=passed, 2=failed, 3=in progress
  final List<Map<String, dynamic>> examData = [
    {"id": 1, "status": 1, "score": "35/35"},
    {"id": 2, "status": 2, "score": "28/35"},
    {"id": 3, "status": 3, "score": "12/35"},
    {"id": 4, "status": 0, "score": ""},
    {"id": 5, "status": 0, "score": ""},
    {"id": 6, "status": 1, "score": "35/35"},
    {"id": 7, "status": 0, "score": ""},
    {"id": 8, "status": 0, "score": ""},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopHeader(),
            _buildQuickStats(),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                physics: const BouncingScrollPhysics(),
                itemCount: examData.length + 1, // +1 for placeholder
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  if (index == examData.length) {
                    return _buildPlaceholder();
                  }
                  return _buildExamItem(examData[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      color: AppColors.surface,
      alignment: Alignment.centerLeft,
      child: Text(
        "Thi thử bằng lái xe B2",
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard("Tổng đề", "18", AppColors.primary, AppColors.primary.withValues(alpha: 0.1)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard("Đã đạt", "8", AppColors.success, AppColors.successBackground),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard("Chưa đạt", "2", AppColors.error, AppColors.errorBackground),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color textColor, Color bgColor) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamItem(Map<String, dynamic> exam) {
    int id = exam["id"];
    int status = exam["status"]; // 0=none, 1=passed, 2=failed, 3=in progress
    String score = exam["score"];

    // Colors based on status
    Color numberBg, numberColor;
    String statusText;
    Color statusTextColor;
    String buttonText;

    switch (status) {
      case 1: // Passed
        numberBg = AppColors.successBackground;
        numberColor = AppColors.success;
        statusText = "Đã đạt • $score";
        statusTextColor = AppColors.success;
        buttonText = "Làm lại";
        break;
      case 2: // Failed
        numberBg = AppColors.errorBackground;
        numberColor = AppColors.error;
        statusText = "Chưa đạt • $score";
        statusTextColor = AppColors.error;
        buttonText = "Làm lại";
        break;
      case 3: // In Progress
        numberBg = const Color(0xFFFFF7ED); // light orange
        numberColor = const Color(0xFFEA580C); // orange
        statusText = "Đang làm • $score";
        statusTextColor = const Color(0xFFEA580C);
        buttonText = "Tiếp tục";
        break;
      default: // Not Started
        numberBg = AppColors.background;
        numberColor = AppColors.textSecondary;
        statusText = "Chưa làm";
        statusTextColor = AppColors.textSecondary;
        buttonText = "Bắt đầu";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circle number
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: numberBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "$id",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: numberColor,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          // Title + Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bộ đề số $id",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: statusTextColor,
                  ),
                ),
              ],
            ),
          ),
          // Button
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: status == 1 ? Colors.transparent : AppColors.primary,
              foregroundColor: status == 1 ? AppColors.primary : Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
                side: status == 1 ? const BorderSide(color: AppColors.primary) : BorderSide.none,
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 92.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
      ),
      alignment: Alignment.center,
      child: Text(
        "Tiếp tục đến bộ đề 18...",
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textLight,
        ),
      ),
    );
  }
}
