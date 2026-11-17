import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../models/lesson_model.dart';
import '../services/mock_database.dart';

class CourseProvider extends ChangeNotifier {
  List<CourseModel> _courses = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  List<CourseModel> get courses => _courses;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  List<String> get categories {
    final cats = {'All'};
    for (final c in _courses) {
      cats.add(c.category);
    }
    return cats.toList();
  }

  List<CourseModel> get filteredCourses {
    return _courses.where((course) {
      final matchesCategory = _selectedCategory == 'All' || course.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.subtitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.instructorName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  CourseProvider() {
    _loadCourses();
  }

  void _loadCourses() {
    _isLoading = true;
    notifyListeners();

    _courses = MockDatabase.getInitialCourses();

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  CourseModel? getCourseById(String id) {
    try {
      return _courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Mark a lesson as completed
  void toggleLessonCompletion(String courseId, String moduleId, String lessonId) {
    final courseIndex = _courses.indexWhere((c) => c.id == courseId);
    if (courseIndex == -1) return;

    final course = _courses[courseIndex];
    final updatedModules = course.modules.map((module) {
      if (module.id == moduleId) {
        final updatedLessons = module.lessons.map((lesson) {
          if (lesson.id == lessonId) {
            return lesson.copyWith(isCompleted: !lesson.isCompleted);
          }
          return lesson;
        }).toList();
        return CourseModule(
          id: module.id,
          title: module.title,
          description: module.description,
          order: module.order,
          lessons: updatedLessons,
        );
      }
      return module;
    }).toList();

    _courses[courseIndex] = course.copyWith(modules: updatedModules);
    notifyListeners();
  }

  /// Add a newly created course by educator
  void addCourse(CourseModel newCourse) {
    _courses.insert(0, newCourse);
    notifyListeners();
  }
}
