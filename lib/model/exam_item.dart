class ExamItem {
  final String licenseCode;
  final List<String> licenseCodes;
  final int examNo;
  final List<int> questionNos;

  ExamItem({
    required this.licenseCode,
    required this.licenseCodes,
    required this.examNo,
    required this.questionNos,
  });

  factory ExamItem.fromJson(Map<String, dynamic> json) {
    return ExamItem(
      licenseCode: json['licenseCode'] ?? '',
      licenseCodes: List<String>.from(json['licenseCodes'] ?? []),
      examNo: json['examNo'] ?? 0,
      questionNos: List<int>.from(json['questionNos'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "licenseCode": licenseCode,
      "licenseCodes": licenseCodes,
      "examNo": examNo,
      "questionNos": questionNos,
    };
  }
}
