import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_tap_controller.dart';
import '../home/home_view.dart';
import '../exam/exam_view.dart';
import '../history/history_view.dart';
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
    HistoryView(),
    SettingView(),
  ];

  @override
  void dispose() {
    Get.delete<HomeTapController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: IndexedStack(
        index: controller.selectedIndex.value,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeTabIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1E88E5), // Optional: Make it look premium
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Exam',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    ));
  }
}
