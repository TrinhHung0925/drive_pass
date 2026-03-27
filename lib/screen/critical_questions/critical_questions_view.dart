import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import 'critical_questions_controller.dart';

class CriticalQuestionsView extends StatefulWidget {
  CriticalQuestionsView({super.key}) {
    if (!Get.isRegistered<CriticalQuestionsController>()) {
      Get.put(CriticalQuestionsController());
    }
  }

  @override
  State<CriticalQuestionsView> createState() => _CriticalQuestionsViewState();
}

class _CriticalQuestionsViewState extends State<CriticalQuestionsView> {
  var controller = Get.find<CriticalQuestionsController>();

  @override
  void dispose() {
    Get.delete<CriticalQuestionsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: null,
          onPressed: controller.goBack,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.w,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          "Câu điểm liệt",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          children: [
            _buildWarningCard(),
            SizedBox(height: 16.h),
            _buildProgressCard(),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Danh sách câu hỏi",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: null,
                  onPressed: controller.filterQuestions,
                  child: Row(
                    children: [
                      Text(
                        "Lọc",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        color: AppColors.primary,
                        size: 20.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            _buildQuestionList(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: Colors.white,
              size: 20.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "60 Câu hỏi điểm liệt - Cực kỳ quan trọng!",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.red.shade800,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Sai chỉ 1 câu này trong bài thi thực tế, bạn sẽ bị truất quyền sát hạch ngay lập tức.",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "TIẾN ĐỘ ÔN TẬP",
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              Obx(
                () => RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${controller.completed.value}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.red.shade600,
                        ),
                      ),
                      TextSpan(
                        text: " /${controller.total.value} câu",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Obx(() {
            final progress = controller.total.value > 0
                ? controller.completed.value / controller.total.value
                : 0.0;
            return ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8.h,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade500),
              ),
            );
          }),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                color: Colors.red.shade400,
                size: 14.w,
              ),
              SizedBox(width: 6.w),
              Obx(
                () => Text(
                  "Cần hoàn thành ${controller.total.value - controller.completed.value} câu còn lại",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case "warning":
        return Icons.star_rounded;
      case "local_bar":
        return Icons.local_bar_rounded;
      case "speed":
        return Icons.speed_rounded;
      case "train":
        return Icons.train_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  Widget _buildQuestionList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.questions.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final item = controller.questions[index];
        final id = item.id;
        final text = item.text;
        final status = item.status;
        final tag = item.tag;
        final iconName = item.icon;

        final isDone = status == "ĐÃ THUỘC";

        return CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: null,
          onPressed: () => controller.openQuestion(id),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "Câu $id",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: isDone
                              ? AppColors.primary
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Icon(
                      _getIcon(iconName),
                      size: 14.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      tag,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16.w,
                      color: AppColors.textLight,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
