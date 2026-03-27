class TheoryCategory {
  final String title;
  final String subtitle;
  final double progress;
  final String progressText;
  final String icon;
  final bool isCritical;

  TheoryCategory({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.progressText,
    required this.icon,
    this.isCritical = false,
  });
}
