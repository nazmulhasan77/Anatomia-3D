class OrganModel {
  final String id;
  final String name;
  final String category; // e.g., Cardiovascular, Respiratory
  final String description;
  final String location;
  final String function;
  final List<String> structure;
  final List<String> diseases;
  final String animation; // animation type/title
  final String imageUrl;
  final String systemId;
  final double bodyX; // Normalized X position on 3D body (0.0 to 1.0)
  final double bodyY; // Normalized Y position on 3D body (0.0 to 1.0)
  final double depthZ; // Depth coordinate
  final String latinName;
  final String funFact;

  const OrganModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.location,
    required this.function,
    required this.structure,
    required this.diseases,
    required this.animation,
    required this.imageUrl,
    required this.systemId,
    required this.bodyX,
    required this.bodyY,
    this.depthZ = 0.5,
    this.latinName = '',
    this.funFact = '',
  });

  factory OrganModel.fromJson(Map<String, dynamic> json) {
    return OrganModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      function: json['function'] as String,
      structure: List<String>.from(json['structure'] as List),
      diseases: List<String>.from(json['diseases'] as List),
      animation: json['animation'] as String,
      imageUrl: json['imageUrl'] as String,
      systemId: json['systemId'] as String? ?? 'general',
      bodyX: (json['bodyX'] as num?)?.toDouble() ?? 0.5,
      bodyY: (json['bodyY'] as num?)?.toDouble() ?? 0.5,
      depthZ: (json['depthZ'] as num?)?.toDouble() ?? 0.5,
      latinName: json['latinName'] as String? ?? '',
      funFact: json['funFact'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'location': location,
      'function': function,
      'structure': structure,
      'diseases': diseases,
      'animation': animation,
      'imageUrl': imageUrl,
      'systemId': systemId,
      'bodyX': bodyX,
      'bodyY': bodyY,
      'depthZ': depthZ,
      'latinName': latinName,
      'funFact': funFact,
    };
  }
}
