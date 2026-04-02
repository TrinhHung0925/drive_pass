import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../resource/app_colors.dart';
import 'random_practice_controller.dart';

class RandomPracticeView extends StatefulWidget {
  RandomPracticeView({super.key}) {
    if (!Get.isRegistered<RandomPracticeController>()) {
      Get.put(RandomPracticeController());
    }
  }

  @override
  State<RandomPracticeView> createState() => _RandomPracticeViewState();
}

class _RandomPracticeViewState extends State<RandomPracticeView> {
  var controller = Get.find<RandomPracticeController>();

  @override
  void dispose() {
    Get.delete<RandomPracticeController>();
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
            // Score bar
            _buildScoreBar(),
            Expanded(child: _buildQuestionCard()),
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

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
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 0,
              onPressed: controller.onBack,
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.arrow_back_ios_new_rounded, size: 16.w, color: AppColors.textPrimary),
              ),
            ),
            Expanded(
              child: Obx(() => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Luyện nhanh",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Câu ${controller.currentIndex.value + 1}/${controller.questions.length}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                  ),
                ],
              )),
            ),
            Obx(() => CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 0,
              onPressed: controller.toggleBookmark,
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: controller.isCurrentBookmarked.value
                      ? AppColors.accent.withValues(alpha: 0.15)
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  controller.isCurrentBookmarked.value ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  size: 18.w,
                  color: controller.isCurrentBookmarked.value ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
            )),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }

  Widget _buildScoreBar() {
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, size: 16.w, color: AppColors.success),
          SizedBox(width: 4.w),
          Text(
            '${controller.correctCount.value}',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.success),
          ),
          SizedBox(width: 16.w),
          Icon(Icons.cancel_rounded, size: 16.w, color: AppColors.error),
          SizedBox(width: 4.w),
          Text(
            '${controller.answeredCount.value - controller.correctCount.value}',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.error),
          ),
          SizedBox(width: 16.w),
          Icon(Icons.pending_outlined, size: 16.w, color: AppColors.textLight),
          SizedBox(width: 4.w),
          Text(
            '${controller.questions.length - controller.answeredCount.value}',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
          ),
        ],
      ),
    ));
  }

  Widget _buildQuestionCard() {
    return Obx(() {
      final q = controller.questions[controller.currentIndex.value];
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (q.images.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  imageUrl: q.images.first,
                  width: double.infinity,
                  height: 160.h,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(height: 160.h, color: AppColors.border, child: const Center(child: CircularProgressIndicator(strokeWidth: 2))),
                  errorWidget: (_, __, ___) => Container(height: 160.h, color: AppColors.border, child: Icon(Icons.broken_image_outlined, size: 40.w, color: AppColors.textLight)),
                ),
              ),
              SizedBox(height: 16.h),
            ],
            Text(q.question, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.5)),
            SizedBox(height: 16.h),
            ...List.generate(q.options.length, (i) {
              final label = String.fromCharCode(65 + i);
              final state = controller.optionVisualState(i);
              return _buildAnswerOption(label, q.options[i].text, i, state);
            }),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: controller.showAnswer.value
                  ? Padding(padding: EdgeInsets.only(top: 12.h), child: _buildSuggestBox(q.suggest))
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAnswerOption(String label, String text, int index, int state) {
    final Color bgColor, borderColor, textColor, labelBg;
    switch (state) {
      case 2:
        bgColor = AppColors.success; borderColor = AppColors.success;
        textColor = Colors.white; labelBg = Colors.white.withValues(alpha: 0.2);
        break;
      case 3:
        bgColor = AppColors.error; borderColor = AppColors.error;
        textColor = Colors.white; labelBg = Colors.white.withValues(alpha: 0.2);
        break;
      default:
        bgColor = AppColors.surface; borderColor = AppColors.border;
        textColor = AppColors.textPrimary; labelBg = AppColors.background;
    }
    return CupertinoButton(
      padding: EdgeInsets.zero, minSize: 0,
      onPressed: () => controller.selectAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10.r), border: Border.all(color: borderColor, width: 1.5)),
        child: Row(children: [
          Container(
            width: 32.w, height: 32.w,
            decoration: BoxDecoration(color: labelBg, borderRadius: BorderRadius.circular(8.r)),
            alignment: Alignment.center,
            child: Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: textColor)),
          ),
          SizedBox(width: 12.w),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: textColor))),
        ]),
      ),
    );
  }

  Widget _buildSuggestBox(String suggest) {
    final hasContent = suggest.trim().isNotEmpty;
    return Container(
      width: double.infinity, padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(Icons.lightbulb_rounded, color: AppColors.primary, size: 18.w),
          SizedBox(width: 6.w),
          Text('Giải thích', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.primary)),
        ]),
        SizedBox(height: 8.h),
        Text(hasContent ? suggest : 'Chưa có lời giải cho câu hỏi này.',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: hasContent ? AppColors.textPrimary : AppColors.textSecondary, height: 1.5)),
      ]),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Obx(() => Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.currentIndex.value > 0 ? controller.goToPrevious : null,
                icon: Icon(Icons.arrow_back_ios_new_rounded, size: 14.w, color: AppColors.textSecondary),
                label: Text('Trở lại', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 12.h), side: BorderSide(color: AppColors.border), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r))),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CupertinoButton(
                onPressed: controller.currentIndex.value < controller.questions.length - 1 ? controller.goToNext : null,
                padding: EdgeInsets.zero, minSize: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10.r)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Tiếp theo', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                    SizedBox(width: 6.w),
                    Icon(Icons.arrow_forward_ios_rounded, size: 14.w, color: Colors.white),
                  ]),
                ),
              ),
            ),
          ])),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Danh sách câu hỏi', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
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
                    return CupertinoButton(
                      padding: EdgeInsets.zero, minSize: 0,
                      onPressed: () => controller.jumpToQuestion(i),
                      child: Container(
                        width: 36.w, height: 36.h,
                        decoration: BoxDecoration(
                          color: isCurrent ? AppColors.primary : AppColors.background,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: isCurrent ? AppColors.primary : AppColors.border),
                        ),
                        alignment: Alignment.center,
                        child: Text('${i + 1}', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: isCurrent ? Colors.white : AppColors.textSecondary)),
                      ),
                    );
                  });
                },
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}

