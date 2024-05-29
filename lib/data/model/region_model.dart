class RegionModel{
  final int id;
  final int resumeId;
  final String name;

  RegionModel({required this.id , required this.resumeId , required this.name});

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'] ?? 0,
      resumeId: json['resume_id'] ?? 0,
      name: json['name'] ?? "",
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resume_id': resumeId,
      'name': name,
    };
  }
}