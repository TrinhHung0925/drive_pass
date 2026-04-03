import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../model/exam_tip.dart';
import '../../resource/app_colors.dart';
import 'exam_tips_controller.dart';
import 'tip_category_view.dart';
import 'tip_detail_view.dart';

class ExamTipsView extends StatefulWidget {
  ExamTipsView({super.key}) {
    if (!Get.isRegistered<ExamTipsController>()) {
      Get.put(ExamTipsController());
    }
  }

  @override
  State<ExamTipsView> createState() => _ExamTipsViewState();
}

class _ExamTipsViewState extends State<ExamTipsView> {
  var controller = Get.find<ExamTipsController>();

  @override
  void dispose() {
    Get.delete<ExamTipsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Get.back(),
          child: Icon(Icons.arrow_back_ios_new_rounded, size: 20.w, color: AppColors.textPrimary),
        ),
        title: Text(
          "Mẹo Thi",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator());
        }
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader("MẸO HAY HÔM NAY"),
              SizedBox(height: 12.h),
              _buildHeroCard(),
              SizedBox(height: 28.h),

              _buildSectionHeader("DANH MỤC BÍ KÍP"),
              SizedBox(height: 12.h),
              ...controller.categories.asMap().entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 14.h),
                  child: _buildCategoryCard(entry.value),
                );
              }),
              SizedBox(height: 14.h),

              _buildSectionHeader("MẸO NHANH TỪ CHUYÊN GIA"),
              SizedBox(height: 12.h),
              ..._buildQuickTips(),
              SizedBox(height: 48.h),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: AppColors.textLight, letterSpacing: 0.5),
    );
  }

  // ─────────── HERO CARD ─────────────────
  Widget _buildHeroCard() {
    final f = controller.featured.value;
    if (f == null) return const SizedBox.shrink();

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        final tip = ExamTip(id: 0, title: f.title, summary: f.summary, content: f.content, icon: 'star');
        Get.to(() => TipDetailView(tip: tip, accentColor: AppColors.primary));
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: AppColors.textPrimary.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: CachedNetworkImage(
                    imageUrl: f.image,
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 160.h,
                      color: AppColors.border,
                      child: Center(child: CupertinoActivityIndicator()),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 160.h,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(Icons.image_rounded, size: 40.w, color: AppColors.primary),
                    ),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text("⭐ NỔI BẬT", style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    f.title,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary, height: 1.3),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    f.summary,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: 1.4),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 14.w, color: AppColors.primary),
                      SizedBox(width: 4.w),
                      Text(f.readTime, style: TextStyle(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text("Xem chi tiết", style: TextStyle(fontSize: 12.sp, color: AppColors.primary, fontWeight: FontWeight.w700)),
                      SizedBox(width: 2.w),
                      Icon(Icons.arrow_forward_rounded, size: 12.w, color: AppColors.primary),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────── CATEGORY CARD ─────────────────
  Widget _buildCategoryCard(TipCategory cat) {
    Color accentColor;
    try {
      accentColor = Color(int.parse(cat.color.replaceFirst('#', '0xFF')));
    } catch (_) {
      accentColor = AppColors.primary;
    }

    final iconMap = {
      'menu_book': Icons.menu_book_rounded,
      'directions_car': Icons.directions_car_rounded,
      'warning_amber': Icons.warning_amber_rounded,
      'psychology': Icons.psychology_rounded,
      'bolt': Icons.bolt_rounded,
    };

    final isError = cat.id == 'cau_hay_sai';

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => Get.to(() => TipCategoryView(category: cat)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isError ? AppColors.errorBackground : accentColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
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
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(iconMap[cat.icon] ?? Icons.lightbulb_rounded, color: accentColor, size: 20.w),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    '${cat.tips.length} mẹo',
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: accentColor),
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.arrow_forward_ios_rounded, color: accentColor.withValues(alpha: 0.5), size: 16.w),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              cat.title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            SizedBox(height: 6.h),
            Text(
              cat.description,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────── QUICK TIPS ─────────────────
  List<Widget> _buildQuickTips() {
    // Lấy 2 tip đầu từ mỗi category làm quick tips
    final quickTips = <Map<String, dynamic>>[];
    for (final cat in controller.categories) {
      Color c;
      try {
        c = Color(int.parse(cat.color.replaceFirst('#', '0xFF')));
      } catch (_) {
        c = AppColors.primary;
      }
      for (final tip in cat.tips.take(1)) {
        quickTips.add({'tip': tip, 'color': c, 'category': cat.title});
      }
    }

    return quickTips.map((item) {
      final tip = item['tip'] as ExamTip;
      final color = item['color'] as Color;

      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Get.to(() => TipDetailView(tip: tip, accentColor: color)),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.emoji_objects_rounded, color: color, size: 20.w),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.title,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.3),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        tip.summary,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20.w),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}
