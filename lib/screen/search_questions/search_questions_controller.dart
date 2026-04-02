import 'package:get/get.dart';
import 'package:drive_pass/model/questions.dart';
import 'package:drive_pass/service/data_local.dart';
import '../../route.dart';

class SearchQuestionsController extends GetxController {
  final searchText = ''.obs;
  final results = <Question>[].obs;
  final isSearching = false.obs;

  void onSearchChanged(String value) {
    searchText.value = value;
    if (value.trim().isEmpty) {
      results.clear();
      isSearching.value = false;
      return;
    }
    isSearching.value = true;
    final keyword = value.trim().toLowerCase();
    results.value = DataLocal.listQuestionsAll.where((q) {
      if (q.question.toLowerCase().contains(keyword)) return true;
      for (final opt in q.options) {
        if (opt.text.toLowerCase().contains(keyword)) return true;
      }
      return false;
    }).toList();
  }

  void openQuestion(int indexInResults) {
    final question = results[indexInResults];
    // Find the global index in listQuestionsAll
    final globalIndex = DataLocal.listQuestionsAll.indexOf(question);
    Get.toNamed(
      AppPage.theoryDetail.routeName,
      arguments: {
        'title': 'Kết quả tìm kiếm',
        'categoryKey': 'all',
        'questions': [question],
      },
    );
  }

  void onBack() => Get.back();
}

