import 'package:get/get.dart';
import '../../route.dart';

class TrafficSignController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  void onBack() {
    Get.back();
  }

  void goToDetail(String categoryName) {
    Get.toNamed(AppPage.trafficSignDetail.routeName, arguments: categoryName);
  }
}
