import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import '../../model/exam_history.dart';
import 'history_controller.dart';

class HistoryView extends StatefulWidget {
  HistoryView({super.key}) {
    if (!Get.isRegistered<HistoryController>()) {
      Get.put(HistoryController());
    }
  }

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  var controller = Get.find<HistoryController>();

  @override
  void dispose() {
    Get.delete<HistoryController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Lịch sử thi",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: controller.onBack,
          child: Container(
            margin: EdgeInsets.only(left: 16.w),
            alignment: Alignment.centerLeft,
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
        ),
        actions: [
          Obx(() => controller.historyList.isNotEmpty
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _showClearConfirm,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      size: 22.w,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.historyList.isEmpty) {
            return _buildEmptyState();
          }
          return Column(
            children: [
              _buildStatisticsHeader(),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.historyList.length,
                  itemBuilder: (context, index) {
                    final history = controller.historyList[index];
                    return _buildHistoryCard(history);
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ─── Empty State ────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 64.w,
            color: AppColors.textLight,
          ),
          SizedBox(height: 16.h),
          Text(
            'Chưa có lịch sử thi',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Hãy làm bài thi để xem kết quả tại đây',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Statistics Header ──────────────────────────────────────────────────
  Widget _buildStatisticsHeader() {
    return Obx(() => Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(
                color: AppColors.border,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                "Tổng số đề",
                "${controller.totalAttempts}",
                AppColors.primary,
              ),
              Container(
                width: 1.5,
                height: 40.h,
                color: AppColors.border,
              ),
              _buildStatItem(
                "Số lần ĐẠT",
                "${controller.passedCount}",
                AppColors.success,
              ),
              Container(
                width: 1.5,
                height: 40.h,
                color: AppColors.border,
              ),
              _buildStatItem(
                "Số lần TRƯỢT",
                "${controller.failedCount}",
                AppColors.error,
              ),
            ],
          ),
        ));
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ─── History Card ───────────────────────────────────────────────────────
  Widget _buildHistoryCard(ExamHistory history) {
    final isPassed = history.passed;
    final statusColor = isPassed ? AppColors.success : AppColors.error;
    final statusText = isPassed ? "ĐẠT" : "TRƯỢT";

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status icon
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              isPassed
                  ? Icons.check_circle_rounded
                  : Icons.cancel_rounded,
              color: statusColor,
              size: 28.w,
            ),
          ),
          SizedBox(width: 16.w),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Đề số ${history.examNo}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date + time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14.w,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${history.dateTaken} • ${history.timeTaken}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    // Score
                    Text(
                      'Điểm: ${history.correct}/${history.total}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Clear confirm dialog ──────────────────────────────────────────────
  void _showClearConfirm() {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Xóa lịch sử'),
        content: const Text('Bạn có chắc chắn muốn xóa toàn bộ lịch sử thi?'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Hủy'),
            onPressed: () => Get.back(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Xóa'),
            onPressed: () {
              controller.clearHistory();
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
