class DiseaseComparisonItem {
  final String metric;
  final String healthyValue;
  final String diseasedValue;

  const DiseaseComparisonItem({
    required this.metric,
    required this.healthyValue,
    required this.diseasedValue,
  });

  factory DiseaseComparisonItem.fromJson(Map<String, dynamic> json) {
    return DiseaseComparisonItem(
      metric: json['metric'] as String,
      healthyValue: json['healthyValue'] as String,
      diseasedValue: json['diseasedValue'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metric': metric,
      'healthyValue': healthyValue,
      'diseasedValue': diseasedValue,
    };
  }
}

class DiseaseModel {
  final String id;
  final String organId;
  final String organName;
  final String diseaseName;
  final String subtitle;
  final String overview;
  final List<DiseaseComparisonItem> comparisons;
  final List<String> symptoms;
  final List<String> causes;
  final List<String> prevention;
  final String healthyColor;
  final String diseasedColor;

  const DiseaseModel({
    required this.id,
    required this.organId,
    required this.organName,
    required this.diseaseName,
    required this.subtitle,
    required this.overview,
    required this.comparisons,
    required this.symptoms,
    required this.causes,
    required this.prevention,
    this.healthyColor = '#4CAF50',
    this.diseasedColor = '#E53935',
  });

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
      id: json['id'] as String,
      organId: json['organId'] as String,
      organName: json['organName'] as String,
      diseaseName: json['diseaseName'] as String,
      subtitle: json['subtitle'] as String,
      overview: json['overview'] as String,
      comparisons: (json['comparisons'] as List)
          .map((e) => DiseaseComparisonItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      symptoms: List<String>.from(json['symptoms'] as List),
      causes: List<String>.from(json['causes'] as List),
      prevention: List<String>.from(json['prevention'] as List),
      healthyColor: json['healthyColor'] as String? ?? '#4CAF50',
      diseasedColor: json['diseasedColor'] as String? ?? '#E53935',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organId': organId,
      'organName': organName,
      'diseaseName': diseaseName,
      'subtitle': subtitle,
      'overview': overview,
      'comparisons': comparisons.map((e) => e.toJson()).toList(),
      'symptoms': symptoms,
      'causes': causes,
      'prevention': prevention,
      'healthyColor': healthyColor,
      'diseasedColor': diseasedColor,
    };
  }
}
