import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drive_pass/model/questions.dart';
import 'package:drive_pass/service/data_local.dart';
import 'package:drive_pass/service/local_service.dart';

class RandomPracticeController extends GetxController {
  final localService = Get.find<LocalService>();

  var currentIndex = 0.obs;
  var showAnswer = false.obs;
  var selectedOption = (-1).obs;
  var isCurrentBookmarked = false.obs;
  var correctCount = 0.obs;
  var answeredCount = 0.obs;

  List<Question> questions = [];

  final ScrollController scrollController = ScrollController();
  Worker? _worker;

  @override
  void onInit() {
    super.onInit();
    _generateRandomQuestions();
    _updateBookmarkState();

    _worker = ever(currentIndex, (_) {
      scrollToIndex(currentIndex.value);
      _updateBookmarkState();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToIndex(currentIndex.value);
    });
  }

  void _generateRandomQuestions() {
    final all = List<Question>.from(DataLocal.listQuestionsAll);
    all.shuffle(Random());
    questions = all.take(20).toList();
  }

  void _updateBookmarkState() {
    if (questions.isEmpty) return;
    isCurrentBookmarked.value =
        localService.isBookmarked(questions[currentIndex.value].id);
  }

  void toggleBookmark() {
    if (questions.isEmpty) return;
    localService.toggleBookmark(questions[currentIndex.value].id);
    _updateBookmarkState();
  }

  int correctAnswerIndex(int questionIndex) {
    final q = questions[questionIndex];
    final idx = q.options.indexWhere((o) => o.key == q.answer);
    return idx == -1 ? 0 : idx;
  }

  void selectAnswer(int optionIndex) {
    if (showAnswer.value) return;
    selectedOption.value = optionIndex;
    showAnswer.value = true;
    answeredCount.value++;

    final correct = correctAnswerIndex(currentIndex.value);
    if (optionIndex == correct) {
      correctCount.value++;
    } else {
      // Save wrong question
      localService.addWrongQuestion(questions[currentIndex.value].id);
    }
  }

  int optionVisualState(int optionIndex) {
    if (!showAnswer.value) return 0;
    final correct = correctAnswerIndex(currentIndex.value);
    if (optionIndex == correct) return 2;
    if (optionIndex == selectedOption.value && selectedOption.value != correct) {
      return 3;
    }
    return 0;
  }

  void goToPrevious() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      _resetAnswer();
    }
  }

  void goToNext() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      _resetAnswer();
    }
  }

  void jumpToQuestion(int index) {
    currentIndex.value = index;
    _resetAnswer();
  }

  void _resetAnswer() {
    showAnswer.value = false;
    selectedOption.value = -1;
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
    super.onClose();
  }

  void onBack() => Get.back();
}

