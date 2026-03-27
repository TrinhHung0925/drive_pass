import 'package:get/get.dart';
import 'package:drive_pass/route.dart';

class ExamResultController extends GetxController {
  // Arguments passed from ExamDetailView after submission
  late final int correct;
  late final int total;
  late final int score; // could be percentage or raw
  late final int incorrect;
  late final int skipped;
  late final String timeTaken;
  late final String dateTaken;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    correct = args['correct'] ?? 0;
    total = args['total'] ?? 0;
    incorrect = args['incorrect'] ?? 0;
    skipped = args['skipped'] ?? 0;
    timeTaken = args['timeTaken'] ?? "00:00";
    
    final now = DateTime.now();
    dateTaken = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    
    if (total == 0) {
      score = 0;
    } else {
      score = ((correct / total) * 100).round();
    }
  }

  void viewDetails() {
    // Navigate to detailed result view (could reuse ExamDetailView with arguments)
    Get.toNamed(AppPage.examDetail.routeName, arguments: Get.arguments);
  }

  void retakeExam() {
    // Go back to exam list screen
    Get.offAllNamed(AppPage.exam.routeName);
  }

  void goBack() => Get.back();

  void shareResult() {} // Sharing functionality to be implemented
}
