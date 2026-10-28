import 'package:drive_pass/common/exam_rules.dart';

class ExamHistory {
  final int examNo;
  final int correct;
  final int total;
  final String timeTaken;
  final String dateTaken;
  final int timestamp; // millisecondsSinceEpoch — unique per attempt
  final bool criticalFailed; // wrong answer on the critical (điểm liệt) question

  ExamHistory({
    required this.examNo,
    required this.correct,
    required this.total,
    required this.timeTaken,
    required this.dateTaken,
    required this.timestamp,
    this.criticalFailed = false,
  });

  /// Passed = at least ExamRules.passingScore correct and no critical question missed
  bool get passed => total > 0 && ExamRules.isPassed(correct: correct, criticalFailed: criticalFailed);

  int get score => total > 0 ? ((correct / total) * 100).round() : 0;

  factory ExamHistory.fromJson(Map<String, dynamic> json) {
    return ExamHistory(
      examNo: json['examNo'] ?? 0,
      correct: json['correct'] ?? 0,
      total: json['total'] ?? 0,
      timeTaken: json['timeTaken'] ?? '00:00',
      dateTaken: json['dateTaken'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      criticalFailed: json['criticalFailed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'examNo': examNo,
        'correct': correct,
        'total': total,
        'timeTaken': timeTaken,
        'dateTaken': dateTaken,
        'timestamp': timestamp,
        'criticalFailed': criticalFailed,
      };
}

