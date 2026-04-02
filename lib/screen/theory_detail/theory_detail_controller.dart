import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drive_pass/model/questions.dart';
import 'package:drive_pass/service/local_service.dart';

class TheoryDetailController extends GetxController {
  late final String categoryTitle;
  late final String categoryKey;
  late final List<Question> questions;

  var currentIndex = 0.obs;
  var showAnswer = false.obs;
  var selectedOption = (-1).obs;
  var isCurrentBookmarked = false.obs;

  /// Track which question indices have been answered in this session + loaded from local
  final answeredIndices = <int>{}.obs;

  final ScrollController scrollController = ScrollController();
  Worker? _worker;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map? ?? {};
    categoryTitle = args['title'] ?? '';
    categoryKey = args['categoryKey'] ?? '';
    questions = args['questions'] as List<Question>? ?? [];

    final initialIndex = args['initialIndex'] as int? ?? 0;
    if (initialIndex > 0 && initialIndex < questions.length) {
      currentIndex.value = initialIndex;
    }

    _loadAnswered();
    _updateBookmarkState();

    _worker = ever(currentIndex, (_) {
      scrollToIndex(currentIndex.value);
      _updateBookmarkState();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToIndex(currentIndex.value);
    });
  }

  void _loadAnswered() {
    final localService = Get.find<LocalService>();
    final doneIds = localService.getTheoryDoneIds(categoryKey);
    for (int i = 0; i < questions.length; i++) {
      if (doneIds.contains(questions[i].id)) {
        answeredIndices.add(i);
      }
    }
  }

  void _updateBookmarkState() {
    if (questions.isEmpty) return;
    final localService = Get.find<LocalService>();
    isCurrentBookmarked.value =
        localService.isBookmarked(questions[currentIndex.value].id);
  }

  void toggleBookmark() {
    if (questions.isEmpty) return;
    final localService = Get.find<LocalService>();
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

    // Mark as done
    answeredIndices.add(currentIndex.value);
    final localService = Get.find<LocalService>();
    localService.markTheoryQuestionDone(categoryKey, questions[currentIndex.value].id);

    // If wrong → save to wrong questions list
    final correct = correctAnswerIndex(currentIndex.value);
    if (optionIndex != correct) {
      localService.addWrongQuestion(questions[currentIndex.value].id);
    }
  }

  // ...existing code...
  /// 0 = neutral, 1 = selected (before reveal — not used here), 
  /// 2 = correct (green), 3 = wrong selected (red)
  int optionVisualState(int optionIndex) {
    if (!showAnswer.value) return 0;
    final correct = correctAnswerIndex(currentIndex.value);
    if (optionIndex == correct) return 2;
    if (optionIndex == selectedOption.value && selectedOption.value != correct) return 3;
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

