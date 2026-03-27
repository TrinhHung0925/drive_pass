import 'package:get/get.dart';
import 'package:drive_pass/route.dart';

class ExamController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  onBack() {
    Get.back();
  }

  void goToExamDetail() {
    Get.toNamed(AppPage.examDetail.routeName);
  }
}
