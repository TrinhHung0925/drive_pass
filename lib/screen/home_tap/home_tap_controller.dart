import 'package:get/get.dart';

class HomeTapController extends GetxController {
  var selectedIndex = 0.obs;
  var isBottomBarVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  void showBottomBar() {
    isBottomBarVisible.value = true;
  }

  void hideBottomBar() {
    isBottomBarVisible.value = false;
  }

  void onBack() {
    Get.back();
  }
}
