import 'package:drive_pass/screen/home_tap/home_tap_controller.dart';
import 'package:get/get.dart';
import '../../model/exam_history.dart';
import '../../service/data_local.dart';
import '../../service/local_service.dart';
import '../../route.dart';

class HomeController extends GetxController {
  final localService = Get.find<LocalService>();
  var userName = "".obs;
  final recentHistory = <ExamHistory>[].obs;

  // ── Learning progress ──
  final completedQuestions = 0.obs;
  final totalQuestions = 0.obs;
  final passedExams = 0.obs;
  final failedExams = 0.obs;
  final totalExams = 0.obs;
  final wrongQuestionCount = 0.obs;

  double get learningProgress =>
      totalQuestions.value > 0 ? completedQuestions.value / totalQuestions.value : 0.0;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadRecentHistory();
    refreshProgress();
  }

  void loadProfile() {
    userName.value = localService.userName;
  }

  void loadRecentHistory() {
    final all = localService.getAllExamHistoryRecords();
    // Show max 5 most recent
    recentHistory.value = all.take(5).toList();
    refreshProgress();
  }

  void refreshProgress() {
    // Theory progress
    totalQuestions.value = DataLocal.listQuestionsAll.length;
    final uniqueIds = localService.getTheoryAllUniqueIds();
    completedQuestions.value = uniqueIds.length;

    // Exam stats
    totalExams.value = DataLocal.listExam.length;
    passedExams.value = localService.passedExamCount;
    failedExams.value = localService.failedExamCount;

    // Wrong questions
    wrongQuestionCount.value = localService.wrongQuestionCount;
  }

  void goToExam() {

    Get.find<HomeTapController>().changeTabIndex(1);
  }

  void goToSign() => Get.toNamed(AppPage.criticalQuestions.routeName);
  void goToTheory() => Get.toNamed(AppPage.theory.routeName);
  void goToTips() => Get.toNamed(AppPage.examTips.routeName);
  void goToWrongQuestions() => Get.toNamed(AppPage.wrongQuestions.routeName);
  void goToStatistics() => Get.toNamed(AppPage.statistics.routeName);
  void goToAllActivities() => Get.toNamed(AppPage.history.routeName);
  void goToViolations() => Get.toNamed(AppPage.violations.routeName);
  void goToRandomPractice() => Get.toNamed(AppPage.randomPractice.routeName);
  void goToSearchQuestions() => Get.toNamed(AppPage.searchQuestions.routeName);
  void goToAiChat() => Get.toNamed(AppPage.aiChat.routeName);
}
