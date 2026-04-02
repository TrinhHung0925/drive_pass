import 'package:drive_pass/model/questions.dart';
import 'package:drive_pass/service/data_local.dart';
import 'package:drive_pass/service/local_service.dart';
import 'package:drive_pass/route.dart';
import 'package:get/get.dart';

class CriticalQuestionsController extends GetxController {
  static const String categoryKey = 'critical';

  final completed = 0.obs;
  final total = 0.obs;
  final doneIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    total.value = DataLocal.listQuestionsCritical.length;
    _loadProgress();
  }

  void _loadProgress() {
    final localService = Get.find<LocalService>();
    final ids = localService.getTheoryDoneIds(categoryKey);
    doneIds.assignAll(ids);
    completed.value = ids.length;
  }

  void refreshProgress() {
    _loadProgress();
  }

  bool isQuestionDone(String questionId) {
    return doneIds.contains(questionId);
  }

  void goBack() => Get.back();

  void openQuestion(Question itemQuestions) {
    final index = DataLocal.listQuestionsCritical.indexWhere((q) => q.id == itemQuestions.id);
    Get.toNamed(
      AppPage.theoryDetail.routeName,
      arguments: {
        'title': 'Câu điểm liệt',
        'categoryKey': categoryKey,
        'questions': DataLocal.listQuestionsCritical,
        'initialIndex': index >= 0 ? index : 0,
      },
    )?.then((_) => refreshProgress());
  }
}
