import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'exam_controller.dart';

class ExamView extends StatefulWidget {
  ExamView({super.key}) {
    if (!Get.isRegistered<ExamController>()) {
      Get.put(ExamController());
    }
  }

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {
  var controller = Get.find<ExamController>();

  @override
  void dispose() {
    Get.delete<ExamController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
