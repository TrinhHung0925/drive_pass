import 'package:get/get.dart';
import '../../model/exam_history.dart';
import '../../service/local_service.dart';

class HistoryController extends GetxController {
  final localService = Get.find<LocalService>();

  final historyList = <ExamHistory>[].obs;

  int get totalAttempts => historyList.length;
  int get passedCount => historyList.where((h) => h.passed).length;
  int get failedCount => historyList.where((h) => !h.passed).length;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() {
    historyList.value = localService.getAllExamHistoryRecords();
  }

  void clearHistory() {
    localService.clearExamHistory();
    historyList.clear();
  }

  void onBack() {
    Get.back();
  }
}
