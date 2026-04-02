import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../model/violation_item.dart';
import '../resource/app_colors.dart';

class ViolationDetailBottomSheet extends StatelessWidget {
  final ViolationItem violation;

  const ViolationDetailBottomSheet({super.key, required this.violation});

  static void show(BuildContext context, ViolationItem violation) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Topic badge
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        ViolationItem.topicName(violation.topicCode),
                        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Violation title
                    Text(
                      violation.violation,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary, height: 1.5),
                    ),
                    SizedBox(height: 20.h),

                    // Entities
                    if (violation.entities.trim().isNotEmpty)
                      _buildDetailSection(
                        icon: Icons.person_outline_rounded,
                        title: 'Đối tượng áp dụng',
                        content: violation.entities,
                        color: AppColors.primary,
                      ),

                    // Fines
                    _buildDetailSection(
                      icon: Icons.monetization_on_rounded,
                      title: 'Mức phạt tiền',
                      content: violation.fines,
                      color: AppColors.error,
                    ),

                    // Additional penalties
                    if (violation.additionalPenalties.trim().isNotEmpty)
                      _buildDetailSection(
                        icon: Icons.warning_amber_rounded,
                        title: 'Hình phạt bổ sung',
                        content: violation.additionalPenalties,
                        color: Colors.orange,
                      ),


                    // Remedial
                    if (violation.remedial.trim().isNotEmpty)
                      _buildDetailSection(
                        icon: Icons.build_rounded,
                        title: 'Biện pháp khắc phục',
                        content: violation.remedial,
                        color: AppColors.success,
                      ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDetailSection({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.w, color: color),
              SizedBox(width: 8.w),
              Text(title, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: color)),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

