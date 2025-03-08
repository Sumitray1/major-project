class ImageData {
  final String id;
  final String name;
  final String type;
  final String path;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  ImageData({
    required this.id,
    required this.name,
    required this.type,
    required this.path,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      path: json['path'],
      isDeleted: json['isDeleted'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}