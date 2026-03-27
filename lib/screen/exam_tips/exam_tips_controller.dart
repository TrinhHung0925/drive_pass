import 'package:get/get.dart';
import '../../model/exam_tip.dart';

class ExamTipsController extends GetxController {
  final List<ExamTip> theoryTips = [
    ExamTip(
      title: "Câu hỏi nhường đường",
      content: "Nhường đường cho xe đi theo chiều ngược lại khi có vật cản ở phía mình. Tại nơi giao nhau không có báo hiệu đi theo vòng xuyến, phải nhường đường cho xe đi đến từ bên phải."
    ),
    ExamTip(
      title: "Tốc độ giới hạn",
      content: "Trong khu vực đông dân cư, xe cơ giới được phép chạy tối đa 60km/h (có dải phân cách giữa) hoặc 50km/h (không có dải phân cách)."
    ),
    ExamTip(
      title: "Nồng độ cồn",
      content: "Nghiêm cấm người điều khiển xe ô tô, mô tô, xe gắn máy có nồng độ cồn trong máu hoặc hơi thở. Mức phạt rất nặng đối với các hành vi vi phạm."
    ),
    ExamTip(
      title: "Biển báo cấm",
      content: "Biển báo cấm máy kéo thì không cấm ô tô tải. Biển báo cấm ô tô tải thì cấm máy kéo. Biển cấm rẽ trái thì cấm cả quay đầu xe (theo luật cũ) - nhưng luật mới chỉ cấm rẽ thì KHÔNG cấm quay đầu, và học viên cần chú ý luật thi áp dụng."
    ),
    ExamTip(
      title: "Quyền ưu tiên",
      content: "Thứ tự ưu tiên: Xe chữa cháy > Xe quân sự/công an > Xe cứu thương > Xe hộ đê > Chờ đi làm nhiệm vụ khẩn cấp. Ghi nhớ: Hỏa - Sự - Công - Thương."
    )
  ];

  final List<ExamTip> practicalTips = [
    ExamTip(
      title: "Mẹo dừng xe nhường đường cho người đi bộ",
      content: "Dừng xe đúng vạch, khoảng cách từ cản xe phía trước đến vạch dừng không quá 50cm. Canh điểm chuẩn bệ bước chân ngang với cột biển báo dừng."
    ),
    ExamTip(
      title: "Mẹo lùi xe vào nơi đỗ (Ghép dọc)",
      content: "Tiến xe thật chậm để vai người lái ngang chính giữa chuồng thì đánh hết lái sang phải. Mắt nhìn gương trái, khi đuôi xe nhô tới vạch sơn quy định thì trả thắng lái và lùi lại."
    ),
    ExamTip(
      title: "Mẹo qua vệt bánh xe (Đinh)",
      content: "Chạy với tốc độ rùa bò. Lấy một điểm chuẩn trên xe (thường là gạt nước) để canh thẳng đứng với cột mốc trước mặt. Giữ cực kỳ ổn định tay lái."
    ),
    ExamTip(
      title: "Mẹo ghép xe ngang vào nơi đỗ",
      content: "Dừng xe song song cách xe trước 50-80cm, lùi chéo đuôi xe vào. Khi gương chiếu hậu trái nhìn thấy toàn bộ đầu xe sau thì bắt đầu trả lùi thẳng."
    ),
    ExamTip(
      title: "Thay đổi số trên đường thẳng",
      content: "Từ số 1 tăng lên số 2 trước bảng 20 màu xanh, đạt tốc độ >20km/h. Khi qua biển 20 màu trắng thì hãy phanh hãm chậm lại dưới 20km/h và trả về số 1."
    )
  ];
}
