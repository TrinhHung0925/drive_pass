import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drive_pass/model/questions.dart';
import 'package:drive_pass/model/exam_item.dart';
import 'package:drive_pass/service/data_local.dart';

class ExamExplanationController extends GetxController {
  late final int examNo;
  late final Map<int, int> userAnswers;

  var currentIndex = 0.obs;
  final ScrollController scrollController = ScrollController();
  Worker? _worker;

  List<Question> questions = [];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map? ?? {};
    examNo = args['examNo'] ?? 0;

    // Reconstruct selectedAnswers from arguments
    final raw = args['selectedAnswers'];
    if (raw is Map) {
      userAnswers = raw.map((k, v) => MapEntry(k as int, v as int));
    } else {
      userAnswers = {};
    }

    _loadQuestions();

    _worker = ever(currentIndex, scrollToIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToIndex(currentIndex.value);
    });
  }

  void _loadQuestions() {
    ExamItem? exam;
    for (final e in DataLocal.listExam) {
      if (e.examNo == examNo) {
        exam = e;
        break;
      }
    }
    if (exam == null || DataLocal.listQuestionsAll.isEmpty) return;

    questions = exam.questionNos
        .where((no) => no >= 1 && no <= DataLocal.listQuestionsAll.length)
        .map((no) => DataLocal.listQuestionsAll[no - 1])
        .toList();
  }

  // ── Answer helpers ─────────────────────────────────────────────────────

  int correctAnswerIndex(int questionIndex) {
    final q = questions[questionIndex];
    final idx = q.options.indexWhere((o) => o.key == q.answer);
    return idx == -1 ? 0 : idx;
  }

  /// 0 = neutral, 2 = correct (green), 3 = wrong selected (red)
  int optionVisualState(int questionIndex, int optionIndex) {
    final chosen = userAnswers[questionIndex];
    final correct = correctAnswerIndex(questionIndex);
    if (optionIndex == correct) return 2;
    if (optionIndex == chosen && chosen != correct) return 3;
    return 0;
  }

  /// -1 = not answered, 0 = correct, 1 = wrong
  int getAnswerState(int questionIndex) {
    final chosen = userAnswers[questionIndex];
    if (chosen == null) return -1;
    return chosen == correctAnswerIndex(questionIndex) ? 0 : 1;
  }

  // ── Scroll ─────────────────────────────────────────────────────────────

  void scrollToIndex(int index) {
    if (!scrollController.hasClients) return;
    final screenWidth = Get.width;
    double offset = (index * 42.w) + 18.w - (screenWidth / 2) + 16.w;
    if (offset < 0) offset = 0;
    final maxScroll = scrollController.position.maxScrollExtent;
    if (offset > maxScroll) offset = maxScroll;
    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void onClose() {
    _worker?.dispose();
    scrollController.dispose();
    super.onClose();
  }

  // ── Navigation ─────────────────────────────────────────────────────────

  void goToPrevious() {
    if (currentIndex.value > 0) currentIndex.value--;
  }

  void goToNext() {
    if (currentIndex.value < questions.length - 1) currentIndex.value++;
  }

  void jumpToQuestion(int index) {
    currentIndex.value = index;
  }

  void onBack() => Get.back();
}

