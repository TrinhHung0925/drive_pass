import 'package:get/get.dart';
import 'package:drive_pass/route.dart';
import '../../service/local_service.dart';
import '../exam/exam_controller.dart';
import '../exam_detail/exam_detail_controller.dart';

class ExamResultController extends GetxController {
  late final int examNo;
  late final int correct;
  late final int total;
  late final int score;
  late final int incorrect;
  late final int skipped;
  late final String timeTaken;
  late final String dateTaken;
  late final Map<int, int> selectedAnswers;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map? ?? {};
    examNo   = args['examNo']    ?? 0;
    correct  = args['correct']   ?? 0;
    total    = args['total']     ?? 0;
    incorrect= args['incorrect'] ?? 0;
    skipped  = args['skipped']   ?? 0;
    timeTaken= args['timeTaken'] ?? '00:00';

    // Store selectedAnswers for explanation screen
    final raw = args['selectedAnswers'];
    if (raw is Map) {
      selectedAnswers = raw.map((k, v) => MapEntry(k as int, v as int));
    } else {
      selectedAnswers = {};
    }

    final now = DateTime.now();
    dateTaken =
        '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';

    score = total == 0 ? 0 : ((correct / total) * 100).round();

    // ── Persist result ────────────────────────────────────────────────────
    if (examNo > 0) _saveResult();
  }

  Future<void> _saveResult() async {
    final localService = Get.find<LocalService>();
    await localService.saveExamResult(
      examNo:    examNo,
      correct:   correct,
      total:     total,
      timeTaken: timeTaken,
      dateTaken: dateTaken,
    );
    if (Get.isRegistered<ExamController>()) {
      Get.find<ExamController>().loadHistory();
    }
  }

  void viewDetails() {
    Get.toNamed(
      AppPage.examExplanation.routeName,
      arguments: {
        'examNo': examNo,
        'selectedAnswers': Map<int, int>.from(selectedAnswers),
      },
    );
  }

  void retakeExam() {
    Get.back();
    Get.find<ExamDetailController>().refreshExams();
  }

  void goBack(){
    Get.close(2);
  }

  void shareResult() {}
}
