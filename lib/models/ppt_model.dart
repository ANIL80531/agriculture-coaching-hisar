class PptSlide {
  final int slideNumber;
  final String title;
  final String subtitle;
  final List<String> bulletPoints;
  final String? codeSnippet;
  final String? diagramType; // e.g. 'architecture', 'flowchart', 'comparison'
  final String? notes;

  const PptSlide({
    required this.slideNumber,
    required this.title,
    this.subtitle = '',
    required this.bulletPoints,
    this.codeSnippet,
    this.diagramType,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'slideNumber': slideNumber,
      'title': title,
      'subtitle': subtitle,
      'bulletPoints': bulletPoints,
      'codeSnippet': codeSnippet,
      'diagramType': diagramType,
      'notes': notes,
    };
  }

  factory PptSlide.fromJson(Map<String, dynamic> json) {
    return PptSlide(
      slideNumber: json['slideNumber'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      bulletPoints: List<String>.from(json['bulletPoints'] ?? []),
      codeSnippet: json['codeSnippet'] as String?,
      diagramType: json['diagramType'] as String?,
      notes: json['notes'] as String?,
    );
  }
}

class PptDeck {
  final String id;
  final String courseId;
  final String courseTitle;
  final String title;
  final String topic;
  final String description;
  final String instructorName;
  final DateTime sharedAt;
  final List<PptSlide> slides;
  final String? downloadUrl;
  final int viewsCount;

  const PptDeck({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.title,
    required this.topic,
    required this.description,
    required this.instructorName,
    required this.sharedAt,
    required this.slides,
    this.downloadUrl,
    this.viewsCount = 45,
  });

  int get totalSlides => slides.length;

  PptDeck copyWith({
    String? id,
    String? courseId,
    String? courseTitle,
    String? title,
    String? topic,
    String? description,
    String? instructorName,
    DateTime? sharedAt,
    List<PptSlide>? slides,
    String? downloadUrl,
    int? viewsCount,
  }) {
    return PptDeck(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      title: title ?? this.title,
      topic: topic ?? this.topic,
      description: description ?? this.description,
      instructorName: instructorName ?? this.instructorName,
      sharedAt: sharedAt ?? this.sharedAt,
      slides: slides ?? this.slides,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      viewsCount: viewsCount ?? this.viewsCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'title': title,
      'topic': topic,
      'description': description,
      'instructorName': instructorName,
      'sharedAt': sharedAt.toIso8601String(),
      'slides': slides.map((s) => s.toJson()).toList(),
      'downloadUrl': downloadUrl,
      'viewsCount': viewsCount,
    };
  }

  factory PptDeck.fromJson(Map<String, dynamic> json) {
    return PptDeck(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      courseTitle: json['courseTitle'] as String? ?? '',
      title: json['title'] as String,
      topic: json['topic'] as String? ?? '',
      description: json['description'] as String? ?? '',
      instructorName: json['instructorName'] as String? ?? 'Instructor',
      sharedAt: json['sharedAt'] != null 
          ? DateTime.parse(json['sharedAt']) 
          : DateTime.now(),
      slides: (json['slides'] as List<dynamic>? ?? [])
          .map((s) => PptSlide.fromJson(s as Map<String, dynamic>))
          .toList(),
      downloadUrl: json['downloadUrl'] as String?,
      viewsCount: json['viewsCount'] as int? ?? 0,
    );
  }
}
