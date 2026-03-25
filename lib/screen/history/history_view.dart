import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'history_controller.dart';

class HistoryView extends StatefulWidget {
  HistoryView({super.key}) {
    if (!Get.isRegistered<HistoryController>()) {
      Get.put(HistoryController());
    }
  }

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  var controller = Get.find<HistoryController>();

  @override
  void dispose() {
    Get.delete<HistoryController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
