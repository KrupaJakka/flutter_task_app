class Assessment {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  Assessment({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Assessment.fromMap(String id, Map<String, dynamic> data) {
    return Assessment(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'description': description, 'imageUrl': imageUrl};
  }
}
