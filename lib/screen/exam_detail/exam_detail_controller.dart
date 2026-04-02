import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drive_pass/route.dart';
import 'package:drive_pass/model/questions.dart';
import 'package:drive_pass/model/exam_item.dart';
import 'package:drive_pass/service/data_local.dart';

class ExamDetailController extends GetxController {
  late final int examNo;

  var currentIndex = 0.obs;
  var selectedAnswers = <int, int>{}.obs;
  var secondsLeft = (20 * 60).obs;
  var isSubmitted = false.obs;

  final ScrollController scrollController = ScrollController();
  Worker? _worker;
  Timer? _timer;

  /// Real questions loaded from DataLocal based on examNo
  List<Question> questions = [];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map? ?? {};
    examNo = args['examNo'] ?? 0;
    _loadQuestions();
    _startTimer();

    _worker = ever(currentIndex, scrollToIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToIndex(currentIndex.value);
    });
  }

  void refreshExams() {
    currentIndex.value = 0;
    selectedAnswers.clear();
    secondsLeft.value = 20 * 60;
    isSubmitted.value = false;
    _startTimer();
  }
  // ── Data loading ───────────────────────────────────────────────────────

  void _loadQuestions() {
    // Find exam by examNo
    ExamItem? exam;
    for (final e in DataLocal.listExam) {
      if (e.examNo == examNo) {
        exam = e;
        break;
      }
    }
    if (exam == null || DataLocal.listQuestionsAll.isEmpty) return;

    // questionNos are 1-based indices into listQuestionsAll
    questions = exam.questionNos
        .where((no) => no >= 1 && no <= DataLocal.listQuestionsAll.length)
        .map((no) => DataLocal.listQuestionsAll[no - 1])
        .toList();
  }

  // ── Answer helpers ─────────────────────────────────────────────────────

  /// Returns the 0-based index of the correct option for [questionIndex]
  int correctAnswerIndex(int questionIndex) {
    final q = questions[questionIndex];
    final idx = q.options.indexWhere((o) => o.key == q.answer);
    return idx == -1 ? 0 : idx;
  }

  int optionVisualState(int questionIndex, int optionIndex) {
    final chosen = selectedAnswers[questionIndex];
    if (!isSubmitted.value) {
      return chosen == optionIndex ? 1 : 0;
    }
    final correct = correctAnswerIndex(questionIndex);
    if (optionIndex == correct) return 2; // always highlight correct
    if (optionIndex == chosen && chosen != correct) return 3; // wrong choice
    return 0;
  }

  // ── Timer ──────────────────────────────────────────────────────────────

  void scrollToIndex(int index) {
    if (!scrollController.hasClients) return;
    final screenWidth = Get.width;
    double offset = (index * 42.w) + 18.w - (screenWidth / 2) + 16.w;
    if (offset < 0) offset = 0;
    final maxScroll = scrollController.position.maxScrollExtent;
    if (offset > maxScroll) offset = maxScroll;
    scrollController.animateTo(offset, duration: const Duration(milliseconds: 250), curve: Curves.easeInOutCubic);
  }

  @override
  void onClose() {
    _worker?.dispose();
    scrollController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsLeft.value > 0) {
        secondsLeft.value--;
      } else {
        _timer?.cancel();
        submitExam();
      }
    });
  }

  String get timerMinutes => (secondsLeft.value ~/ 60).toString().padLeft(2, '0');
  String get timerSeconds => (secondsLeft.value % 60).toString().padLeft(2, '0');

  // ── Actions ────────────────────────────────────────────────────────────

  void selectAnswer(int optionIndex) {
    if (isSubmitted.value) return;
    selectedAnswers[currentIndex.value] = optionIndex;
  }

  void goToPrevious() {
    if (currentIndex.value > 0) currentIndex.value--;
  }

  void goToNext() {
    if (currentIndex.value < questions.length - 1) currentIndex.value++;
  }

  void jumpToQuestion(int index) {
    currentIndex.value = index;
  }

  /// -1 = not answered, 0 = correct, 1 = wrong
  int getAnswerState(int questionIndex) {
    final chosen = selectedAnswers[questionIndex];
    if (chosen == null || !isSubmitted.value) return -1;
    return chosen == correctAnswerIndex(questionIndex) ? 0 : 1;
  }

  bool get hasAnsweredAll => selectedAnswers.length == questions.length;

  int get correctCount => questions.asMap().entries.where((e) {
    final chosen = selectedAnswers[e.key];
    return chosen != null && chosen == correctAnswerIndex(e.key);
  }).length;

  void submitExam() {
    _timer?.cancel();
    final answered = selectedAnswers.length;
    final skipped = questions.length - answered;
    final incorrect = answered - correctCount;
    final secondsUsed = (20 * 60) - secondsLeft.value;
    final timeTaken =
        '${(secondsUsed ~/ 60).toString().padLeft(2, '0')}:'
        '${(secondsUsed % 60).toString().padLeft(2, '0')}';

    Get.toNamed(
      AppPage.examResult.routeName,
      arguments: {
        'examNo': examNo,
        'correct': correctCount,
        'total': questions.length,
        'incorrect': incorrect,
        'skipped': skipped,
        'timeTaken': timeTaken,
        'selectedAnswers': Map<int, int>.from(selectedAnswers),
      },
    );
  }

  void onBack() => Get.back();
}
