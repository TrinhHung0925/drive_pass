import 'package:get/get.dart';
import 'package:drive_pass/service/data_local.dart';
import 'package:drive_pass/service/local_service.dart';

class CategoryStat {
  final String title;
  final int done;
  final int total;
  double get progress => total > 0 ? done / total : 0.0;

  CategoryStat({required this.title, required this.done, required this.total});
}

class StatisticsController extends GetxController {
  final localService = Get.find<LocalService>();

  // ── Theory ──
  final theoryDone = 0.obs;
  final theoryTotal = 0.obs;
  double get theoryProgress =>
      theoryTotal.value > 0 ? theoryDone.value / theoryTotal.value : 0.0;

  final categoryStats = <CategoryStat>[].obs;

  // ── Exam ──
  final examAttempts = 0.obs;
  final examPassed = 0.obs;
  final examFailed = 0.obs;
  final examTotalSets = 0.obs;
  final examAvgScore = 0.0.obs;
  final examBestScore = 0.obs;
  final examAvgTime = ''.obs;

  double get examPassRate =>
      examAttempts.value > 0 ? examPassed.value / examAttempts.value : 0.0;

  // ── Others ──
  final wrongCount = 0.obs;
  final bookmarkedCount = 0.obs;
  final reviewedWrongCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadAll();
  }

  void _loadAll() {
    _loadTheory();
    _loadExam();
    _loadOthers();
  }

  void _loadTheory() {
    theoryTotal.value = DataLocal.listQuestionsAll.length;
    theoryDone.value = localService.getTheoryAllUniqueIds().length;

    final keys = ['rule_concept', 'culture', 'technique', 'road_signs', 'solving'];
    final titles = [
      'Khái niệm & Quy tắc',
      'Văn hóa & Đạo đức',
      'Kỹ thuật lái xe',
      'Biển báo đường bộ',
      'Giải thế Sa hình',
    ];
    final lists = [
      DataLocal.listQuestionsRuleConcept,
      DataLocal.listQuestionsCulture,
      DataLocal.listQuestionsTechnique,
      DataLocal.listQuestionsRoadSigns,
      DataLocal.listQuestionsSolving,
    ];

    categoryStats.value = List.generate(keys.length, (i) {
      final doneIds = localService.getTheoryDoneIds(keys[i]);
      return CategoryStat(
        title: titles[i],
        done: doneIds.length,
        total: lists[i].length,
      );
    });
  }

  void _loadExam() {
    examTotalSets.value = DataLocal.listExam.length;

    final latest = localService.getAllExamHistory();
    examPassed.value = latest.values.where((h) => h.passed).length;
    examFailed.value = latest.values.where((h) => !h.passed).length;

    final allRecords = localService.getAllExamHistoryRecords();
    examAttempts.value = allRecords.length;

    if (allRecords.isEmpty) {
      examAvgScore.value = 0;
      examBestScore.value = 0;
      examAvgTime.value = '--:--';
      return;
    }

    // Average score
    final totalScore =
        allRecords.fold<int>(0, (sum, h) => sum + h.score);
    examAvgScore.value = totalScore / allRecords.length;

    // Best score
    examBestScore.value =
        allRecords.map((h) => h.score).reduce((a, b) => a > b ? a : b);

    // Average time
    int totalSeconds = 0;
    for (final h in allRecords) {
      final parts = h.timeTaken.split(':');
      if (parts.length == 2) {
        totalSeconds +=
            (int.tryParse(parts[0]) ?? 0) * 60 + (int.tryParse(parts[1]) ?? 0);
      }
    }
    final avgSec = totalSeconds ~/ allRecords.length;
    examAvgTime.value =
        '${(avgSec ~/ 60).toString().padLeft(2, '0')}:${(avgSec % 60).toString().padLeft(2, '0')}';
  }

  void _loadOthers() {
    wrongCount.value = localService.wrongQuestionCount;
    reviewedWrongCount.value =
        localService.getReviewedWrongQuestionIds().length;
    bookmarkedCount.value = localService.bookmarkedCount;
  }

  void onBack() => Get.back();
}

