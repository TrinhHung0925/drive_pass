import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../model/exam_tip.dart';

class ExamTipsController extends GetxController {
  final categories = <TipCategory>[].obs;
  final featured = Rxn<FeaturedTip>();
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTips();
  }

  Future<void> _loadTips() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/exam_tips.json');
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;

      if (data['featured'] != null) {
        featured.value = FeaturedTip.fromJson(data['featured']);
      }

      if (data['categories'] != null) {
        categories.value = (data['categories'] as List)
            .map((e) => TipCategory.fromJson(e))
            .toList();
      }
    } catch (e) {
      print('Error loading tips: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
