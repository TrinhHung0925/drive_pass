class ExamItem {
  final int id;
  final int status; // 0=not started, 1=passed, 2=failed, 3=in progress
  final String score;

  ExamItem({
    required this.id,
    required this.status,
    required this.score,
  });
}
