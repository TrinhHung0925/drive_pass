class ExamHistory {
  final int examNo;
  final int correct;
  final int total;
  final String timeTaken;
  final String dateTaken;
  final int timestamp; // millisecondsSinceEpoch — unique per attempt

  ExamHistory({
    required this.examNo,
    required this.correct,
    required this.total,
    required this.timeTaken,
    required this.dateTaken,
    required this.timestamp,
  });

  /// Passed = correct / total >= 80%
  bool get passed => total > 0 && (correct / total) >= 0.8;

  int get score => total > 0 ? ((correct / total) * 100).round() : 0;

  factory ExamHistory.fromJson(Map<String, dynamic> json) {
    return ExamHistory(
      examNo: json['examNo'] ?? 0,
      correct: json['correct'] ?? 0,
      total: json['total'] ?? 0,
      timeTaken: json['timeTaken'] ?? '00:00',
      dateTaken: json['dateTaken'] ?? '',
      timestamp: json['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'examNo': examNo,
        'correct': correct,
        'total': total,
        'timeTaken': timeTaken,
        'dateTaken': dateTaken,
        'timestamp': timestamp,
      };
}

