import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import 'theory_controller.dart';

class TheoryView extends StatefulWidget {
  TheoryView({super.key}) {
    if (!Get.isRegistered<TheoryController>()) {
      Get.put(TheoryController());
    }
  }

  @override
  State<TheoryView> createState() => _TheoryViewState();
}

class _TheoryViewState extends State<TheoryView> {
  var controller = Get.find<TheoryController>();

  @override
  void dispose() {
    Get.delete<TheoryController>();
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
          "Lý thuyết",
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
            _buildOverallProgress(),
            SizedBox(height: 24.h),
            Align(
              alignment: Alignment.centerLeft,
              child: _buildHeader("Danh mục lý thuyết"),
            ),
            SizedBox(height: 12.h),
            _buildGrid(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgress() {
    return Container(
      padding: EdgeInsets.all(20.w),
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
      child: Row(
        children: [
          Obx(() {
            final progress = controller.totalProgress;
            return SizedBox(
              width: 70.w,
              height: 70.w,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 6.w,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    color: AppColors.primary,
                    strokeCap: StrokeCap.round,
                  ),
                  Center(
                    child: Text(
                      "${(progress * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                  "${controller.completedQuestions} / ${controller.totalQuestions} câu",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                )),
                SizedBox(height: 4.h),
                Text(
                  "Bạn đang làm rất tốt!",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    "Tiến độ học tập",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case "book": return Icons.library_books_rounded;
      case "menu_book": return Icons.menu_book_rounded;
      case "people": return Icons.people_alt_rounded;
      case "gavel": return Icons.gavel_rounded;
      case "tune": return Icons.tune_rounded;
      case "settings": return Icons.settings_rounded;
      case "traffic": return Icons.traffic_rounded;
      case "alt_route": return Icons.alt_route_rounded;
      case "warning": return Icons.warning_amber_rounded;
      default: return Icons.book_rounded;
    }
  }

  Widget _buildGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) {
        final item = controller.categories[index];
        final bool isCritical = item.isCritical;
        final double progress = item.progress;

        return CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: null,
          onPressed: () => controller.openCategory(index),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isCritical ? const Color(0xFFFFF0F0) : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: isCritical ? null : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: isCritical 
                            ? Colors.transparent 
                            : AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        _getIcon(item.icon),
                        color: isCritical ? Colors.red : AppColors.primary,
                        size: 20.w,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: isCritical ? Colors.red : AppColors.textPrimary,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            item.subtitle,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: isCritical ? Colors.red.withValues(alpha: 0.7) : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: progress > 0 ? progress : 0.0,
                        minHeight: 4.h,
                        backgroundColor: isCritical 
                            ? Colors.red.withValues(alpha: 0.1) 
                            : AppColors.background,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCritical ? Colors.red : AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      item.progressText,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: isCritical 
                            ? Colors.red 
                            : (progress == 0 ? AppColors.textLight : AppColors.primary),
                      ),
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
