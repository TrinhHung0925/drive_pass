import 'package:get/get.dart';

class HomeTapController extends GetxController {
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  void onBack() {
    Get.back();
  }
}
