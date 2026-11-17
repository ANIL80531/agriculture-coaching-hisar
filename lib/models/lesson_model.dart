enum LessonType {
  video,
  pdf,
  quiz,
  liveRecord,
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final int durationMinutes;
  final LessonType type;
  final String contentUrl;
  final bool isFreePreview;
  final bool isCompleted;
  final String? attachedPdfUrl;
  final String? linkedQuizId;
  final String? linkedPptId;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    this.type = LessonType.video,
    required this.contentUrl,
    this.isFreePreview = false,
    this.isCompleted = false,
    this.attachedPdfUrl,
    this.linkedQuizId,
    this.linkedPptId,
  });

  Lesson copyWith({
    String? id,
    String? title,
    String? description,
    int? durationMinutes,
    LessonType? type,
    String? contentUrl,
    bool? isFreePreview,
    bool? isCompleted,
    String? attachedPdfUrl,
    String? linkedQuizId,
    String? linkedPptId,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      type: type ?? this.type,
      contentUrl: contentUrl ?? this.contentUrl,
      isFreePreview: isFreePreview ?? this.isFreePreview,
      isCompleted: isCompleted ?? this.isCompleted,
      attachedPdfUrl: attachedPdfUrl ?? this.attachedPdfUrl,
      linkedQuizId: linkedQuizId ?? this.linkedQuizId,
      linkedPptId: linkedPptId ?? this.linkedPptId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'durationMinutes': durationMinutes,
      'type': type.name,
      'contentUrl': contentUrl,
      'isFreePreview': isFreePreview,
      'isCompleted': isCompleted,
      'attachedPdfUrl': attachedPdfUrl,
      'linkedQuizId': linkedQuizId,
      'linkedPptId': linkedPptId,
    };
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 15,
      type: LessonType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => LessonType.video,
      ),
      contentUrl: json['contentUrl'] as String? ?? '',
      isFreePreview: json['isFreePreview'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      attachedPdfUrl: json['attachedPdfUrl'] as String?,
      linkedQuizId: json['linkedQuizId'] as String?,
      linkedPptId: json['linkedPptId'] as String?,
    );
  }
}

class CourseModule {
  final String id;
  final String title;
  final String description;
  final int order;
  final List<Lesson> lessons;

  const CourseModule({
    required this.id,
    required this.title,
    this.description = '',
    required this.order,
    required this.lessons,
  });

  int get totalMinutes => lessons.fold(0, (sum, item) => sum + item.durationMinutes);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'order': order,
      'lessons': lessons.map((l) => l.toJson()).toList(),
    };
  }

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    return CourseModule(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      order: json['order'] as int? ?? 1,
      lessons: (json['lessons'] as List<dynamic>? ?? [])
          .map((item) => Lesson.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
