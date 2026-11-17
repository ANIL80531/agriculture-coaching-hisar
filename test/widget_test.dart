import 'package:flutter_test/flutter_test.dart';
import '../lib/config/app_constants.dart';
import '../lib/config/upi_constants.dart';
import '../lib/models/user_model.dart';
import '../lib/models/course_model.dart';
import '../lib/models/mcq_model.dart';

void main() {
  group('UPI Deep Link URI Generation Tests', () {
    test('Constructs standard NPCI compliant UPI URI with correct query parameters', () {
      final uri = UpiConstants.buildUpiUri(
        payeeVpa: '8053127034@sbi',
        payeeName: 'Agriculture Coaching Hisar',
        transactionId: 'TXN1234567890',
        transactionRefId: 'ORD_999888',
        transactionNote: 'Course: IBPS AFO Target Batch',
        amount: 2499.00,
      );

      expect(uri.scheme, 'upi');
      expect(uri.host, 'pay');
      expect(uri.queryParameters['pa'], '8053127034@sbi');
      expect(uri.queryParameters['pn'], 'Agriculture Coaching Hisar');
      expect(uri.queryParameters['am'], '2499.00');
      expect(uri.queryParameters['cu'], 'INR');
      expect(uri.queryParameters['tr'], 'ORD_999888');
      expect(uri.queryParameters['tid'], 'TXN1234567890');
    });
  });

  group('Course Access Control Tests', () {
    test('Student only has access to courses they have purchased', () {
      final student = UserModel(
        id: 'std_1',
        name: 'Rohit',
        email: 'rohit@example.com',
        role: UserRole.student,
        enrolledCourseIds: ['course_flutter'],
        joinedAt: DateTime.now(),
      );

      expect(student.isEnrolled('course_flutter'), isTrue);
      expect(student.isEnrolled('course_dsa'), isFalse);
    });

    test('Educator has global instructor access to manage their courses', () {
      final educator = UserModel(
        id: 'edu_1',
        name: 'Dr. Vikramaditya',
        email: 'dr.vikramaditya@example.com',
        role: UserRole.educator,
        enrolledCourseIds: [],
        joinedAt: DateTime.now(),
      );

      expect(educator.isEnrolled('any_course_id'), isTrue);
    });
  });

  group('MCQ Quiz Scoring & Assessment Tests', () {
    test('Calculates score and passing status correctly', () {
      const q1 = McqQuestion(
        id: '1',
        questionText: 'Test 1',
        options: ['A', 'B', 'C', 'D'],
        correctOptionIndex: 1, // 'B'
        explanation: 'Exp 1',
        marks: 5,
      );

      const q2 = McqQuestion(
        id: '2',
        questionText: 'Test 2',
        options: ['A', 'B', 'C', 'D'],
        correctOptionIndex: 2, // 'C'
        explanation: 'Exp 2',
        marks: 5,
      );

      final quiz = McqQuiz(
        id: 'quiz_test',
        courseId: 'c1',
        courseTitle: 'Course 1',
        title: 'Quiz 1',
        description: 'Test',
        passingPercentage: 60.0,
        questions: [q1, q2],
        createdBy: 'Instructor',
        createdAt: DateTime.now(),
      );

      // Student gets Q1 right (idx 1), Q2 wrong (idx 0)
      final userAnswers = {0: 1, 1: 0};
      int score = 0;
      int correctCount = 0;

      for (int i = 0; i < quiz.questions.length; i++) {
        if (userAnswers[i] == quiz.questions[i].correctOptionIndex) {
          correctCount++;
          score += quiz.questions[i].marks;
        }
      }

      final percentage = (score / quiz.totalMarks) * 100;
      final isPassed = percentage >= quiz.passingPercentage;

      expect(correctCount, 1);
      expect(score, 5);
      expect(percentage, 50.0);
      expect(isPassed, isFalse); // 50% < 60%
    });
  });
}
