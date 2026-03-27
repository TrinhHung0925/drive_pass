import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import 'exam_tips_controller.dart';

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
          minSize: null,
          onPressed: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20.w,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text(
          "Mẹo Thi",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
            _buildCategoryCard(
              title: "Mẹo lý thuyết",
              icon: Icons.menu_book_rounded,
              iconBgColor: AppColors.primary.withValues(alpha: 0.1),
              iconColor: AppColors.primary,
              bgColor: AppColors.surface,
              content: Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _buildTag("Quy tắc 5 giây"),
                  _buildTag("Ghi nhớ biển báo"),
                  _buildTag("Thi sa hình"),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            _buildCategoryCard(
              title: "Câu hỏi hay sai",
              icon: Icons.warning_amber_rounded,
              iconBgColor: Colors.transparent,
              iconColor: Colors.red,
              bgColor: const Color(0xFFFFF0F0),
              arrowColor: Colors.red.withValues(alpha: 0.5),
              content: Text(
                "Phân tích sâu các lỗi phổ biến mà 90% thí sinh mắc phải khi làm bài thi",
                style: TextStyle(fontSize: 13.sp, color: Colors.red.withValues(alpha: 0.7), height: 1.4, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 16.h),
            _buildCategoryCard(
              title: "Mẹo thi sa hình",
              icon: Icons.directions_car_rounded,
              iconBgColor: Colors.transparent,
              iconColor: AppColors.primary,
              bgColor: AppColors.primary.withValues(alpha: 0.05),
              arrowColor: Colors.transparent, // no arrow requested
              content: Text(
                "Làm chủ 11 bài thi sa hình khó nhằn. Ghép xe dọc, ghép xe ngang, dừng xe ngang dốc và các điểm canh chuẩn.",
                style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary, height: 1.4, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 28.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionHeader("MẸO NHANH TỪ CHUYÊN GIA"),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: null,
                  onPressed: () {},
                  child: Text("Xem tất cả", style: TextStyle(fontSize: 13.sp, color: AppColors.primary, fontWeight: FontWeight.w600)),
                )
              ],
            ),
            SizedBox(height: 12.h),
            _buildQuickTipItem(
              icon: Icons.emoji_objects_rounded,
              iconBgColor: Colors.orange.withValues(alpha: 0.1),
              iconColor: Colors.orange,
              title: "Cách nhận biết nhanh biển báo cấm",
              subtitle: "Chỉ cần nhớ 3 đặc điểm màu sắc và hình dạng...",
            ),
            SizedBox(height: 12.h),
            _buildQuickTipItem(
              icon: Icons.check_circle_outline_rounded,
              iconBgColor: Colors.green.withValues(alpha: 0.1),
              iconColor: Colors.green,
              title: "5 giây thần thánh khi dừng đèn đỏ",
              subtitle: "Lưu ý quan trọng để không bị trừ điểm khi thi sa hình.",
            ),
            SizedBox(height: 48.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textLight,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildHeroCard() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: null,
      onPressed: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: Image.network(
                    "https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?q=80&w=1000&auto=format&fit=crop",
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                    child: Text(
                      "TIN MỚI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
                    "Mẹo căn khoảng cách an toàn khi lái xe trong phố",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Làm thế nào để không \"va chạm\" trong giờ cao điểm? Học ngay quy tắc nhìn bánh xe trước và cách căn lề chuẩn xác nhất...",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Icon(Icons.schedule_rounded, size: 14.w, color: AppColors.primary),
                      SizedBox(width: 4.w),
                      Text(
                        "5 phút đọc",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Xem chi tiết",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(Icons.arrow_forward_rounded, size: 12.w, color: AppColors.primary),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required Color bgColor,
    Color? arrowColor,
    required Widget content,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: null,
      onPressed: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: bgColor == AppColors.surface
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: iconColor, size: 20.w),
                ),
                const Spacer(),
                if (arrowColor != Colors.transparent)
                  Icon(
                    Icons.north_east_rounded,
                    color: arrowColor ?? AppColors.textLight,
                    size: 20.w,
                  )
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildQuickTipItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: null,
      onPressed: () {},
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: iconColor, size: 20.w),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
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
}
