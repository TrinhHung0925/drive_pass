class TrafficSignItem {
  final String id;
  final String title;
  final String description;
  final String? image;

  TrafficSignItem({
    required this.id,
    required this.title,
    required this.description,
    this.image,
  });

  factory TrafficSignItem.fromJson(Map<String, dynamic> json) {
    return TrafficSignItem(
      id: json['id'].toString(),
      title: json['name'] ?? '',
      description: json['des'] ?? '',
      image: json['image'],
    );
  }
}
