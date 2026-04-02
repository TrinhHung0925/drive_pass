import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../model/violation_item.dart';
import '../../resource/app_colors.dart';
import 'violations_controller.dart';
import '../../bottom_sheet/violation_detail_bottom_sheet.dart';

class ViolationsView extends StatefulWidget {
  ViolationsView({super.key}) {
    if (!Get.isRegistered<ViolationsController>()) {
      Get.put(ViolationsController());
    }
  }

  @override
  State<ViolationsView> createState() => _ViolationsViewState();
}

class _ViolationsViewState extends State<ViolationsView> {
  var controller = Get.find<ViolationsController>();
  final _searchController = TextEditingController();
  final _topicScrollController = ScrollController();
  final Map<int, GlobalKey> _chipKeys = {};

  @override
  void dispose() {
    _searchController.dispose();
    _topicScrollController.dispose();
    Get.delete<ViolationsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTopicFilter(),
          Expanded(child: _buildViolationsList()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              minSize: 0,
              onPressed: controller.onBack,
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.arrow_back_ios_new_rounded, size: 16.w, color: AppColors.textPrimary),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Container(
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: controller.onSearchChanged,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Tìm mức phạt...',
                    hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textLight),
                    prefixIcon: Icon(Icons.search_rounded, size: 20.w, color: AppColors.textLight),
                    prefixIconConstraints: BoxConstraints(minWidth: 36.w),
                    suffixIcon: Obx(() => controller.searchText.value.isNotEmpty
                        ? CupertinoButton(
                            padding: EdgeInsets.zero,
                            minSize: 0,
                            onPressed: () {
                              _searchController.clear();
                              controller.onSearchChanged('');
                            },
                            child: Icon(Icons.close_rounded, size: 18.w, color: AppColors.textSecondary),
                          )
                        : const SizedBox.shrink()),
                    suffixIconConstraints: BoxConstraints(minWidth: 36.w),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ],
        ),

      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: AppColors.border, height: 1),
      ),
    );
  }

  Widget _buildTopicFilter() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      color: AppColors.surface,
      child: SizedBox(
        height: 40.h,
        child: Obx(() {
          final selectedCode = controller.selectedTopicCode.value;
          final codes = controller.topicCodes.toList();

          return ListView.separated(
            controller: _topicScrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: codes.length,
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final code = codes[index];
              final isSelected = selectedCode == code;

              _chipKeys.putIfAbsent(code, () => GlobalKey());

              return GestureDetector(
                key: _chipKeys[code],
                onTap: () {
                  controller.selectTopic(code);
                  // scroll after state updated
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToSelectedChip(code);
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.background,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 6, offset: const Offset(0, 2))]
                        : [],
                  ),
                  child: Text(
                    ViolationItem.topicName(code),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
      
    );
  }

  void _scrollToSelectedChip(int code) {
    final key = _chipKeys[code];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        alignment: 0.3,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildViolationsList() {
    return Obx(() {
      if (controller.filteredViolations.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.gavel_rounded, size: 64.w, color: AppColors.textLight.withValues(alpha: 0.4)),
              SizedBox(height: 16.h),
              Text('Không tìm thấy lỗi vi phạm', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              SizedBox(height: 4.h),
              Text('Thử từ khóa hoặc danh mục khác', style: TextStyle(fontSize: 13.sp, color: AppColors.textLight)),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
            child: Text(
              '${controller.filteredViolations.length} lỗi vi phạm',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
              physics: const BouncingScrollPhysics(),
              itemCount: controller.filteredViolations.length,
              separatorBuilder: (_, __) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                final v = controller.filteredViolations[index];
                return _buildViolationCard(v);
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildViolationCard(ViolationItem v) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: 0,
      onPressed: () {
        ViolationDetailBottomSheet.show(context, v);
      },
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    '#${v.no}',
                    style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: AppColors.error),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    v.violation,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 14.w, color: AppColors.textLight),
              ],
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.monetization_on_rounded, size: 14.w, color: AppColors.accent),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      v.fines,
                      style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.accent),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}

