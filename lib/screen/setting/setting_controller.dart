import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../service/local_service.dart';

class SettingController extends GetxController {
  final localService = Get.find<LocalService>();
  var isDarkMode = false.obs;
  var userName = "".obs;
  var userPhone = "".obs;
  var userAvatarPath = "".obs;
  
  var isNotificationEnabled = true.obs;
  var isReminderEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = localService.isDarkMode;
    _loadProfile();
  }

  void _loadProfile() {
    userName.value = localService.userName;
    userPhone.value = localService.userPhone;
    userAvatarPath.value = localService.userAvatar;
  }

  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    localService.setDarkMode(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    
    // Force a full app rebuild so AppColors getters update across all screens
    Future.delayed(const Duration(milliseconds: 150), () {
      Get.forceAppUpdate();
    });
  }

  void toggleNotification(bool value) {
    isNotificationEnabled.value = value;
  }

  void toggleReminder(bool value) {
    isReminderEnabled.value = value;
  }

  void goToEditProfile() async {
    final result = await Get.toNamed('/edit_profile');
    if (result == true) {
      _loadProfile(); // Refresh profile after returning from edit
    }
  }

  void onBack() {
    Get.back();
  }
}
