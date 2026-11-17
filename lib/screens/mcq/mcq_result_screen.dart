import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/mcq_model.dart';

class McqResultScreen extends StatelessWidget {
  final McqQuizAttempt attempt;
  final McqQuiz quiz;

  const McqResultScreen({
    super.key,
    required this.attempt,
    required this.quiz,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Quiz Assessment Report'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Performance Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: attempt.isPassed
                          ? AppTheme.success.withOpacity(0.12)
                          : AppTheme.error.withOpacity(0.12),
                    ),
                    child: Center(
                      child: Text(
                        '${attempt.percentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: attempt.isPassed ? AppTheme.success : AppTheme.error,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    attempt.isPassed ? 'Congratulations! Passed 🎉' : 'Needs Practice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: attempt.isPassed ? AppTheme.success : AppTheme.error,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    quiz.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 18),
                  const Divider(color: AppTheme.border, height: 1),
                  const SizedBox(height: 14),

                  // Metrics Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryStat(
                        'Score',
                        '${attempt.totalScore}/${attempt.maxScore}',
                        AppTheme.primary,
                      ),
                      _buildSummaryStat(
                        'Correct',
                        '${attempt.correctCount}/${attempt.totalQuestions}',
                        AppTheme.success,
                      ),
                      _buildSummaryStat(
                        'Time',
                        '${(attempt.timeSpentSeconds / 60).toStringAsFixed(1)}m',
                        AppTheme.textPrimary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Detailed Solutions & Review Header
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Question by Question Solutions & Review',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),

            // Review Items List
            ...List.generate(quiz.questions.length, (idx) {
              final question = quiz.questions[idx];
              final studentChoice = attempt.userAnswers[idx];
              final isCorrect = studentChoice != null && studentChoice == question.correctOptionIndex;
              final isAnswered = studentChoice != null;

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCorrect
                        ? AppTheme.success.withOpacity(0.5)
                        : (isAnswered ? AppTheme.error.withOpacity(0.5) : AppTheme.border),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Question ${idx + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? AppTheme.success.withOpacity(0.12)
                                : AppTheme.error.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isCorrect ? 'Correct (+${question.marks})' : (isAnswered ? 'Incorrect' : 'Skipped'),
                            style: TextStyle(
                              color: isCorrect ? AppTheme.success : AppTheme.error,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.questionText,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 12),

                    // Options breakdown
                    ...List.generate(question.options.length, (optIdx) {
                      final isChosenByStudent = studentChoice == optIdx;
                      final isTheCorrectOption = question.correctOptionIndex == optIdx;

                      Color? optBg;
                      Color optTextColor = AppTheme.textPrimary;
                      IconData? statusIcon;

                      if (isTheCorrectOption) {
                        optBg = AppTheme.success.withOpacity(0.12);
                        optTextColor = AppTheme.success;
                        statusIcon = Icons.check_circle;
                      } else if (isChosenByStudent) {
                        optBg = AppTheme.error.withOpacity(0.12);
                        optTextColor = AppTheme.error;
                        statusIcon = Icons.cancel;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: optBg ?? AppTheme.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${String.fromCharCode(65 + optIdx)}. ',
                              style: TextStyle(fontWeight: FontWeight.bold, color: optTextColor),
                            ),
                            Expanded(
                              child: Text(
                                question.options[optIdx],
                                style: TextStyle(fontSize: 13, color: optTextColor),
                              ),
                            ),
                            if (statusIcon != null)
                              Icon(statusIcon, size: 16, color: optTextColor),
                          ],
                        ),
                      );
                    }),

                    // Educator Explanation Box
                    if (question.explanation.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb_outline, size: 16, color: AppTheme.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Explanation: ${question.explanation}',
                                style: const TextStyle(fontSize: 12, color: AppTheme.primaryDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Course Content'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
