import 'package:get/get.dart';
import '../../model/theory_category.dart';

class TheoryController extends GetxController {
  final completedQuestions = 120.obs;
  final totalQuestions = 600.obs;

  double get totalProgress => totalQuestions.value > 0 
      ? completedQuestions.value / totalQuestions.value 
      : 0.0;

  final RxList<TheoryCategory> categories = <TheoryCategory>[
    TheoryCategory(
      title: "Học tổng hợp",
      subtitle: "600 câu",
      progress: 0.2,
      progressText: "20% hoàn thành",
      icon: "book",
    ),
    TheoryCategory(
      title: "Khái niệm & Quy tắc",
      subtitle: "166 câu",
      progress: 0.45,
      progressText: "45% hoàn thành",
      icon: "menu_book",
    ),
    TheoryCategory(
      title: "Văn hóa & Đạo đức",
      subtitle: "21 câu",
      progress: 0.59,
      progressText: "59% hoàn thành",
      icon: "gavel",
    ),
    TheoryCategory(
      title: "Kỹ thuật lái xe",
      subtitle: "56 câu",
      progress: 0.0,
      progressText: "Chưa bắt đầu",
      icon: "tune",
    ),
    TheoryCategory(
      title: "Biển báo đường bộ",
      subtitle: "182 câu",
      progress: 0.32,
      progressText: "32% hoàn thành",
      icon: "traffic",
    ),
    TheoryCategory(
      title: "Giải thế Sa hình",
      subtitle: "114 câu",
      progress: 0.11,
      progressText: "11% hoàn thành",
      icon: "alt_route",
    )
  ].obs;

  void goBack() => Get.back();
  void viewAll() {}
  void openCategory(int index) {}
}
