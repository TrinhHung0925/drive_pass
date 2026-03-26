import 'package:get/get.dart';
import '../../service/local_service.dart';

class HomeController extends GetxController {
  final localService = Get.find<LocalService>();
  var userName = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  void loadProfile() {
    userName.value = localService.userName;
  }
}
