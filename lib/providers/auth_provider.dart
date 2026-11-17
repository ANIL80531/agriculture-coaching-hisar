import 'package:flutter/material.dart';
import '../config/app_constants.dart';
import '../models/user_model.dart';
import '../services/google_auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final GoogleAuthService _authService = GoogleAuthService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  UserRole get currentRole => _currentUser?.role ?? UserRole.student;
  bool get isEducator => _currentUser?.isEducator ?? false;
  bool get isStudent => _currentUser?.isStudent ?? true;

  AuthProvider() {
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await StorageService.getUser();
      if (user != null) {
        _currentUser = user;
      }
    } catch (_) {}

    _isLoading = false;
    notifyListeners();
  }

  /// Sign In with Google
  Future<bool> signInWithGoogle({
    UserRole selectedRole = UserRole.student,
    String? customEmail,
    String? customName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.signInWithGoogle(
      selectedRole: selectedRole,
      customEmail: customEmail,
      customName: customName,
    );

    if (result.isSuccess && result.user != null) {
      // Merge any previously saved purchased courses
      final savedPurchases = await StorageService.getPurchasedCourses();
      final mergedCourses = {...result.user!.enrolledCourseIds, ...savedPurchases}.toList();
      
      _currentUser = result.user!.copyWith(enrolledCourseIds: mergedCourses);
      await StorageService.saveUser(_currentUser!);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _errorMessage = result.errorMessage ?? 'Google Sign-in failed';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Switch role between Student and Educator for seamless preview/testing
  Future<void> switchRole(UserRole newRole) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(role: newRole);
    await StorageService.saveUser(_currentUser!);
    notifyListeners();
  }

  /// Unlock a course after successful UPI payment
  Future<void> enrollInCourse(String courseId) async {
    if (_currentUser == null) return;
    
    if (!_currentUser!.enrolledCourseIds.contains(courseId)) {
      final updatedList = [..._currentUser!.enrolledCourseIds, courseId];
      _currentUser = _currentUser!.copyWith(enrolledCourseIds: updatedList);
      await StorageService.saveUser(_currentUser!);
      await StorageService.savePurchasedCourses(updatedList);
      notifyListeners();
    }
  }

  /// Check if user has access to a course
  bool hasPurchasedCourse(String courseId) {
    if (_currentUser == null) return false;
    return _currentUser!.isEnrolled(courseId);
  }

  /// Sign Out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authService.signOut();
    await StorageService.clearUser();
    _currentUser = null;

    _isLoading = false;
    notifyListeners();
  }
}
