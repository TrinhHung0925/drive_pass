import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../model/exam_tip.dart';
import '../../resource/app_colors.dart';
import 'tip_detail_view.dart';

class TipCategoryView extends StatelessWidget {
  final TipCategory category;

  const TipCategoryView({super.key, required this.category});

  Color get _accentColor {
    try {
      return Color(int.parse(category.color.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.primary;
    }
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
          category.title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(16.w),
        itemCount: category.tips.length + 1, // +1 for header
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader();
          }
          return _buildTipItem(context, category.tips[index - 1], index);
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_accentColor.withValues(alpha: 0.1), _accentColor.withValues(alpha: 0.03)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: _accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(_getCategoryIcon(), color: _accentColor, size: 28.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${category.tips.length} mẹo hay',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: _accentColor),
                ),
                SizedBox(height: 4.h),
                Text(
                  category.description,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, ExamTip tip, int index) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Get.to(() => TipDetailView(tip: tip, accentColor: _accentColor));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: _accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: _accentColor),
                ),
              ),
            ),
            SizedBox(width: 14.w),
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
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary, height: 1.3),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20.w),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon() {
    const map = {
      'menu_book': Icons.menu_book_rounded,
      'directions_car': Icons.directions_car_rounded,
      'warning_amber': Icons.warning_amber_rounded,
      'psychology': Icons.psychology_rounded,
      'bolt': Icons.bolt_rounded,
    };
    return map[category.icon] ?? Icons.lightbulb_outline_rounded;
  }
}

