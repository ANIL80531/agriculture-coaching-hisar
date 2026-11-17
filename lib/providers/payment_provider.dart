import 'package:flutter/material.dart';
import '../config/upi_constants.dart';
import '../models/course_model.dart';
import '../models/payment_model.dart';
import '../services/upi_payment_service.dart';
import 'auth_provider.dart';

class PaymentProvider extends ChangeNotifier {
  final UpiPaymentService _upiService = UpiPaymentService();

  UpiAppInfo _selectedUpiApp = UpiConstants.popularUpiApps[0]; // Default: Google Pay
  bool _isProcessing = false;
  PaymentTransaction? _latestTransaction;
  String? _errorMessage;

  UpiAppInfo get selectedUpiApp => _selectedUpiApp;
  bool get isProcessing => _isProcessing;
  PaymentTransaction? get latestTransaction => _latestTransaction;
  String? get errorMessage => _errorMessage;

  void selectUpiApp(UpiAppInfo app) {
    _selectedUpiApp = app;
    notifyListeners();
  }

  /// Execute UPI payment for a course
  Future<bool> processCoursePayment({
    required CourseModel course,
    required AuthProvider authProvider,
    String? customUpiId,
  }) async {
    if (authProvider.currentUser == null) {
      _errorMessage = 'Please sign in to proceed with payment.';
      notifyListeners();
      return false;
    }

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _upiService.initiateUpiPayment(
        courseId: course.id,
        courseTitle: course.title,
        userId: authProvider.currentUser!.id,
        amount: course.price,
        upiAppName: customUpiId != null && customUpiId.isNotEmpty 
            ? 'Custom UPI ($customUpiId)' 
            : _selectedUpiApp.name,
        upiPackageName: customUpiId != null && customUpiId.isNotEmpty 
            ? null 
            : _selectedUpiApp.packageName,
      );

      _latestTransaction = result.transaction;

      if (result.isSuccess) {
        // Unlock course access for this student immediately
        await authProvider.enrollInCourse(course.id);
        _isProcessing = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.message ?? 'UPI Payment failed';
        _isProcessing = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred during payment: $e';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  void clearTransaction() {
    _latestTransaction = null;
    _errorMessage = null;
    notifyListeners();
  }
}
