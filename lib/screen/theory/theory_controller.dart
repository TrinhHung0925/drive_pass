import 'package:drive_pass/model/questions.dart';
import 'package:drive_pass/service/data_local.dart';
import 'package:get/get.dart';
import '../../model/theory_category.dart';
import '../../route.dart';
import '../../service/local_service.dart';

class TheoryController extends GetxController {
  final localService = Get.find<LocalService>();

  final completedQuestions = 0.obs;
  final totalQuestions = 0.obs;
  final bookmarkedCount = 0.obs;

  double get totalProgress => totalQuestions.value > 0 
      ? completedQuestions.value / totalQuestions.value 
      : 0.0;

  final RxList<TheoryCategory> listCategories = <TheoryCategory>[].obs;

  /// Category keys matching the order of categories
  static const List<String> categoryKeys = [
    'all', 'rule_concept', 'culture', 'technique', 'road_signs', 'solving',
  ];

  @override
  void onInit() {
    super.onInit();
    totalQuestions.value = DataLocal.listQuestionsAll.length;
    refreshProgress();
  }

  void refreshProgress() {
    final catData = <Map<String, dynamic>>[];
    final titles = [
      "Học tổng hợp", "Khái niệm & Quy tắc", "Văn hóa & Đạo đức",
      "Kỹ thuật lái xe", "Biển báo đường bộ", "Giải thế Sa hình",
    ];
    final icons = ["book", "menu_book", "gavel", "tune", "traffic", "alt_route"];

    for (int i = 0; i < categoryKeys.length; i++) {
      final questions = _questionsForCategory(i);
      final doneIds = localService.getTheoryDoneIds(categoryKeys[i]);
      final done = doneIds.length;
      final total = questions.length;
      final progress = total > 0 ? done / total : 0.0;
      String progressText;
      if (done == 0) {
        progressText = "Chưa bắt đầu";
      } else if (done >= total) {
        progressText = "Hoàn thành";
      } else {
        progressText = "${(progress * 100).toInt()}% hoàn thành";
      }

      catData.add({
        'title': titles[i],
        'subtitle': "$total câu",
        'progress': progress,
        'progressText': progressText,
        'icon': icons[i],
      });
    }

    listCategories.value = catData
        .map((d) => TheoryCategory(
              title: d['title'],
              subtitle: d['subtitle'],
              progress: d['progress'],
              progressText: d['progressText'],
              icon: d['icon'],
            ))
        .toList();

    // Overall: unique question IDs across all categories
    final uniqueIds = localService.getTheoryAllUniqueIds();
    completedQuestions.value = uniqueIds.length;

    // Bookmarked count
    bookmarkedCount.value = localService.bookmarkedCount;
  }

  List<Question> _questionsForCategory(int index) {
    switch (index) {
      case 0: return DataLocal.listQuestionsAll;
      case 1: return DataLocal.listQuestionsRuleConcept;
      case 2: return DataLocal.listQuestionsCulture;
      case 3: return DataLocal.listQuestionsTechnique;
      case 4: return DataLocal.listQuestionsRoadSigns;
      case 5: return DataLocal.listQuestionsSolving;
      default: return [];
    }
  }

  void goBack() => Get.back();
  void viewAll() {}

  void openBookmarked() {
    Get.toNamed(AppPage.bookmarkedQuestions.routeName);
  }

  void openCategory(int index) {
    final category = listCategories[index];
    final questions = _questionsForCategory(index);
    if (questions.isEmpty) return;

    Get.toNamed(
      AppPage.theoryDetail.routeName,
      arguments: {
        'title': category.title,
        'categoryKey': categoryKeys[index],
        'questions': questions,
      },
    );
  }
}
