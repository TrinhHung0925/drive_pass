class TrafficSignItem {
  final String id;
  final String title;
  final String description;
  final String? imageFallbackPlaceholder;
  
  TrafficSignItem({
    required this.id,
    required this.title,
    required this.description,
    this.imageFallbackPlaceholder,
  });
}
