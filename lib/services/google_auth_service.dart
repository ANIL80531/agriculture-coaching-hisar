import '../config/app_constants.dart';
import '../models/user_model.dart';

class GoogleAuthResult {
  final bool isSuccess;
  final UserModel? user;
  final String? errorMessage;

  GoogleAuthResult.success(this.user)
      : isSuccess = true,
        errorMessage = null;

  GoogleAuthResult.failure(this.errorMessage)
      : isSuccess = false,
        user = null;
}

class GoogleAuthService {
  /// Sign in with Google
  /// In a production environment with google_sign_in package & Firebase,
  /// this connects via GoogleSignIn().signIn().
  /// Here we implement a robust handler with fallback test profiles for seamless
  /// one-click testing of both Student and Educator experiences.
  Future<GoogleAuthResult> signInWithGoogle({
    UserRole selectedRole = UserRole.student,
    String? customEmail,
    String? customName,
  }) async {
    try {
      // Simulate OAuth network handshake
      await Future.delayed(const Duration(milliseconds: 600));

      final email = customEmail ?? 
          (selectedRole == UserRole.student 
              ? 'student.rohit@gmail.com' 
              : 'dr.vikramaditya@gmail.com');
              
      final name = customName ?? 
          (selectedRole == UserRole.student 
              ? 'Rohit Sharma' 
              : 'Dr. Vikramaditya Verma');
              
      final photoUrl = selectedRole == UserRole.student
          ? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80'
          : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80';

      final user = UserModel(
        id: 'user_google_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        photoUrl: photoUrl,
        role: selectedRole,
        enrolledCourseIds: selectedRole == UserRole.educator ? ['course_1', 'course_2', 'course_3'] : [],
        phone: '+91 98765 43210',
        joinedAt: DateTime.now(),
      );

      return GoogleAuthResult.success(user);
    } catch (e) {
      return GoogleAuthResult.failure('Google Sign-In failed: $e');
    }
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
