import 'package:flutter/material.dart';
import '../models/quiz_model.dart';
import '../services/anatomy_data_service.dart';

class QuizProvider extends ChangeNotifier {
  List<QuizModel> _questions = [];
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  bool _isAnswerSubmitted = false;
  int _score = 0;
  int _pointsEarned = 0;
  bool _isQuizCompleted = false;

  QuizProvider() {
    initQuiz();
  }

  // Getters
  List<QuizModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  int? get selectedOptionIndex => _selectedOptionIndex;
  bool get isAnswerSubmitted => _isAnswerSubmitted;
  int get score => _score;
  int get pointsEarned => _pointsEarned;
  bool get isQuizCompleted => _isQuizCompleted;

  QuizModel? get currentQuestion {
    if (_questions.isEmpty || _currentIndex >= _questions.length) return null;
    return _questions[_currentIndex];
  }

  bool get isCurrentAnswerCorrect {
    if (currentQuestion == null || _selectedOptionIndex == null) return false;
    return _selectedOptionIndex == currentQuestion!.correctOptionIndex;
  }

  void initQuiz() {
    _questions = List.from(AnatomyDataService.quizzes);
    _currentIndex = 0;
    _selectedOptionIndex = null;
    _isAnswerSubmitted = false;
    _score = 0;
    _pointsEarned = 0;
    _isQuizCompleted = false;
    notifyListeners();
  }

  void selectOption(int index) {
    if (_isAnswerSubmitted) return; // Prevent changing after submission
    _selectedOptionIndex = index;
    notifyListeners();
  }

  void submitAnswer() {
    if (_selectedOptionIndex == null || _isAnswerSubmitted) return;
    _isAnswerSubmitted = true;
    if (isCurrentAnswerCorrect) {
      _score += 1;
      _pointsEarned += 25; // 25 XP per correct answer
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex += 1;
      _selectedOptionIndex = null;
      _isAnswerSubmitted = false;
    } else {
      _isQuizCompleted = true;
    }
    notifyListeners();
  }

  void restartQuiz() {
    initQuiz();
  }
}
