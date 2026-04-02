import 'package:get/get.dart';
import 'package:drive_pass/route.dart';
import '../../model/exam_history.dart';
import '../../service/local_service.dart';

class ExamController extends GetxController {
  final localService = Get.find<LocalService>();

  /// Reactive map: examNo → ExamHistory (null means not attempted)
  final examHistory = <int, ExamHistory>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() {
    examHistory.value = localService.getAllExamHistory();
  }

  int get passedCount => examHistory.values.where((h) => h.passed).length;
  int get failedCount => examHistory.values.where((h) => !h.passed).length;
  int get attemptedCount => examHistory.length;

  onBack() {
    Get.back();
  }

  void goToExamDetail(int examNo) {
    Get.toNamed(AppPage.examDetail.routeName, arguments: {'examNo': examNo});
  }
}
