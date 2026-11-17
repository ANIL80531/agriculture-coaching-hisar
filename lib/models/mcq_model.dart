class McqQuestion {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final int marks;

  const McqQuestion({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.marks = 1,
  });

  McqQuestion copyWith({
    String? id,
    String? questionText,
    List<String>? options,
    int? correctOptionIndex,
    String? explanation,
    int? marks,
  }) {
    return McqQuestion(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      explanation: explanation ?? this.explanation,
      marks: marks ?? this.marks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questionText': questionText,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
      'explanation': explanation,
      'marks': marks,
    };
  }

  factory McqQuestion.fromJson(Map<String, dynamic> json) {
    return McqQuestion(
      id: json['id'] as String,
      questionText: json['questionText'] as String,
      options: List<String>.from(json['options'] ?? []),
      correctOptionIndex: json['correctOptionIndex'] as int,
      explanation: json['explanation'] as String? ?? '',
      marks: json['marks'] as int? ?? 1,
    );
  }
}

class McqQuiz {
  final String id;
  final String courseId;
  final String courseTitle;
  final String title;
  final String description;
  final int durationMinutes;
  final double passingPercentage;
  final List<McqQuestion> questions;
  final String createdBy;
  final DateTime createdAt;

  const McqQuiz({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.title,
    required this.description,
    this.durationMinutes = 15,
    this.passingPercentage = 60.0,
    required this.questions,
    required this.createdBy,
    required this.createdAt,
  });

  int get totalMarks => questions.fold(0, (sum, q) => sum + q.marks);
  int get totalQuestions => questions.length;

  McqQuiz copyWith({
    String? id,
    String? courseId,
    String? courseTitle,
    String? title,
    String? description,
    int? durationMinutes,
    double? passingPercentage,
    List<McqQuestion>? questions,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return McqQuiz(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      title: title ?? this.title,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      passingPercentage: passingPercentage ?? this.passingPercentage,
      questions: questions ?? this.questions,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'title': title,
      'description': description,
      'durationMinutes': durationMinutes,
      'passingPercentage': passingPercentage,
      'questions': questions.map((q) => q.toJson()).toList(),
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory McqQuiz.fromJson(Map<String, dynamic> json) {
    return McqQuiz(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      courseTitle: json['courseTitle'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 15,
      passingPercentage: (json['passingPercentage'] as num?)?.toDouble() ?? 60.0,
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((q) => McqQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
      createdBy: json['createdBy'] as String? ?? 'educator',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }
}

class McqQuizAttempt {
  final String quizId;
  final String quizTitle;
  final String courseId;
  final String userId;
  final Map<int, int> userAnswers; // questionIndex -> selectedOptionIndex
  final int correctCount;
  final int totalQuestions;
  final int totalScore;
  final int maxScore;
  final double percentage;
  final bool isPassed;
  final int timeSpentSeconds;
  final DateTime attemptedAt;

  const McqQuizAttempt({
    required this.quizId,
    required this.quizTitle,
    required this.courseId,
    required this.userId,
    required this.userAnswers,
    required this.correctCount,
    required this.totalQuestions,
    required this.totalScore,
    required this.maxScore,
    required this.percentage,
    required this.isPassed,
    required this.timeSpentSeconds,
    required this.attemptedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'quizTitle': quizTitle,
      'courseId': courseId,
      'userId': userId,
      'userAnswers': userAnswers.map((k, v) => MapEntry(k.toString(), v)),
      'correctCount': correctCount,
      'totalQuestions': totalQuestions,
      'totalScore': totalScore,
      'maxScore': maxScore,
      'percentage': percentage,
      'isPassed': isPassed,
      'timeSpentSeconds': timeSpentSeconds,
      'attemptedAt': attemptedAt.toIso8601String(),
    };
  }
}
