import 'package:drive_pass/screen/home_tap/home_tap_controller.dart';
import 'package:get/get.dart';
import '../../service/local_service.dart';
import '../../route.dart';

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

  void goToExam() {
    Get.find<HomeTapController>().changeTabIndex(1);
  }

  void goToSign() => Get.toNamed(AppPage.criticalQuestions.routeName);
  void goToTheory() => Get.toNamed(AppPage.theory.routeName);
  void goToTips() => Get.toNamed(AppPage.examTips.routeName);
  void goToAllActivities() => Get.toNamed(AppPage.history.routeName);
}
