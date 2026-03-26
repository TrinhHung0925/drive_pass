import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../service/local_service.dart';
import '../home/home_controller.dart';

class EditProfileController extends GetxController {
  final localService = Get.find<LocalService>();
  
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  var avatarPath = "".obs;

  @override
  void onInit() {
    super.onInit();
    nameController.text = localService.userName;
    phoneController.text = localService.userPhone;
    avatarPath.value = localService.userAvatar;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        avatarPath.value = pickedFile.path;
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể chọn ảnh: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  void saveProfile() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    
    if (name.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập tên", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    
    localService.setUserName(name);
    localService.setUserPhone(phone);
    localService.setUserAvatar(avatarPath.value);
    
    // Refresh home screen if it's already in memory
    if (Get.isRegistered<HomeController>()) {
      Get.find<HomeController>().loadProfile();
    }
    
    Get.back(result: true);
  }

  void onBack() {
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
