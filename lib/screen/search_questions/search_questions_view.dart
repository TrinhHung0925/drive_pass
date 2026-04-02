import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import 'search_questions_controller.dart';

class SearchQuestionsView extends StatefulWidget {
  SearchQuestionsView({super.key}) {
    if (!Get.isRegistered<SearchQuestionsController>()) {
      Get.put(SearchQuestionsController());
    }
  }

  @override
  State<SearchQuestionsView> createState() => _SearchQuestionsViewState();
}

class _SearchQuestionsViewState extends State<SearchQuestionsView> {
  var controller = Get.find<SearchQuestionsController>();
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    Get.delete<SearchQuestionsController>();
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
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8.r)),
                  child: Icon(Icons.arrow_back_ios_new_rounded, size: 16.w, color: AppColors.textPrimary),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Container(
                  height: 40.h,
                  decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12.r)),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    onChanged: controller.onSearchChanged,
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Tìm câu hỏi... (VD: tốc độ, nồng độ cồn)',
                      hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textLight),
                      prefixIcon: Icon(Icons.search_rounded, size: 20.w, color: AppColors.textLight),
                      suffixIcon: Obx(
                        () => controller.searchText.value.isNotEmpty
                            ? CupertinoButton(
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                onPressed: () {
                                  _searchController.clear();
                                  controller.onSearchChanged('');
                                },
                                child: Icon(Icons.close_rounded, size: 18.w, color: AppColors.textSecondary),
                              )
                            : const SizedBox.shrink(),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
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
      ),
      body: Obx(() {
        if (!controller.isSearching.value) {
          return _buildInitialState();
        }
        if (controller.results.isEmpty) {
          return _buildEmptyState();
        }
        return _buildResultsList();
      }),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_rounded, size: 64.w, color: AppColors.textLight.withValues(alpha: 0.4)),
          SizedBox(height: 16.h),
          Text(
            'Nhập từ khóa để tìm kiếm',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 8.h),
          Text(
            'VD: "tốc độ", "nồng độ cồn", "đèn vàng"',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64.w, color: AppColors.textLight.withValues(alpha: 0.4)),
          SizedBox(height: 16.h),
          Text(
            'Không tìm thấy kết quả',
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          SizedBox(height: 4.h),
          Text(
            'Thử từ khóa khác nhé',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
          child: Text(
            'Tìm thấy ${controller.results.length} câu hỏi',
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            physics: const BouncingScrollPhysics(),
            itemCount: controller.results.length,
            separatorBuilder: (_, __) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              final q = controller.results[index];
              return CupertinoButton(
                padding: EdgeInsets.zero,
                minSize: 0,
                onPressed: () => controller.openQuestion(index),
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          q.id,
                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: AppColors.primary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          q.question,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.arrow_forward_ios_rounded, size: 14.w, color: AppColors.textLight),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
