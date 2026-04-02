import 'package:get/get.dart';
import 'package:drive_pass/model/violation_item.dart';
import 'package:drive_pass/service/data_local.dart';

class ViolationsController extends GetxController {
  final searchText = ''.obs;
  final allViolations = <ViolationItem>[].obs;
  final filteredViolations = <ViolationItem>[].obs;
  final isSearching = false.obs;
  final selectedTopicCode = (-1).obs;

  /// Unique topic codes
  final topicCodes = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    allViolations.value = DataLocal.listViolations;
    filteredViolations.value = allViolations;

    // Extract unique topic codes
    final codes = allViolations.map((e) => e.topicCode).toSet().toList();
    codes.sort();
    topicCodes.value = codes;
  }

  void selectTopic(int topicCode) {
    if (selectedTopicCode.value == topicCode) {
      selectedTopicCode.value = -1; // Deselect
    } else {
      selectedTopicCode.value = topicCode;
    }
    _applyFilters();
  }

  void onSearchChanged(String value) {
    searchText.value = value;
    isSearching.value = value.trim().isNotEmpty;
    _applyFilters();
  }

  void _applyFilters() {
    var results = List<ViolationItem>.from(allViolations);

    // Filter by topic
    if (selectedTopicCode.value != -1) {
      results = results.where((v) => v.topicCode == selectedTopicCode.value).toList();
    }

    // Filter by search text
    if (searchText.value.trim().isNotEmpty) {
      final keyword = searchText.value.trim().toLowerCase();
      results = results.where((v) {
        return v.violation.toLowerCase().contains(keyword) ||
            v.fines.toLowerCase().contains(keyword) ||
            v.entities.toLowerCase().contains(keyword) ||
            v.additionalPenalties.toLowerCase().contains(keyword);
      }).toList();
    }

    filteredViolations.value = results;
  }

  void onBack() => Get.back();
}

