class QuizModel {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String? organId;
  final String difficulty; // Easy, Medium, Hard

  const QuizModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.organId,
    this.difficulty = 'Medium',
  });

  String get answer => options[correctOptionIndex];

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as String,
      question: json['question'] as String,
      options: List<String>.from(json['options'] as List),
      correctOptionIndex: json['correctOptionIndex'] as int,
      explanation: json['explanation'] as String,
      organId: json['organId'] as String?,
      difficulty: json['difficulty'] as String? ?? 'Medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
      'organId': organId,
      'difficulty': difficulty,
    };
  }
}
