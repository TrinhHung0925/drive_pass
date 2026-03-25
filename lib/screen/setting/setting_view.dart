import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'setting_controller.dart';

class SettingView extends StatefulWidget {
  SettingView({super.key}) {
    if (!Get.isRegistered<SettingController>()) {
      Get.put(SettingController());
    }
  }

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  var controller = Get.find<SettingController>();

  @override
  void dispose() {
    Get.delete<SettingController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
