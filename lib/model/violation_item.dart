class ViolationItem {
  final int no;
  final String violation;
  final String entities;
  final String fines;
  final String additionalPenalties;
  final String remedial;
  final int code;
  final int topicCode;
  final int pointsDeducted;
  final String legalBasis;
  final String keyword;

  ViolationItem({
    required this.no,
    required this.violation,
    required this.entities,
    required this.fines,
    required this.additionalPenalties,
    required this.remedial,
    required this.code,
    required this.topicCode,
    this.pointsDeducted = 0,
    this.legalBasis = '',
    this.keyword = '',
  });

  factory ViolationItem.fromJson(Map<String, dynamic> json) {
    return ViolationItem(
      no: json['no'] ?? 0,
      violation: json['violation'] ?? '',
      entities: json['entities'] ?? '',
      fines: json['fines'] ?? '',
      additionalPenalties: json['additionalPenalties'] ?? '',
      remedial: json['remedial'] ?? '',
      code: json['code'] ?? 0,
      topicCode: json['topicCode'] ?? 0,
      pointsDeducted: json['pointsDeducted'] ?? 0,
      legalBasis: json['legalBasis'] ?? '',
      keyword: json['keyword'] ?? '',
    );
  }

  /// Topic name based on topicCode
  static String topicName(int topicCode) {
    switch (topicCode) {
      case 1: return 'Biển báo, vạch kẻ đường';
      case 2: return 'Vượt xe, chuyển hướng';
      case 3: return 'Dừng xe, đỗ xe';
      case 4: return 'Còi, âm thanh';
      case 5: return 'Khoảng cách, tốc độ';
      case 6: return 'Chở hàng, chở người';
      case 7: return 'Giấy tờ, biển số';
      case 8: return 'Khu vực cấm';
      case 9: return 'Nồng độ cồn, ma tuý';
      case 10: return 'Đăng ký, cải tạo xe';
      case 11: return 'Vi phạm khác';
      default: return 'Khác';
    }
  }
}

