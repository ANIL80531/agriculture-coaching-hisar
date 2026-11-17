import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/mcq_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/mcq_provider.dart';
import 'mcq_result_screen.dart';

class McqQuizScreen extends StatelessWidget {
  final McqQuiz quiz;

  const McqQuizScreen({super.key, required this.quiz});

  void _showSubmitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Submit Quiz?'),
        content: const Text(
          'Are you sure you want to submit your answers? You will immediately receive your score and detailed explanations.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep Reviewing'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _finalizeSubmission(context);
            },
            child: const Text('Submit Now'),
          ),
        ],
      ),
    );
  }

  void _finalizeSubmission(BuildContext context) {
    final mcqProvider = Provider.of<McqProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    mcqProvider.submitQuiz(userId: authProvider.currentUser?.id ?? 'student_1');

    if (mcqProvider.latestAttempt != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => McqResultScreen(
            attempt: mcqProvider.latestAttempt!,
            quiz: quiz,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mcqProvider = Provider.of<McqProvider>(context);

    if (quiz.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(quiz.title)),
        body: const Center(child: Text('This quiz currently has no questions.')),
      );
    }

    final currentIndex = mcqProvider.currentQuestionIndex;
    final question = quiz.questions[currentIndex];
    final selectedOption = mcqProvider.selectedAnswers[currentIndex];
    final isLastQuestion = currentIndex == quiz.questions.length - 1;

    return WillPopScope(
      onWillPop: () async {
        final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Exit Quiz?'),
            content: const Text('Your current progress will be lost if you leave without submitting.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Continue Quiz')),
              ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Exit')),
            ],
          ),
        );
        return shouldLeave ?? false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: Text(
            quiz.title,
            style: const TextStyle(fontSize: 15),
          ),
          actions: [
            // Timer Badge
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: mcqProvider.remainingSeconds < 120
                    ? AppTheme.error.withOpacity(0.15)
                    : AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: mcqProvider.remainingSeconds < 120 ? AppTheme.error : AppTheme.primary,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 16,
                    color: mcqProvider.remainingSeconds < 120 ? AppTheme.error : AppTheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    mcqProvider.formattedRemainingTime,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: mcqProvider.remainingSeconds < 120 ? AppTheme.error : AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (currentIndex + 1) / quiz.questions.length,
                  minHeight: 6,
                  backgroundColor: AppTheme.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentIndex + 1} of ${quiz.questions.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    '${question.marks} Marks',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Question Statement Box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  question.questionText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Options List
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, optIdx) {
                    final isSelected = selectedOption == optIdx;
                    final optionLabel = String.fromCharCode(65 + optIdx); // 'A', 'B', 'C', 'D'

                    return InkWell(
                      onTap: () {
                        mcqProvider.selectAnswer(currentIndex, optIdx);
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryLight : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppTheme.primary : AppTheme.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primary : AppTheme.background,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppTheme.primary : AppTheme.border,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  optionLabel,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                question.options[optIdx],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  color: isSelected ? AppTheme.primaryDark : AppTheme.textPrimary,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: AppTheme.primary, size: 20),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Navigation Controls
              Row(
                children: [
                  if (currentIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => mcqProvider.previousQuestion(),
                        child: const Text('← Previous'),
                      ),
                    ),
                  if (currentIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isLastQuestion) {
                          _showSubmitConfirmation(context);
                        } else {
                          mcqProvider.nextQuestion();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLastQuestion ? AppTheme.success : AppTheme.primary,
                      ),
                      child: Text(isLastQuestion ? 'Submit Quiz ✓' : 'Next Question →'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
