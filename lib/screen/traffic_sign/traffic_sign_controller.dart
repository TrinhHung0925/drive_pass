import 'package:get/get.dart';
import '../../route.dart';
import '../../service/data_local.dart';

class TrafficSignController extends GetxController {

  List<String> get categoryNames => DataLocal.trafficSignCategories.keys.toList();

  int signCount(String category) =>
      DataLocal.trafficSignCategories[category]?.length ?? 0;

  void onBack() {
    Get.back();
  }

  void goToDetail(String categoryName) {
    Get.toNamed(AppPage.trafficSignDetail.routeName, arguments: categoryName);
  }
}
