import 'package:get/get.dart';
import '../../route.dart';
import '../../service/local_service.dart';

class IntroItem {
  final String title;
  final String description;
  final String buttonLabel;

  const IntroItem({
    required this.title,
    required this.description,
    required this.buttonLabel,
  });
}

class IntroController extends GetxController {
  final localService = Get.find<LocalService>();
  final currentPage = 0.obs;

  final List<IntroItem> items = const [
    IntroItem(
      title: 'Ôn tập 600 câu hỏi',
      description:
          'Hệ thống câu hỏi sát thực tế, cập nhật mới nhất theo bộ đề của Cục Đường bộ Việt Nam.',
      buttonLabel: 'Next →',
    ),
    IntroItem(
      title: 'Thi thử sát thực tế',
      description:
          'Giao diện phòng thi chuyên nghiệp, tính thời gian như thi thật giúp bạn làm quen áp lực phòng thi.',
      buttonLabel: 'Tiếp tục',
    ),
    IntroItem(
      title: 'Mẹo thi từ chuyên gia',
      description:
          'Tổng hợp các mẹo ghi nhớ nhanh biển báo, sa hình và các lỗi thường gặp để đạt kết quả cao nhất.',
      buttonLabel: 'Bắt đầu ngay',
    ),
  ];

  bool get isLastPage => currentPage.value == items.length - 1;

  void updateCurrentPage(int index) {
    currentPage.value = index;
  }

  Future<void> completeIntro() async {
    await localService.setFirstLaunch(false);
    Get.offAllNamed(AppPage.homeTap.routeName);
  }
}
