import '../config/app_constants.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final UserRole role;
  final List<String> enrolledCourseIds;
  final String? phone;
  final DateTime joinedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.role,
    this.enrolledCourseIds = const [],
    this.phone,
    required this.joinedAt,
  });

  bool get isEducator => role == UserRole.educator;
  bool get isStudent => role == UserRole.student;

  bool isEnrolled(String courseId) {
    if (isEducator) return true; // Educators have access to all courses they teach
    return enrolledCourseIds.contains(courseId);
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    UserRole? role,
    List<String>? enrolledCourseIds,
    String? phone,
    DateTime? joinedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      enrolledCourseIds: enrolledCourseIds ?? this.enrolledCourseIds,
      phone: phone ?? this.phone,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'role': role.name,
      'enrolledCourseIds': enrolledCourseIds,
      'phone': phone,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      role: json['role'] == 'educator' ? UserRole.educator : UserRole.student,
      enrolledCourseIds: List<String>.from(json['enrolledCourseIds'] ?? []),
      phone: json['phone'] as String?,
      joinedAt: json['joinedAt'] != null 
          ? DateTime.parse(json['joinedAt']) 
          : DateTime.now(),
    );
  }
}
