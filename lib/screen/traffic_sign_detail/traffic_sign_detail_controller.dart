import 'package:get/get.dart';
import '../../model/traffic_sign_item.dart';

class TrafficSignDetailController extends GetxController {
  final String categoryName = Get.arguments as String? ?? "Danh sách biển báo";

  final RxList<TrafficSignItem> signs = <TrafficSignItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
  }

  void _loadMockData() {
    // Generate some mock signs based on category
    if (categoryName.contains("nguy hiểm")) {
      signs.value = [
        TrafficSignItem(id: "W.201a", title: "Chỗ ngoặt nguy hiểm vòng bên trái", description: "Báo trước sắp đến một chỗ ngoặt nguy hiểm vòng bên trái."),
        TrafficSignItem(id: "W.201b", title: "Chỗ ngoặt nguy hiểm vòng bên phải", description: "Báo trước sắp đến một chỗ ngoặt nguy hiểm vòng bên phải."),
        TrafficSignItem(id: "W.202a", title: "Nhiều chỗ ngoặt nguy hiểm liên tiếp", description: "Báo trước sắp đến nhiều chỗ ngoặt nguy hiểm liên tiếp trong đó chỗ ngoặt đầu tiên vòng bên trái."),
        TrafficSignItem(id: "W.207a", title: "Giao nhau với đường không ưu tiên", description: "Báo trước sắp đến nơi giao nhau với đường không ưu tiên."),
        TrafficSignItem(id: "W.208", title: "Giao nhau với đường ưu tiên", description: "Báo trước sắp đến nơi giao nhau với đường ưu tiên."),
      ];
    } else if (categoryName.contains("cấm")) {
      signs.value = [
        TrafficSignItem(id: "P.101", title: "Đường cấm", description: "Báo đường cấm tất cả các loại phương tiện (cơ giới và thô sơ) đi lại cả hai hướng, trừ các xe được ưu tiên theo quy định."),
        TrafficSignItem(id: "P.102", title: "Cấm đi ngược chiều", description: "Báo đường cấm tất cả các loại xe (cơ giới và thô sơ) đi vào theo chiều đặt biển, trừ các xe được ưu tiên theo quy định."),
        TrafficSignItem(id: "P.103a", title: "Cấm ô tô", description: "Báo đường cấm tất cả các loại xe cơ giới kể cả mô tô 3 bánh có thùng đi qua, trừ mô tô hai bánh, xe gắn máy và các xe được ưu tiên theo quy định."),
        TrafficSignItem(id: "P.112", title: "Cấm người đi bộ", description: "Báo đường cấm người đi bộ qua lại."),
      ];
    } else {
      signs.value = [
        TrafficSignItem(id: "1", title: "Biển báo $categoryName 1", description: "Nội dung chi tiết của biển báo $categoryName 1"),
        TrafficSignItem(id: "2", title: "Biển báo $categoryName 2", description: "Nội dung chi tiết của biển báo $categoryName 2"),
        TrafficSignItem(id: "3", title: "Biển báo $categoryName 3", description: "Nội dung chi tiết của biển báo $categoryName 3"),
        TrafficSignItem(id: "4", title: "Biển báo $categoryName 4", description: "Nội dung chi tiết của biển báo $categoryName 4"),
        TrafficSignItem(id: "5", title: "Biển báo $categoryName 5", description: "Nội dung chi tiết của biển báo $categoryName 5"),
      ];
    }
  }

  void goBack() => Get.back();
}
