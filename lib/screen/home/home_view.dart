import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import '../../resource/app_resource.dart';
import 'home_controller.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key}) {
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController());
    }
  }

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var controller = Get.find<HomeController>();

  @override
  void dispose() {
    Get.delete<HomeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: controller.loadRecentHistory,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            Container(
              color: AppColors.surface,
              child: SafeArea(bottom: false, child: _buildHeader()),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    _buildSearchCard(),
                    SizedBox(height: 16.h),
                    _buildProgressCard(),
                    SizedBox(height: 24.h),
                    _buildQuickAccessSection(),
                    SizedBox(height: 24.h),
                    _buildRecentActivitySection(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header: "Xin chào, ..." + notification bell
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Xin chào 👋",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
              ),
              SizedBox(height: 4.h),
              Obx(
                () => Text(
                  controller.userName.value,
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12.r)),
            child: Center(
              child: Image.asset(Img.icNotification, width: 20.w, height: 20.w, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  /// Learning Progress Card
  Widget _buildProgressCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 0,
        onPressed: controller.goToStatistics,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Obx(() {
            final progress = controller.learningProgress;
            final percent = (progress * 100).toInt();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tiến độ học tập",
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    Row(
                      children: [
                        Text(
                          "$percent%",
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.primary),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.arrow_forward_ios_rounded, size: 12.w, color: AppColors.textLight),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.background,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 8.h,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatChip(
                      "Đã học",
                      "${controller.completedQuestions}/${controller.totalQuestions}",
                      AppColors.primary,
                    ),
                    _buildStatChip("Đã đạt", "${controller.passedExams}/${controller.totalExams}", AppColors.success),
                    _buildStatChip("Chưa đạt", "${controller.failedExams}/${controller.totalExams}", AppColors.error),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: color),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  /// Quick Access Grid
  Widget _buildQuickAccessSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Truy cập nhanh",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
          ),
          SizedBox(height: 12.h),
          // ── Ôn tập chính ──
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessCard(
                  "Lý thuyết",
                  Img.icTheory,
                  AppColors.success,
                  onPressed: controller.goToTheory,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildQuickAccessCard("Thi thử", Img.icExam, AppColors.primary, onPressed: controller.goToExam),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // ── Luyện tập ──
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessCard(
                  "Câu điểm liệt",
                  Img.icSign,
                  AppColors.error,
                  onPressed: controller.goToSign,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildQuickAccessIconCard(
                  "Ôn ngẫu nhiên",
                  Icons.shuffle_rounded,
                  Colors.teal,
                  onPressed: controller.goToRandomPractice,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // ── Tra cứu ──
          Row(
            children: [
              Expanded(
                child: _buildQuickAccessIconCard(
                  "Mức phạt",
                  Icons.gavel_rounded,
                  Colors.orange,
                  onPressed: controller.goToViolations,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildQuickAccessCard("Mẹo thi", Img.icTips, Colors.deepPurple, onPressed: controller.goToTips),
              ),
            ],
          ),
          SizedBox(height: 12.h),


          _buildWrongQuestionsCard(),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard(String title, String iconPath, Color color, {VoidCallback? onPressed}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.r)),
              child: Center(
                child: Image.asset(iconPath, width: 20.w, height: 20.w, color: color),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessIconCard(String title, IconData icon, Color color, {VoidCallback? onPressed}) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.r)),
              child: Center(
                child: Icon(icon, size: 20.w, color: color),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: controller.goToSearchQuestions,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),

          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [

            Icon(Icons.search_rounded, size: 20.w, color: AppColors.textLight),
            SizedBox(width: 10.w),
            Text(
              "Tìm câu hỏi theo từ khoá...",
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.textLight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWrongQuestionsCard() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: controller.goToWrongQuestions,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(Icons.replay_rounded, size: 22.w, color: AppColors.error),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Câu hay sai",
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 2.h),
                  Obx(
                    () => Text(
                      controller.wrongQuestionCount.value > 0
                          ? "Ôn lại ${controller.wrongQuestionCount.value} câu đã sai"
                          : "Chưa có câu nào sai",
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              final count = controller.wrongQuestionCount.value;
              if (count == 0) return const SizedBox.shrink();
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(12.r)),
                child: Text(
                  '$count',
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Recent Activity
  Widget _buildRecentActivitySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hoạt động gần đây",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 0,
                onPressed: controller.goToAllActivities,
                child: Text(
                  "Xem tất cả",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Obx(() {
            if (controller.recentHistory.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 32.h),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(Icons.history_rounded, size: 36.w, color: AppColors.textLight),
                    SizedBox(height: 8.h),
                    Text(
                      'Chưa có hoạt động nào',
                      style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }
            return Column(
              children: controller.recentHistory.map((h) {
                final isPassed = h.passed;
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: _buildRecentItem(
                    "Bộ đề số ${h.examNo}",
                    "${h.correct}/${h.total} câu đúng • ${h.timeTaken}",
                    isPassed ? "Đạt" : "Trượt",
                    isPassed ? AppColors.success : AppColors.error,
                    isPassed ? AppColors.successBackground : AppColors.errorBackground,
                  ),
                );
              }).toList(),
            );
          }),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildRecentItem(String title, String subtitle, String status, Color statusColor, Color statusBg) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(10.r)),
            child: Center(
              child: Image.asset(Img.icActivity, width: 20.w, height: 20.w, color: statusColor),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(6.r)),
            child: Text(
              status,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}
