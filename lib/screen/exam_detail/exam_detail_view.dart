import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
            // Show image only when question has images
            if (q.images.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  imageUrl: q.images.first,
                  width: double.infinity,
                  height: 160.h,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 160.h,
                    color: AppColors.border,
                    child: Center(
                      child: SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 160.h,
                    color: AppColors.border,
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 40.w,
                      color: AppColors.textLight,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
            // Question text
            Text(
              q.question,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 16.h),
            // Answer options – use real option text
            ...List.generate(q.options.length, (i) {
              final label = String.fromCharCode(65 + i); // A, B, C, D
              final state = controller.optionVisualState(
                  controller.currentIndex.value, i);
              return _buildAnswerOption(label, q.options[i].text, i, state);
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
    int state, // 0=neutral 1=selected(blue) 2=correct(green) 3=wrong(red)
  ) {
    final Color bgColor;
    final Color borderColor;
    final Color textColor;
    final Color labelBg;

    switch (state) {
      case 1: // selected before submit
        bgColor = AppColors.primary;
        borderColor = AppColors.primary;
        textColor = Colors.white;
        labelBg = Colors.white.withValues(alpha: 0.2);
        break;
      case 2: // correct after submit
        bgColor = AppColors.success;
        borderColor = AppColors.success;
        textColor = Colors.white;
        labelBg = Colors.white.withValues(alpha: 0.2);
        break;
      case 3: // wrong after submit
        bgColor = AppColors.error;
        borderColor = AppColors.error;
        textColor = Colors.white;
        labelBg = Colors.white.withValues(alpha: 0.2);
        break;
      default: // neutral
        bgColor = AppColors.surface;
        borderColor = AppColors.border;
        textColor = AppColors.textPrimary;
        labelBg = AppColors.background;
    }

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: null,
      onPressed: () => controller.selectAnswer(index),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: labelBg,
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor,
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
                  color: textColor,
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
                        final answerState = controller.getAnswerState(i);
                        final isAnswered =
                            controller.selectedAnswers.containsKey(i);

                        Color dotBg;
                        Color dotBorder;
                        Color dotText;

                        if (isCurrent) {
                          dotBg = AppColors.primary;
                          dotBorder = AppColors.primary;
                          dotText = Colors.white;
                        } else if (controller.isSubmitted.value) {
                          if (answerState == 0) {
                            dotBg = AppColors.successBackground;
                            dotBorder = AppColors.success;
                            dotText = AppColors.success;
                          } else if (answerState == 1) {
                            dotBg = AppColors.errorBackground;
                            dotBorder = AppColors.error;
                            dotText = AppColors.error;
                          } else {
                            // skipped
                            dotBg = AppColors.background;
                            dotBorder = AppColors.border;
                            dotText = AppColors.textSecondary;
                          }
                        } else if (isAnswered) {
                          dotBg = AppColors.primary.withValues(alpha: 0.1);
                          dotBorder = AppColors.border;
                          dotText = AppColors.primary;
                        } else {
                          dotBg = AppColors.background;
                          dotBorder = AppColors.border;
                          dotText = AppColors.textSecondary;
                        }

                        return CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: null,
                          onPressed: () => controller.jumpToQuestion(i),
                          child: Container(
                            width: 36.w,
                            height: 36.h,
                            decoration: BoxDecoration(
                              color: dotBg,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: dotBorder),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: dotText,
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
