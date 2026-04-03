class ExamTip {
  final int id;
  final String title;
  final String summary;
  final String content;
  final String icon;

  ExamTip({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    this.icon = '',
  });

  factory ExamTip.fromJson(Map<String, dynamic> json) {
    return ExamTip(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class TipCategory {
  final String id;
  final String title;
  final String icon;
  final String color;
  final String description;
  final List<ExamTip> tips;

  TipCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.tips,
  });

  factory TipCategory.fromJson(Map<String, dynamic> json) {
    return TipCategory(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
      color: json['color'] ?? '#1F89E5',
      description: json['description'] ?? '',
      tips: (json['tips'] as List?)?.map((e) => ExamTip.fromJson(e)).toList() ?? [],
    );
  }
}

class FeaturedTip {
  final String title;
  final String summary;
  final String image;
  final String readTime;
  final String content;

  FeaturedTip({
    required this.title,
    required this.summary,
    required this.image,
    required this.readTime,
    required this.content,
  });

  factory FeaturedTip.fromJson(Map<String, dynamic> json) {
    return FeaturedTip(
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      image: json['image'] ?? '',
      readTime: json['readTime'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
