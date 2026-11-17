import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_constants.dart';
import '../models/user_model.dart';
import '../models/mcq_model.dart';
import '../models/ppt_model.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // --- User Session ---
  static Future<void> saveUser(UserModel user) async {
    try {
      final p = await prefs;
      await p.setString(AppConstants.keyUser, jsonEncode(user.toJson()));
    } catch (_) {}
  }

  static Future<UserModel?> getUser() async {
    try {
      final p = await prefs;
      final raw = p.getString(AppConstants.keyUser);
      if (raw != null) {
        return UserModel.fromJson(jsonDecode(raw));
      }
    } catch (_) {}
    return null;
  }

  static Future<void> clearUser() async {
    try {
      final p = await prefs;
      await p.remove(AppConstants.keyUser);
    } catch (_) {}
  }

  // --- Purchased Courses ---
  static Future<void> savePurchasedCourses(List<String> courseIds) async {
    try {
      final p = await prefs;
      await p.setStringList(AppConstants.keyPurchasedCourses, courseIds);
    } catch (_) {}
  }

  static Future<List<String>> getPurchasedCourses() async {
    try {
      final p = await prefs;
      return p.getStringList(AppConstants.keyPurchasedCourses) ?? [];
    } catch (_) {
      return [];
    }
  }

  // --- Custom Created MCQs ---
  static Future<void> saveCustomQuizzes(List<McqQuiz> quizzes) async {
    try {
      final p = await prefs;
      final list = quizzes.map((q) => q.toJson()).toList();
      await p.setString(AppConstants.keyCreatedQuizzes, jsonEncode(list));
    } catch (_) {}
  }

  static Future<List<McqQuiz>> getCustomQuizzes() async {
    try {
      final p = await prefs;
      final raw = p.getString(AppConstants.keyCreatedQuizzes);
      if (raw != null) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return decoded.map((item) => McqQuiz.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return [];
  }

  // --- Shared PPTs ---
  static Future<void> saveSharedPpts(List<PptDeck> decks) async {
    try {
      final p = await prefs;
      final list = decks.map((d) => d.toJson()).toList();
      await p.setString(AppConstants.keySharedPpts, jsonEncode(list));
    } catch (_) {}
  }

  static Future<List<PptDeck>> getSharedPpts() async {
    try {
      final p = await prefs;
      final raw = p.getString(AppConstants.keySharedPpts);
      if (raw != null) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return decoded.map((item) => PptDeck.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return [];
  }
}
