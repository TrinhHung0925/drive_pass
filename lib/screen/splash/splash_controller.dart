import 'package:get/get.dart';
import '../../route.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  void _initializeApp() async {
    // Simulate initialization delay
    await Future.delayed(const Duration(seconds: 3));
    
    // Default logic: Route to home_tap after logic is done
    Get.offAllNamed(AppPage.homeTap.routeName);
  }

  onBack() {
    Get.back();
  }
}
