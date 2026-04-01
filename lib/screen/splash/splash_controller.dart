import 'package:drive_pass/service/data_local.dart';
import 'package:get/get.dart';
import '../../route.dart';
import '../../service/local_service.dart';

class SplashController extends GetxController {
  final localService = Get.find<LocalService>();

  @override
  void onInit() {
    super.onInit();
    getData();
    _initializeApp();
  }

  Future<void> getData() async {
   await Future.wait([
      DataLocal.getListQuestionsAll(),
      DataLocal.getListQuestionsCritical(),
      DataLocal.getListQuestionsRoadSigns(),
      DataLocal.getListQuestionsSolving(),
      DataLocal.getListQuestionsRuleConcept(),
      DataLocal.getListQuestionsTechnique(),
      DataLocal.getListQuestionsCulture(),
      DataLocal.getListExamItem(),
    ]);
  }

  void _initializeApp() async {
    await Future.delayed(const Duration(seconds: 2));

    if (localService.isFirstLaunch) {
      Get.offAllNamed(AppPage.intro.routeName);
      return;
    }

    Get.offAllNamed(AppPage.homeTap.routeName);
  }

  onBack() {
    Get.back();
  }
}
