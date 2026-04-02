import 'package:get/get.dart';
import '../../model/traffic_sign_item.dart';
import '../../service/data_local.dart';

class TrafficSignDetailController extends GetxController {
  final String categoryName = Get.arguments as String? ?? "Danh sách biển báo";

  final RxList<TrafficSignItem> signs = <TrafficSignItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  void _loadData() {
    signs.value = DataLocal.trafficSignCategories[categoryName] ?? [];
  }

  void goBack() => Get.back();
}
