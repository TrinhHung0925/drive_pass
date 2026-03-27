import 'package:get/get.dart';
import '../../model/critical_question.dart';

class CriticalQuestionsController extends GetxController {
  final completed = 12.obs;
  final total = 60.obs;

  final RxList<CriticalQuestion> questions = <CriticalQuestion>[
    CriticalQuestion(
      id: 17,
      text: "Hành vi đưa xe cơ giới không bảo đảm tiêu chuẩn an toàn kỹ thuật vào tham gia giao thông...",
      status: "CHƯA LÀM",
      tag: "Cực kỳ nghiêm trọng",
      icon: "warning",
    ),
    CriticalQuestion(
      id: 21,
      text: "Sử dụng rượu, bia khi lái xe, nếu bị phát hiện thì bị xử lý như thế nào?",
      status: "ĐÃ THUỘC",
      tag: "Nồng độ cồn",
      icon: "local_bar",
    ),
    CriticalQuestion(
      id: 25,
      text: "Hành vi điều khiển xe cơ giới chạy quá tốc độ quy định, giành đường, vượt ẩu có bị nghiêm cấm...",
      status: "CHƯA LÀM",
      tag: "Tốc độ & Vượt ẩu",
      icon: "speed",
    ),
    CriticalQuestion(
      id: 32,
      text: "Tại nơi đường bộ giao nhau cùng mức với đường sắt, người điều khiển phương tiện phải...",
      status: "CHƯA LÀM",
      tag: "Giao cắt đường sắt",
      icon: "train",
    ),
  ].obs;

  void goBack() => Get.back();
  void filterQuestions() {}
  void openQuestion(int id) {}
}
