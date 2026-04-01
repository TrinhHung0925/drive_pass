import 'package:drive_pass/service/data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import 'exam_controller.dart';
import '../../model/exam_item.dart';

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            color: AppColors.surface,
            child: SafeArea(
              bottom: false,
              child: _buildTopHeader(),
            ),
          ),
          _buildQuickStats(),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              physics: const BouncingScrollPhysics(),
              itemCount: DataLocal.listExam.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                return _buildExamItem(DataLocal.listExam[index]);
              },
            ),
          ),
        ],
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
            child: _buildStatCard(
              "Tổng đề",
              "18",
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              "Đã đạt",
              "8",
              AppColors.success,
              AppColors.successBackground,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              "Chưa đạt",
              "2",
              AppColors.error,
              AppColors.errorBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color textColor,
    Color bgColor,
  ) {
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

  Widget _buildExamItem(ExamItem exam) {


    Color numberBg, numberColor;
    String statusText;
    Color statusTextColor;
    String buttonText;
    int status = exam.examNo;

    switch (status) {
      case 1: // Passed
        numberBg = AppColors.successBackground;
        numberColor = AppColors.success;
        statusText = "Đã đạt • 10/30";
        statusTextColor = AppColors.success;
        buttonText = "Làm lại";
        break;
      case 2: // Failed
        numberBg = AppColors.errorBackground;
        numberColor = AppColors.error;
        statusText = "Chưa đạt • 10/30";
        statusTextColor = AppColors.error;
        buttonText = "Làm lại";
        break;
      case 3:
        numberBg = const Color(0xFFFFF7ED);
        numberColor = const Color(0xFFEA580C);
        statusText = "Đang làm • 10/30";
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

    return CupertinoButton(
      onPressed: () {
        controller.goToExamDetail();
      },
      padding: EdgeInsets.zero,
      minSize: null,
      child: Container(
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
                "${exam.examNo}",
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
                    "Bộ đề số ${exam.examNo}",
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: status == 1 ? Colors.transparent : AppColors.primary,
                borderRadius: BorderRadius.circular(8.r),
                border: status == 1
                    ? Border.all(color: AppColors.primary)
                    : null,
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: status == 1 ? AppColors.primary : Colors.white,
                ),
              ),
            ),
          ],
        ),
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
