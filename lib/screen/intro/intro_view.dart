import 'dart:math';
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

class _IntroViewState extends State<IntroView> with TickerProviderStateMixin {
  final controller = Get.find<IntroController>();
  final pageController = PageController();

  late AnimationController _floatController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    pageController.dispose();
    Get.delete<IntroController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          Obx(() => AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _bgGradient(controller.currentPage.value),
                  ),
                ),
              )),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: controller.updateCurrentPage,
                    itemCount: controller.items.length,
                    itemBuilder: (_, i) => _buildPage(i),
                  ),
                ),
                _buildBottom(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _bgGradient(int page) {
    switch (page) {
      case 0:
        return [const Color(0xFFE8F4FD), const Color(0xFFF0F7FF)];
      case 1:
        return [const Color(0xFFFFF7ED), const Color(0xFFFFF9F0)];
      case 2:
        return [const Color(0xFFEDE9FE), const Color(0xFFF5F3FF)];
      default:
        return [AppColors.background, AppColors.background];
    }
  }


  // ─────────────────────────────────────────
  // Per-page content
  // ─────────────────────────────────────────
  Widget _buildPage(int index) {
    final item = controller.items[index];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          // Illustration
          Expanded(
            flex: 5,
            child: _illustrationForPage(index),
          ),
          // Text content
          Expanded(
            flex: 3,
            child: Column(
              children: [
                SizedBox(height: 24.h),
                // Badge
                _buildPageBadge(index),
                SizedBox(height: 16.h),
                Text(

                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.25,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  item.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageBadge(int index) {
    final labels = ['📚 600+ câu hỏi', '⏱️ Phòng thi thật', '💡 Chuyên gia'];
    final colors = [
      AppColors.primary,
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colors[index].withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: colors[index].withValues(alpha: 0.2)),
      ),
      child: Text(
        labels[index],
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: colors[index],
        ),
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
  // ─────────────────────────────────────────
  Widget _illus1Study() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (_, child) {
        final offset = sin(_floatController.value * pi) * 8;
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Glow circle
          Container(
            width: 240.w,
            height: 240.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.12),
                  AppColors.primary.withValues(alpha: 0.02),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Main card
          Container(
            width: 220.w,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Book icon with circle
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(Icons.menu_book_rounded, color: Colors.white, size: 36.w),
                ),
                SizedBox(height: 16.h),
                // Skeleton lines
                ...List.generate(3, (i) {
                  final widths = [0.9, 0.7, 0.55];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: widths[i],
                        child: Container(
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08 + i * 0.03),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 8.h),
                // Progress row
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: LinearProgressIndicator(
                          value: 0.75,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                          minHeight: 6.h,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '75%',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Floating badge - top right
          Positioned(
            top: 10.h,
            right: 20.w,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, child) {
                final scale = 1.0 + _pulseController.value * 0.08;
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_rounded, color: Colors.white, size: 14.w),
                    SizedBox(width: 4.w),
                    Text(
                      '600',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Floating icon - bottom left
          Positioned(
            bottom: 20.h,
            left: 16.w,
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.lightbulb_rounded, color: AppColors.warning, size: 22.w),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────
  // Illustration 2 – Thi thử sát thực tế
  // ─────────────────────────────────────────
  Widget _illus2Exam() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (_, child) {
        final offset = sin(_floatController.value * pi + 0.5) * 8;
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Glow
          Container(
            width: 240.w,
            height: 240.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFF59E0B).withValues(alpha: 0.1),
                  const Color(0xFFF59E0B).withValues(alpha: 0.02),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Main card
          Container(
            width: 240.w,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Timer display
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '20:00',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'phút',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                // Mock question
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 8.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Mock options
                      ...List.generate(3, (i) {
                        final isSelected = i == 1;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 6.h),
                          child: Container(
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary.withValues(alpha: 0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: 8.w),
                                Container(
                                  width: 14.w,
                                  height: 14.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.border,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: isSelected
                                      ? Icon(Icons.check, color: Colors.white, size: 10.w)
                                      : null,
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: FractionallySizedBox(
                                    widthFactor: [0.8, 0.6, 0.7][i],
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      height: 6.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.textLight.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(3.r),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // LIVE badge
          Positioned(
            top: 10.h,
            right: 10.w,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, child) {
                final scale = 1.0 + _pulseController.value * 0.06;
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
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
                      'THI THỬ',
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
          ),
          // Floating stat - bottom left
          Positioned(
            bottom: 12.h,
            left: 10.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assignment_turned_in_rounded,
                      color: AppColors.success, size: 16.w),
                  SizedBox(width: 4.w),
                  Text(
                    '35 câu',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
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
  // Illustration 3 – Mẹo thi từ chuyên gia
  // ─────────────────────────────────────────
  Widget _illus3Expert() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (_, child) {
        final offset = sin(_floatController.value * pi + 1.0) * 8;
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Glow
          Container(
            width: 240.w,
            height: 240.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  const Color(0xFF8B5CF6).withValues(alpha: 0.02),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Main dark card
          Container(
            width: 240.w,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E1B4B).withValues(alpha: 0.3),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Expert icon
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Icon(
                    Icons.psychology_rounded,
                    color: const Color(0xFFA78BFA),
                    size: 40.w,
                  ),
                ),
                SizedBox(height: 16.h),
                // Tips list
                ...List.generate(3, (i) {
                  final icons = [
                    Icons.traffic_rounded,
                    Icons.grid_view_rounded,
                    Icons.speed_rounded,
                  ];
                  final labels = ['Biển báo', 'Sa hình', 'Tốc độ'];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(icons[i],
                              color: const Color(0xFFA78BFA), size: 18.w),
                          SizedBox(width: 10.w),
                          Text(
                            labels[i],
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.white.withValues(alpha: 0.3),
                              size: 12.w),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          // Floating badge - top left
          Positioned(
            top: 8.h,
            left: 16.w,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, child) {
                final scale = 1.0 + _pulseController.value * 0.06;
                return Transform.scale(scale: scale, child: child);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 14.w),
                    SizedBox(width: 4.w),
                    Text(
                      'PRO',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Star badge - bottom right
          Positioned(
            bottom: 16.h,
            right: 16.w,
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.star_rounded,
                  color: const Color(0xFFF59E0B), size: 24.w),
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
      padding: EdgeInsets.fromLTRB(28.w, 8.h, 28.w, 24.h),
      child: Column(
        children: [
          // Indicator dots
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.items.length,
                  (i) {
                    final isActive = controller.currentPage.value == i;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: isActive ? 28.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.border,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    );
                  },
                ),
              )),
          SizedBox(height: 24.h),

          // CTA button
          Obx(() {
            final label =
                controller.items[controller.currentPage.value].buttonLabel;
            return SizedBox(
              width: double.infinity,
              height: 56.h,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(16.r),
                color: AppColors.primary,
                onPressed: () async {
                  if (controller.isLastPage) {
                    await controller.completeIntro();
                    return;
                  }
                  await pageController.nextPage(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
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
