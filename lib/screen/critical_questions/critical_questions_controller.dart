import 'package:drive_pass/model/questions.dart';
import 'package:get/get.dart';

class CriticalQuestionsController extends GetxController {
  final completed = 12.obs;
  final total = 60.obs;


  void goBack() => Get.back();
  void openQuestion(Question itemQuestions) {}
}
