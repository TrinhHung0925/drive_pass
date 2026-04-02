import 'dart:convert';

import 'package:drive_pass/model/exam_item.dart';
import 'package:drive_pass/model/questions.dart';
import 'package:drive_pass/model/traffic_sign_item.dart';
import 'package:flutter/services.dart';

class DataLocal {
  static List<Question> listQuestionsAll = []; // Danh sách tất cả 600 câu hỏi
  static List<Question> listQuestionsCritical = [];// Danh sách 60 câu hỏi điểm liệt
  static List<Question> listQuestionsRoadSigns = [];// Danh sách 182 câu hỏi biển báo đường bộ
  static List<Question> listQuestionsSolving = [];// Danh sách 114 câu hỏi giải thế sa hình
  static List<Question> listQuestionsRuleConcept = [];// Danh sách 166 câu hỏi khái niệm & quy tắc
  static List<Question> listQuestionsTechnique = [];// Danh sách 56 câu hỏi kỹ thuật lái xe
  static List<Question> listQuestionsCulture = [];// Danh sách 21 câu hỏi văn hóa & đạo đức
  static List<ExamItem> listExam = [];// Danh sách 20 đề thi thử

  /// Traffic signs grouped by category name
  static Map<String, List<TrafficSignItem>> trafficSignCategories = {};

  static Future<void> getListQuestionsAll() async {
    final jsonString = await rootBundle.loadString("assets/data/questions.json");
    final List<dynamic> jsonList = jsonDecode(jsonString);
    listQuestionsAll = jsonList.map((e) => Question.fromJson(e)).toList();
    print("listQuestionsAll: ${listQuestionsAll.length}");
  }

  static Future<void> getListQuestionsCritical() async {
    final jsonString = await rootBundle.loadString("assets/data/questions_critical.json");
    final List<dynamic> jsonList = jsonDecode(jsonString);
    listQuestionsCritical = jsonList.map((e) => Question.fromJson(e)).toList();
    print("listQuestionsCritical: ${listQuestionsCritical.length}");
  }

  static Future<void> getListQuestionsRoadSigns() async {
    final jsonString = await rootBundle.loadString("assets/data/questions_bien_bao_duong_bo.json");
    final List<dynamic> jsonList = jsonDecode(jsonString);
    listQuestionsRoadSigns = jsonList.map((e) => Question.fromJson(e)).toList();
    print("listQuestionsRoadSigns: ${listQuestionsRoadSigns.length}");
  }

  static Future<void> getListQuestionsSolving() async {
    final jsonString = await rootBundle.loadString("assets/data/questions_giai_the_sa_hinh.json");
    final List<dynamic> jsonList = jsonDecode(jsonString);
    listQuestionsSolving = jsonList.map((e) => Question.fromJson(e)).toList();
    print("listQuestionsSolving: ${listQuestionsSolving.length}");
  }

  static Future<void> getListQuestionsRuleConcept() async {
    final jsonString = await rootBundle.loadString("assets/data/questions_khai_niem_quy_tac.json");
    final List<dynamic> jsonList = jsonDecode(jsonString);
    listQuestionsRuleConcept = jsonList.map((e) => Question.fromJson(e)).toList();
    print("listQuestionsRuleConcept: ${listQuestionsRuleConcept.length}");
  }

  static Future<void> getListQuestionsTechnique() async {
    final jsonString = await rootBundle.loadString("assets/data/questions_ky_thuat_lai_xe.json");
    final List<dynamic> jsonList = jsonDecode(jsonString);
    listQuestionsTechnique = jsonList.map((e) => Question.fromJson(e)).toList();
    print("listQuestionsTechnique: ${listQuestionsTechnique.length}");
  }

  static Future<void> getListQuestionsCulture() async {
    final jsonString = await rootBundle.loadString("assets/data/questions_van_hoa_dao_duc.json");
    final List<dynamic> jsonList = jsonDecode(jsonString);
    listQuestionsCulture = jsonList.map((e) => Question.fromJson(e)).toList();
    print("listQuestionsCulture: ${listQuestionsCulture.length}");
  }static Future<void> getListExamItem() async {
    final jsonString = await rootBundle.loadString("assets/data/exams.json");
    final List<dynamic> jsonList = jsonDecode(jsonString);
    listExam = jsonList.map((e) => ExamItem.fromJson(e)).toList();
    print("listExam: ${listExam.length}");
  }

  static Future<void> getListTrafficSigns() async {
    final jsonString = await rootBundle.loadString("assets/data/traffic.json");
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    trafficSignCategories = {};
    for (final entry in jsonMap.entries) {
      final List<dynamic> items = entry.value;
      trafficSignCategories[entry.key] =
          items.map((e) => TrafficSignItem.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    print("trafficSignCategories: ${trafficSignCategories.keys.toList()}, total: ${trafficSignCategories.values.fold(0, (sum, list) => sum + list.length)}");
  }
}
