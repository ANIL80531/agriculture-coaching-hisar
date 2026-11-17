import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Agriculture Coaching Hisar';
  static const String appTagline = 'Premier Institute for ICAR, IBPS AFO & Agri Competitive Exams';
  
  // Default educator UPI details for receiving student payments
  static const String merchantUpiId = '8053127034@sbi';
  static const String merchantName = 'Agriculture Coaching Hisar';
  static const String currency = 'INR';
  static const String currencySymbol = '₹';
  
  // Deep link callback scheme
  static const String upiCallbackScheme = 'agricoaching://payment-callback';
  
  // Storage keys
  static const String keyUser = 'user_session';
  static const String keyPurchasedCourses = 'purchased_courses';
  static const String keyCreatedQuizzes = 'created_quizzes';
  static const String keySharedPpts = 'shared_ppts';
}

enum UserRole {
  student,
  educator,
}

enum PaymentStatus {
  pending,
  initiated,
  success,
  failed,
}
