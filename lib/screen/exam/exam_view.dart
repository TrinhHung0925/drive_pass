import 'package:drive_pass/service/data_local.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
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
    return FocusDetector(
      onFocusGained: controller.loadHistory,
      child: Scaffold(
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
                padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
    return Obx(() => Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              "Tổng đề",
              "${DataLocal.listExam.length}",
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              "Đã đạt",
              "${controller.passedCount}",
              AppColors.success,
              AppColors.successBackground,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildStatCard(
              "Chưa đạt",
              "${controller.failedCount}",
              AppColors.error,
              AppColors.errorBackground,
            ),
          ),
        ],
      ),
    ));
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
    return Obx((){
      final history = controller.examHistory[exam.examNo];

      final Color numberBg;
      final Color numberColor;
      final String statusText;
      final Color statusTextColor;
      final String buttonText;
      final bool isPassed;

      if (history == null) {
        // Not yet attempted
        numberBg = AppColors.background;
        numberColor = AppColors.textSecondary;
        statusText = 'Chưa làm';
        statusTextColor = AppColors.textSecondary;
        buttonText = 'Bắt đầu';
        isPassed = false;
      } else if (history.passed) {
        numberBg = AppColors.successBackground;
        numberColor = AppColors.success;
        statusText = 'Đã đạt  •  ${history.correct}/${history.total} câu';
        statusTextColor = AppColors.success;
        buttonText = 'Làm lại';
        isPassed = true;
      } else {
        numberBg = AppColors.errorBackground;
        numberColor = AppColors.error;
        statusText = 'Chưa đạt  •  ${history.correct}/${history.total} câu';
        statusTextColor = AppColors.error;
        buttonText = 'Làm lại';
        isPassed = false;
      }

      return CupertinoButton(
        onPressed: () => controller.goToExamDetail(exam.examNo),
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
                  '${exam.examNo}',
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
                      'Bộ đề số ${exam.examNo}',
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
                  color: isPassed ? Colors.transparent : AppColors.primary,
                  borderRadius: BorderRadius.circular(8.r),
                  border: isPassed ? Border.all(color: AppColors.primary) : null,
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: isPassed ? AppColors.primary : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

}
