class BodySystemModel {
  final String id;
  final String name;
  final String description;
  final List<String> organs; // List of organ IDs
  final String icon; // Icon identifier or asset
  final int primaryColorHex;

  const BodySystemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.organs,
    required this.icon,
    this.primaryColorHex = 0xFF0066FF,
  });

  factory BodySystemModel.fromJson(Map<String, dynamic> json) {
    return BodySystemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      organs: List<String>.from(json['organs'] as List),
      icon: json['icon'] as String,
      primaryColorHex: json['primaryColorHex'] as int? ?? 0xFF0066FF,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'organs': organs,
      'icon': icon,
      'primaryColorHex': primaryColorHex,
    };
  }
}
