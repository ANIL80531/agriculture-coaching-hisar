import 'dart:async';
import 'package:flutter/material.dart';
import '../models/mcq_model.dart';
import '../services/mock_database.dart';
import '../services/storage_service.dart';

class McqProvider extends ChangeNotifier {
  List<McqQuiz> _quizzes = [];

  // Active student quiz-taking state
  McqQuiz? _activeQuiz;
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {}; // questionIndex -> selectedOptionIndex
  int _remainingSeconds = 0;
  Timer? _timer;
  bool _isQuizCompleted = false;
  McqQuizAttempt? _latestAttempt;

  List<McqQuiz> get quizzes => _quizzes;
  McqQuiz? get activeQuiz => _activeQuiz;
  int get currentQuestionIndex => _currentQuestionIndex;
  Map<int, int> get selectedAnswers => _selectedAnswers;
  int get remainingSeconds => _remainingSeconds;
  bool get isQuizCompleted => _isQuizCompleted;
  McqQuizAttempt? get latestAttempt => _latestAttempt;

  String get formattedRemainingTime {
    final minutes = (_remainingSeconds / 60).floor();
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  McqProvider() {
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    final initial = MockDatabase.getInitialQuizzes();
    final custom = await StorageService.getCustomQuizzes();
    _quizzes = [...custom, ...initial];
    notifyListeners();
  }

  McqQuiz? getQuizById(String quizId) {
    try {
      return _quizzes.firstWhere((q) => q.id == quizId);
    } catch (_) {
      return null;
    }
  }

  List<McqQuiz> getQuizzesForCourse(String courseId) {
    return _quizzes.where((q) => q.courseId == courseId).toList();
  }

  // --- Student Quiz Taking Workflow ---

  void startQuiz(McqQuiz quiz) {
    _activeQuiz = quiz;
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _isQuizCompleted = false;
    _latestAttempt = null;
    _remainingSeconds = quiz.durationMinutes * 60;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _timer?.cancel();
        submitQuiz(userId: 'auto_submit');
      }
    });

    notifyListeners();
  }

  void selectAnswer(int questionIndex, int optionIndex) {
    _selectedAnswers[questionIndex] = optionIndex;
    notifyListeners();
  }

  void nextQuestion() {
    if (_activeQuiz != null && _currentQuestionIndex < _activeQuiz!.questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void jumpToQuestion(int index) {
    if (_activeQuiz != null && index >= 0 && index < _activeQuiz!.questions.length) {
      _currentQuestionIndex = index;
      notifyListeners();
    }
  }

  void submitQuiz({required String userId}) {
    _timer?.cancel();
    if (_activeQuiz == null) return;

    int correctCount = 0;
    int totalScore = 0;
    final maxScore = _activeQuiz!.totalMarks;

    for (int i = 0; i < _activeQuiz!.questions.length; i++) {
      final question = _activeQuiz!.questions[i];
      final selectedOpt = _selectedAnswers[i];
      if (selectedOpt != null && selectedOpt == question.correctOptionIndex) {
        correctCount++;
        totalScore += question.marks;
      }
    }

    final percentage = maxScore > 0 ? (totalScore / maxScore) * 100 : 0.0;
    final isPassed = percentage >= _activeQuiz!.passingPercentage;
    final timeSpent = (_activeQuiz!.durationMinutes * 60) - _remainingSeconds;

    _latestAttempt = McqQuizAttempt(
      quizId: _activeQuiz!.id,
      quizTitle: _activeQuiz!.title,
      courseId: _activeQuiz!.courseId,
      userId: userId,
      userAnswers: Map.from(_selectedAnswers),
      correctCount: correctCount,
      totalQuestions: _activeQuiz!.questions.length,
      totalScore: totalScore,
      maxScore: maxScore,
      percentage: double.parse(percentage.toStringAsFixed(1)),
      isPassed: isPassed,
      timeSpentSeconds: timeSpent > 0 ? timeSpent : 0,
      attemptedAt: DateTime.now(),
    );

    _isQuizCompleted = true;
    notifyListeners();
  }

  void resetQuizSession() {
    _timer?.cancel();
    _activeQuiz = null;
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _isQuizCompleted = false;
    _latestAttempt = null;
    notifyListeners();
  }

  // --- Educator Quiz Creation Workflow ---

  Future<void> createAndPublishQuiz(McqQuiz newQuiz) async {
    _quizzes.insert(0, newQuiz);
    final customList = _quizzes.where((q) => !q.id.startsWith('quiz_1')).toList();
    await StorageService.saveCustomQuizzes(customList);
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
