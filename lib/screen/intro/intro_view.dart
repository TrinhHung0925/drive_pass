import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import 'intro_controller.dart';

class IntroView extends StatefulWidget {
  IntroView({super.key}) {
    if (!Get.isRegistered<IntroController>()) {
      Get.put(IntroController());
    }
  }

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  final controller = Get.find<IntroController>();
  final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    Get.delete<IntroController>();
    super.dispose();
  }

  // ─────────────────────────────────────────
  // Root scaffold
  // ─────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [


            // Pages
            Expanded(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: controller.updateCurrentPage,
                itemCount: controller.items.length,
                itemBuilder: (_, i) => _buildPage(i),
              ),
            ),

            // Dots + button
            _buildBottom(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Per-page content
  // ─────────────────────────────────────────
  Widget _buildPage(int index) {
    final item = controller.items[index];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _illustrationForPage(index),
          SizedBox(height: 32.h),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.65,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          // Page 3 extra feature chips
          if (index == 2) ...[
            SizedBox(height: 24.h),
            _buildFeatureChips(),
          ],
        ],
      ),
    );
  }

  Widget _illustrationForPage(int index) {
    switch (index) {
      case 0:
        return _illus1Study();
      case 1:
        return _illus2Exam();
      case 2:
        return _illus3Expert();
      default:
        return const SizedBox.shrink();
    }
  }

  // ─────────────────────────────────────────
  // Illustration 1 – Ôn tập 600 câu hỏi
  // White card with document lines + reader
  // ─────────────────────────────────────────
  Widget _illus1Study() {
    return SizedBox(
      height: 260.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // White card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 16.h),
            child: Column(
              children: [
                // Document lines
                ...[0.85, 0.65, 0.75, 0.50].map(
                  (f) => Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: _docLine(f),
                  ),
                ),
                // Reader illustration
                Expanded(
                  child: Center(
                    child: Container(
                      width: 110.w,
                      height: 110.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF4FF),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.person_rounded,
                            size: 68.w,
                            color: const Color(0xFF8B6E47),
                          ),
                          Positioned(
                            bottom: 18.w,
                            child: Icon(
                              Icons.menu_book_rounded,
                              size: 28.w,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Blue check badge
          Positioned(
            bottom: 14.h,
            left: 14.w,
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.check_rounded, color: Colors.white, size: 18.w),
            ),
          ),
        ],
      ),
    );
  }

  Widget _docLine(double widthFactor) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: 8.h,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Illustration 2 – Thi thử sát thực tế
  // Mock exam card: timer, progress, stats, LIVE badge
  // ─────────────────────────────────────────
  Widget _illus2Exam() {
    return Container(
      height: 260.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timer row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.timer_rounded, color: AppColors.primary, size: 18.w),
              ),
              SizedBox(width: 10.w),
              Text(
                '19:54',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: 0.5,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6.h,
            ),
          ),
          SizedBox(height: 16.h),
          // Stat tiles
          Row(
            children: [
              Expanded(
                child: _statTile(
                  icon: Icons.list_alt_rounded,
                  label: 'Câu 15/30',
                  iconColor: AppColors.textSecondary,
                  bgColor: AppColors.background,
                  textColor: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _statTile(
                  icon: Icons.check_circle_outline_rounded,
                  label: 'Đã nộp',
                  iconColor: AppColors.primary,
                  bgColor: AppColors.primary.withValues(alpha: 0.08),
                  textColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const Spacer(),
          // LIVE EXAM badge
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'LIVE EXAM',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20.w),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // Illustration 3 – Mẹo thi từ chuyên gia
  // Dark navy card + insight sub-card
  // ─────────────────────────────────────────
  Widget _illus3Expert() {
    return SizedBox(
      height: 260.h,
      child: Stack(
        children: [
          // Dark gradient card
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0C1C42), Color(0xFF1A3A72)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  top: -24.h,
                  right: -24.w,
                  child: Container(
                    width: 130.w,
                    height: 130.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -28.h,
                  left: -28.w,
                  child: Container(
                    width: 110.w,
                    height: 110.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.04),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: EdgeInsets.fromLTRB(22.w, 22.h, 22.w, 70.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXPERT',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Icon(
                        Icons.person_rounded,
                        size: 90.w,
                        color: Colors.white.withValues(alpha: 0.55),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Expert insight sub-card
          Positioned(
            bottom: 14.h,
            left: 14.w,
            right: 14.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.location_on_rounded,
                        color: AppColors.primary, size: 18.w),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EXPERT INSIGHT',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            letterSpacing: 0.6,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Quick memorization hacks',
                          style: TextStyle(
                            fontSize: 11.sp,
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
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // Feature chips (page 3 only)
  // ─────────────────────────────────────────
  Widget _buildFeatureChips() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _featureChip(Icons.traffic_rounded, 'Biển báo'),
        SizedBox(width: 14.w),
        _featureChip(Icons.grid_view_rounded, 'Sa Hình'),
      ],
    );
  }

  Widget _featureChip(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 26.w),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // Bottom: dots + CTA button
  // ─────────────────────────────────────────
  Widget _buildBottom() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 32.h),
      child: Column(
        children: [
          // Indicator dots
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.items.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: controller.currentPage.value == i ? 24.w : 8.w,
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == i
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
              )),
          SizedBox(height: 20.h),
          // CTA button
          Obx(() {
            final label =
                controller.items[controller.currentPage.value].buttonLabel;
            return SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14.r),
                onPressed: () async {
                  if (controller.isLastPage) {
                    await controller.completeIntro();
                    return;
                  }
                  await pageController.nextPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                  );
                },
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
