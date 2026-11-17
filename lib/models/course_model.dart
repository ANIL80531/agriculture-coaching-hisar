import 'lesson_model.dart';

class CourseModel {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String instructorId;
  final String instructorName;
  final String instructorTitle;
  final String instructorAvatar;
  final double price;
  final double originalPrice;
  final String thumbnailUrl;
  final String category;
  final double rating;
  final int reviewsCount;
  final bool isLiveNow;
  final String? activeLiveLectureId;
  final List<CourseModule> modules;
  final List<String> features;
  final bool hasCertificate;
  final DateTime createdAt;

  const CourseModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.instructorId,
    required this.instructorName,
    required this.instructorTitle,
    required this.instructorAvatar,
    required this.price,
    required this.originalPrice,
    required this.thumbnailUrl,
    required this.category,
    this.rating = 4.8,
    this.reviewsCount = 120,
    this.isLiveNow = false,
    this.activeLiveLectureId,
    this.modules = const [],
    this.features = const [],
    this.hasCertificate = true,
    required this.createdAt,
  });

  int get totalLessons => modules.fold(0, (sum, m) => sum + m.lessons.length);
  
  double get totalDurationHours {
    final totalMinutes = modules.fold(0, (sum, m) => sum + m.totalMinutes);
    return double.parse((totalMinutes / 60).toStringAsFixed(1));
  }

  int get discountPercentage {
    if (originalPrice <= price || originalPrice <= 0) return 0;
    return (((originalPrice - price) / originalPrice) * 100).round();
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    String? instructorId,
    String? instructorName,
    String? instructorTitle,
    String? instructorAvatar,
    double? price,
    double? originalPrice,
    String? thumbnailUrl,
    String? category,
    double? rating,
    int? reviewsCount,
    bool? isLiveNow,
    String? activeLiveLectureId,
    List<CourseModule>? modules,
    List<String>? features,
    bool? hasCertificate,
    DateTime? createdAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      instructorId: instructorId ?? this.instructorId,
      instructorName: instructorName ?? this.instructorName,
      instructorTitle: instructorTitle ?? this.instructorTitle,
      instructorAvatar: instructorAvatar ?? this.instructorAvatar,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      isLiveNow: isLiveNow ?? this.isLiveNow,
      activeLiveLectureId: activeLiveLectureId ?? this.activeLiveLectureId,
      modules: modules ?? this.modules,
      features: features ?? this.features,
      hasCertificate: hasCertificate ?? this.hasCertificate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'instructorId': instructorId,
      'instructorName': instructorName,
      'instructorTitle': instructorTitle,
      'instructorAvatar': instructorAvatar,
      'price': price,
      'originalPrice': originalPrice,
      'thumbnailUrl': thumbnailUrl,
      'category': category,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'isLiveNow': isLiveNow,
      'activeLiveLectureId': activeLiveLectureId,
      'modules': modules.map((m) => m.toJson()).toList(),
      'features': features,
      'hasCertificate': hasCertificate,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      instructorId: json['instructorId'] as String? ?? 'educator_1',
      instructorName: json['instructorName'] as String? ?? 'Dr. Vikramaditya',
      instructorTitle: json['instructorTitle'] as String? ?? 'Senior Tech Educator',
      instructorAvatar: json['instructorAvatar'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      category: json['category'] as String? ?? 'Computer Science',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewsCount: json['reviewsCount'] as int? ?? 100,
      isLiveNow: json['isLiveNow'] as bool? ?? false,
      activeLiveLectureId: json['activeLiveLectureId'] as String?,
      modules: (json['modules'] as List<dynamic>? ?? [])
          .map((m) => CourseModule.fromJson(m as Map<String, dynamic>))
          .toList(),
      features: List<String>.from(json['features'] ?? []),
      hasCertificate: json['hasCertificate'] as bool? ?? true,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }
}
