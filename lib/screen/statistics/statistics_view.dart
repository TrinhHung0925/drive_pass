import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import 'statistics_controller.dart';

class StatisticsView extends StatefulWidget {
  StatisticsView({super.key}) {
    if (!Get.isRegistered<StatisticsController>()) {
      Get.put(StatisticsController());
    }
  }

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  var controller = Get.find<StatisticsController>();

  @override
  void dispose() {
    Get.delete<StatisticsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 0,
          onPressed: controller.onBack,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.w,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          "Thống kê chi tiết",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCards(),
            SizedBox(height: 24.h),
            _buildSectionTitle("Lý thuyết theo chủ đề"),
            SizedBox(height: 12.h),
            _buildTheoryCategoryBars(),
            SizedBox(height: 24.h),
            _buildSectionTitle("Kết quả thi thử"),
            SizedBox(height: 12.h),
            _buildExamStatsCard(),
            SizedBox(height: 24.h),
            _buildSectionTitle("Ôn tập"),
            SizedBox(height: 12.h),
            _buildReviewStatsCard(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
    );
  }

  // ─────────────── OVERVIEW CARDS ───────────────────────────────────────────
  Widget _buildOverviewCards() {
    return Obx(() => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.library_books_rounded,
                    color: AppColors.primary,
                    title: "Lý thuyết",
                    value: "${controller.theoryDone}/${controller.theoryTotal}",
                    subtitle: "${(controller.theoryProgress * 100).toInt()}% hoàn thành",
                    progress: controller.theoryProgress,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.assignment_rounded,
                    color: AppColors.success,
                    title: "Thi thử",
                    value: "${controller.examPassed}/${controller.examTotalSets}",
                    subtitle: "đề đã đạt",
                    progress: controller.examTotalSets.value > 0
                        ? controller.examPassed.value /
                            controller.examTotalSets.value
                        : 0.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.replay_rounded,
                    color: AppColors.error,
                    title: "Câu hay sai",
                    value: "${controller.wrongCount}",
                    subtitle: "câu cần ôn",
                    progress: null,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.bookmark_rounded,
                    color: AppColors.accent,
                    title: "Đã đánh dấu",
                    value: "${controller.bookmarkedCount}",
                    subtitle: "câu đã lưu",
                    progress: null,
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String subtitle,
    double? progress,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: color, size: 18.w),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          if (progress != null) ...[
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5.h,
                backgroundColor: color.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─────────────── THEORY CATEGORY BARS ─────────────────────────────────────
  Widget _buildTheoryCategoryBars() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.categoryStats.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Text(
                "Chưa có dữ liệu",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          );
        }
        return Column(
          children: controller.categoryStats.map((cat) {
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildCategoryBar(cat),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _buildCategoryBar(CategoryStat cat) {
    final percent = (cat.progress * 100).toInt();
    final Color barColor;
    if (cat.progress >= 1.0) {
      barColor = AppColors.success;
    } else if (cat.progress >= 0.5) {
      barColor = AppColors.primary;
    } else if (cat.progress > 0) {
      barColor = AppColors.accent;
    } else {
      barColor = AppColors.textLight;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                cat.title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Text(
              "${cat.done}/${cat.total}",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: barColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Stack(
          children: [
            Container(
              height: 10.h,
              decoration: BoxDecoration(
                color: barColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
            FractionallySizedBox(
              widthFactor: cat.progress.clamp(0.0, 1.0),
              child: Container(
                height: 10.h,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                alignment: Alignment.centerRight,
                child: cat.progress >= 0.15
                    ? Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: Text(
                          "$percent%",
                          style: TextStyle(
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─────────────── EXAM STATS CARD ──────────────────────────────────────────
  Widget _buildExamStatsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        if (controller.examAttempts.value == 0) {
          return _buildEmptyExam();
        }
        return Column(
          children: [
            // Pass rate ring
            Row(
              children: [
                SizedBox(
                  width: 80.w,
                  height: 80.w,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: controller.examPassRate,
                        strokeWidth: 7.w,
                        backgroundColor: AppColors.error.withValues(alpha: 0.15),
                        color: AppColors.success,
                        strokeCap: StrokeCap.round,
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${(controller.examPassRate * 100).toInt()}%",
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.success,
                              ),
                            ),
                            Text(
                              "đạt",
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    children: [
                      _buildExamStatRow(
                        Icons.check_circle_rounded,
                        AppColors.success,
                        "Đạt",
                        "${controller.examPassed.value} lần",
                      ),
                      SizedBox(height: 8.h),
                      _buildExamStatRow(
                        Icons.cancel_rounded,
                        AppColors.error,
                        "Trượt",
                        "${controller.examFailed.value} lần",
                      ),
                      SizedBox(height: 8.h),
                      _buildExamStatRow(
                        Icons.repeat_rounded,
                        AppColors.primary,
                        "Tổng lượt thi",
                        "${controller.examAttempts.value}",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(color: AppColors.border, height: 1),
            SizedBox(height: 16.h),
            // Bottom stats row
            Row(
              children: [
                Expanded(
                  child: _buildExamMetric(
                    "Điểm TB",
                    "${controller.examAvgScore.value.toInt()}",
                    AppColors.primary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: AppColors.border,
                ),
                Expanded(
                  child: _buildExamMetric(
                    "Điểm cao nhất",
                    "${controller.examBestScore.value}",
                    AppColors.success,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40.h,
                  color: AppColors.border,
                ),
                Expanded(
                  child: _buildExamMetric(
                    "Thời gian TB",
                    controller.examAvgTime.value,
                    AppColors.accent,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyExam() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 48.w,
            color: AppColors.textLight.withValues(alpha: 0.5),
          ),
          SizedBox(height: 12.h),
          Text(
            "Chưa thi lần nào",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Hãy thử sức với bộ đề thi thử nhé!",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamStatRow(
      IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18.w),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildExamMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ─────────────── REVIEW STATS CARD ────────────────────────────────────────
  Widget _buildReviewStatsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        return Column(
          children: [
            _buildReviewRow(
              Icons.error_outline_rounded,
              AppColors.error,
              "Tổng câu sai",
              "${controller.wrongCount.value}",
            ),
            SizedBox(height: 12.h),
            _buildReviewRow(
              Icons.check_circle_outline_rounded,
              AppColors.success,
              "Đã ôn lại",
              "${controller.reviewedWrongCount.value}",
            ),
            SizedBox(height: 12.h),
            _buildReviewRow(
              Icons.pending_outlined,
              AppColors.accent,
              "Chưa ôn",
              "${controller.wrongCount.value - controller.reviewedWrongCount.value}",
            ),
            SizedBox(height: 12.h),
            _buildReviewRow(
              Icons.bookmark_outline_rounded,
              AppColors.primary,
              "Câu đã đánh dấu",
              "${controller.bookmarkedCount.value}",
            ),
            if (controller.wrongCount.value > 0) ...[
              SizedBox(height: 16.h),
              // Review progress
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Tiến độ ôn lại",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        "${controller.wrongCount.value > 0 ? ((controller.reviewedWrongCount.value / controller.wrongCount.value) * 100).toInt() : 0}%",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: controller.wrongCount.value > 0
                          ? controller.reviewedWrongCount.value /
                              controller.wrongCount.value
                          : 0.0,
                      minHeight: 6.h,
                      backgroundColor: AppColors.success.withValues(alpha: 0.1),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.success),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildReviewRow(
      IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: color, size: 16.w),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

