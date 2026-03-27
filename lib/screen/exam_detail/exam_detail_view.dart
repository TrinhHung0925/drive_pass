import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import 'exam_detail_controller.dart';

class ExamDetailView extends StatefulWidget {
  ExamDetailView({super.key}) {
    if (!Get.isRegistered<ExamDetailController>()) {
      Get.put(ExamDetailController());
    }
  }

  @override
  State<ExamDetailView> createState() => _ExamDetailViewState();
}

class _ExamDetailViewState extends State<ExamDetailView> {
  var controller = Get.find<ExamDetailController>();

  @override
  void dispose() {
    Get.delete<ExamDetailController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTimerRow(),
            _buildProgressRow(),
            Expanded(child: _buildQuestionCard()),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  // ─────────────────── APP BAR ────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: null,
              onPressed: controller.onBack,
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16.w,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => Text(
                  'Câu ${controller.currentIndex.value + 1}/${controller.questions.length}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            Obx(
              () => CupertinoButton(
                onPressed: controller.isSubmitted.value
                    ? null
                    : controller.submitExam,
                padding: EdgeInsets.zero,
                minSize: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Nộp bài',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }

  // ─────────────────── TIMER ──────────────────────────────────────────────
  Widget _buildTimerRow() {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimeUnit(controller.timerMinutes, 'Phút'),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                ':',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            _buildTimeUnit(controller.timerSeconds, 'Giây'),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Column(
      children: [
        Container(
          width: 56.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // ─────────────────── PROGRESS BAR ───────────────────────────────────────
  Widget _buildProgressRow() {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Column(
        children: [
          Obx(() {
            final answered = controller.selectedAnswers.length;
            final total = controller.questions.length;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tiến độ hoàn thành',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$answered / $total câu',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            );
          }),
          SizedBox(height: 8.h),
          Obx(() {
            final answered = controller.selectedAnswers.length;
            final total = controller.questions.length;
            return ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : answered / total,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
                minHeight: 6.h,
              ),
            );
          }),
        ],
      ),
    );
  }

  // ─────────────────── QUESTION CARD ──────────────────────────────────────
  Widget _buildQuestionCard() {
    return Obx(() {
      final q = controller.questions[controller.currentIndex.value];
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              width: double.infinity,
              height: 160.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 48.w,
                  color: AppColors.textLight,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Question text
            Text(
              q.text,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 16.h),
            // Answer options
            ...List.generate(q.options.length, (i) {
              final label = String.fromCharCode(65 + i); // A, B, C, D
              final isSelected =
                  controller.selectedAnswers[controller.currentIndex.value] ==
                  i;
              return _buildAnswerOption(label, q.options[i], i, isSelected);
            }),
          ],
        ),
      );
    });
  }

  Widget _buildAnswerOption(
    String label,
    String text,
    int index,
    bool isSelected,
  ) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: null,
      onPressed: () => controller.selectAnswer(index),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── BOTTOM SECTION ─────────────────────────────────────
  Widget _buildBottomSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: 30),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nav buttons row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: controller.currentIndex.value > 0
                          ? controller.goToPrevious
                          : null,
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 14.w,
                        color: AppColors.textSecondary,
                      ),
                      label: Text(
                        'Trở lại',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CupertinoButton(
                      onPressed:
                          controller.currentIndex.value <
                              controller.questions.length - 1
                          ? controller.goToNext
                          : null,
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Tiếp theo',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14.w,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // // Question number grid
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Danh sách câu hỏi',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                SizedBox(
                  height: 36.h,
                  child: ListView.separated(
                    controller: controller.scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.questions.length,
                    separatorBuilder: (_, __) => SizedBox(width: 6.w),
                    itemBuilder: (context, i) {
                      return Obx(() {
                        final isCurrent = controller.currentIndex.value == i;
                        final isAnswered = controller.selectedAnswers
                            .containsKey(i);
                        return CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: null,
                          onPressed: () => controller.jumpToQuestion(i),
                          child: Container(
                            width: 36.w,
                            height: 36.h,
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? AppColors.primary
                                  : isAnswered
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: isCurrent
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: isCurrent
                                    ? Colors.white
                                    : isAnswered
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
