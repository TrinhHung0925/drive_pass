import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../route.dart';

class Question {
  final int id;
  final String text;
  final List<String> options;
  final int correctIndex;

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.correctIndex,
  });
}

class ExamDetailController extends GetxController {
  var currentIndex = 0.obs;
  var selectedAnswers = <int, int>{}.obs;
  var secondsLeft = (20 * 60).obs;
  var isSubmitted = false.obs;

  final ScrollController scrollController = ScrollController();
  Worker? _worker;

  Timer? _timer;

  final List<Question> questions = List.generate(35, (i) {
    return Question(
      id: i + 1,
      text: 'Câu ${i + 1}: Biển báo nào dưới đây là biển "Cấm đi ngược chiều"?',
      options: ['Biển số 101', 'Biển số 102', 'Biển số 103'],
      correctIndex: 0,
    );
  });

  @override
  void onInit() {
    super.onInit();
    _startTimer();

    _worker = ever(currentIndex, scrollToIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToIndex(currentIndex.value);
    });
  }

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

  String get timerMinutes =>
      (secondsLeft.value ~/ 60).toString().padLeft(2, '0');
  String get timerSeconds =>
      (secondsLeft.value % 60).toString().padLeft(2, '0');

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
    if (chosen == null) return -1;
    if (!isSubmitted.value) return -1;
    return chosen == questions[questionIndex].correctIndex ? 0 : 1;
  }

  bool get hasAnsweredAll => selectedAnswers.length == questions.length;

  int get correctCount => questions.asMap().entries.where((e) {
    final chosen = selectedAnswers[e.key];
    return chosen != null && chosen == e.value.correctIndex;
  }).length;

  void submitExam() {
    _timer?.cancel();
    isSubmitted.value = true;
    
    int answered = selectedAnswers.length;
    int skipped = questions.length - answered;
    int incorrect = answered - correctCount;
    // Calculate formatted time
    int secondsUsed = (20 * 60) - secondsLeft.value;
    String timeTaken = '${(secondsUsed ~/ 60).toString().padLeft(2, '0')}:${(secondsUsed % 60).toString().padLeft(2, '0')}';
    
    Get.toNamed(
      AppPage.examResult.routeName,
      arguments: {
        'correct': correctCount, 
        'total': questions.length,
        'incorrect': incorrect,
        'skipped': skipped,
        'timeTaken': timeTaken,
      },
    );
  }

  void onBack() => Get.back();
}
