import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../resource/app_colors.dart';
import '../../resource/app_resource.dart';
import '../../route.dart';
import 'home_tap_controller.dart';
import '../home/home_view.dart';
import '../exam/exam_view.dart';
import '../traffic_sign/traffic_sign_view.dart';
import '../setting/setting_view.dart';

class HomeTapView extends StatefulWidget {
  HomeTapView({super.key}) {
    if (!Get.isRegistered<HomeTapController>()) {
      Get.put(HomeTapController());
    }
  }

  @override
  State<HomeTapView> createState() => _HomeTapViewState();
}

class _HomeTapViewState extends State<HomeTapView> {
  var controller = Get.find<HomeTapController>();

  final List<Widget> _pages = [
    HomeView(),
    ExamView(),
    TrafficSignView(),
    SettingView(),
  ];

  // Draggable chat bubble position
  late double _bubbleX;
  late double _bubbleY;
  bool _isDragging = false;
  bool _initialized = false;

  @override
  void dispose() {
    Get.delete<HomeTapController>();
    super.dispose();
  }

  void _initBubblePosition(BuildContext context) {
    if (!_initialized) {
      final size = MediaQuery.of(context).size;
      _bubbleX = size.width - 70.w;
      _bubbleY = size.height - 200.h;
      _initialized = true;
    }
  }

  void _snapToEdge(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bubbleSize = 56.w;
    final margin = 8.w;
    setState(() {
      if (_bubbleX + bubbleSize / 2 < screenWidth / 2) {
        _bubbleX = margin;
      } else {
        _bubbleX = screenWidth - bubbleSize - margin;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _initBubblePosition(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bubbleSize = 56.w;
    final bottomBarHeight = 60.h + MediaQuery.of(context).padding.bottom;

    return Obx(() => Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: controller.selectedIndex.value,
            children: _pages,
          ),
          // Draggable floating chat bubble
          AnimatedPositioned(
            duration: _isDragging ? Duration.zero : const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            left: _bubbleX,
            top: _bubbleY,
            child: GestureDetector(
              onPanStart: (_) => _isDragging = true,
              onPanUpdate: (details) {
                setState(() {
                  _bubbleX = (_bubbleX + details.delta.dx)
                      .clamp(0.0, screenWidth - bubbleSize);
                  _bubbleY = (_bubbleY + details.delta.dy)
                      .clamp(MediaQuery.of(context).padding.top, screenHeight - bubbleSize - bottomBarHeight);
                });
              },
              onPanEnd: (_) {
                _isDragging = false;
                _snapToEdge(context);
              },
              onTap: () => Get.toNamed(AppPage.aiChat.routeName),
              child: AnimatedScale(
                scale: _isDragging ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  width: bubbleSize,
                  height: bubbleSize,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 26.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: SafeArea(
          child: Container(
            height: 60.h,
            padding: EdgeInsets.only(top: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Img.icNavHome, 'Trang chủ'),
                _buildNavItem(1, Img.icNavExam, 'Thi thử'),
                _buildNavItem(2, Img.icNavSign, 'Biển báo'),
                _buildNavItem(3, Img.icNavProfile, 'Cá nhân'),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildNavItem(int index, String iconPath, String label) {
    bool isActive = controller.selectedIndex.value == index;
    Color color = isActive ? AppColors.primary : AppColors.textSecondary;

    return CupertinoButton(
      padding: EdgeInsets.zero,
      minSize: null,
      onPressed: () => controller.changeTabIndex(index),
      child: SizedBox(
        width: 70.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 20.w,
              height: 20.w,
              color: color,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

}
