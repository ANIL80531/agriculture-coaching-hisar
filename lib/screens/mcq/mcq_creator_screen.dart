import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../config/app_theme.dart';
import '../../models/mcq_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/mcq_provider.dart';

class McqCreatorScreen extends StatefulWidget {
  const McqCreatorScreen({super.key});

  @override
  State<McqCreatorScreen> createState() => _McqCreatorScreenState();
}

class QuestionDraft {
  final TextEditingController questionText = TextEditingController();
  final List<TextEditingController> options = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int correctOptionIndex = 0;
  final TextEditingController explanation = TextEditingController();
  int marks = 2;

  void dispose() {
    questionText.dispose();
    for (final opt in options) {
      opt.dispose();
    }
    explanation.dispose();
  }
}

class _McqCreatorScreenState extends State<McqCreatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController(text: '15');
  
  String? _selectedCourseId;
  final List<QuestionDraft> _questions = [];

  @override
  void initState() {
    super.initState();
    // Start with 1 question draft
    _addQuestionDraft();
  }

  void _addQuestionDraft() {
    setState(() {
      _questions.add(QuestionDraft());
    });
  }

  void _removeQuestionDraft(int index) {
    if (_questions.length > 1) {
      setState(() {
        _questions[index].dispose();
        _questions.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('At least one question is required.')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    for (final q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  Future<void> _saveAndPublishQuiz() async {
    if (!_formKey.currentState!.validate()) return;

    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final mcqProvider = Provider.of<McqProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final selectedCourse = courseProvider.courses.firstWhere(
      (c) => c.id == _selectedCourseId,
      orElse: () => courseProvider.courses.first,
    );

    final List<McqQuestion> parsedQuestions = [];

    for (int i = 0; i < _questions.length; i++) {
      final draft = _questions[i];
      if (draft.questionText.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter text for Question ${i + 1}')),
        );
        return;
      }

      parsedQuestions.add(
        McqQuestion(
          id: 'q_${const Uuid().v4().substring(0, 8)}',
          questionText: draft.questionText.text.trim(),
          options: draft.options.map((opt) => opt.text.trim()).toList(),
          correctOptionIndex: draft.correctOptionIndex,
          explanation: draft.explanation.text.trim(),
          marks: draft.marks,
        ),
      );
    }

    final newQuiz = McqQuiz(
      id: 'quiz_${DateTime.now().millisecondsSinceEpoch}',
      courseId: selectedCourse.id,
      courseTitle: selectedCourse.title,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      durationMinutes: int.tryParse(_durationController.text.trim()) ?? 15,
      passingPercentage: 60.0,
      questions: parsedQuestions,
      createdBy: authProvider.currentUser?.name ?? 'Dr. Vikramaditya',
      createdAt: DateTime.now(),
    );

    await mcqProvider.createAndPublishQuiz(newQuiz);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('MCQ Quiz published successfully for students!'),
        backgroundColor: AppTheme.success,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    if (_selectedCourseId == null && courseProvider.courses.isNotEmpty) {
      _selectedCourseId = courseProvider.courses.first.id;
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Make MCQ Questions'),
        actions: [
          ElevatedButton(
            onPressed: _saveAndPublishQuiz,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
            ),
            child: const Text('Publish', style: TextStyle(fontSize: 13)),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Quiz Meta Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quiz Details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  
                  // Course Selector
                  DropdownButtonFormField<String>(
                    value: _selectedCourseId,
                    decoration: const InputDecoration(labelText: 'Associate with Course'),
                    items: courseProvider.courses.map((c) {
                      return DropdownMenuItem(
                        value: c.id,
                        child: Text(c.title, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _selectedCourseId = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Quiz Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Quiz Title',
                      hintText: 'e.g. Flutter Widget Lifecycle & State Assessment',
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Please enter a quiz title' : null,
                  ),
                  const SizedBox(height: 12),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Quiz Description',
                      hintText: 'Brief instructions for students...',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Duration
                  TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Duration (Minutes)',
                      suffixText: 'mins',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Questions Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Questions (${_questions.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: _addQuestionDraft,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Question'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // List of Question Drafts
            ..._questions.asMap().entries.map((entry) {
              final index = entry.key;
              final draft = entry.value;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Question ${index + 1}',
                            style: const TextStyle(
                              color: AppTheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (_questions.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppTheme.error, size: 20),
                            onPressed: () => _removeQuestionDraft(index),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Question Text Field
                    TextFormField(
                      controller: draft.questionText,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Question Text',
                        hintText: 'e.g. Which hook is invoked first in a StatefulWidget?',
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Options (Select the radio of correct option):',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 8),

                    // 4 Options with Radio Button to choose correct answer
                    ...List.generate(4, (optIdx) {
                      final optionLabel = String.fromCharCode(65 + optIdx); // 'A', 'B', 'C', 'D'
                      final isCorrect = draft.correctOptionIndex == optIdx;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Radio<int>(
                              value: optIdx,
                              groupValue: draft.correctOptionIndex,
                              activeColor: AppTheme.success,
                              onChanged: (val) {
                                setState(() {
                                  draft.correctOptionIndex = val!;
                                });
                              },
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: draft.options[optIdx],
                                decoration: InputDecoration(
                                  labelText: 'Option $optionLabel ${isCorrect ? '(Correct Answer)' : ''}',
                                  isDense: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: isCorrect ? AppTheme.success : AppTheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),

                    // Explanation field
                    TextFormField(
                      controller: draft.explanation,
                      decoration: const InputDecoration(
                        labelText: 'Explanation / Solution',
                        hintText: 'Explain why the marked answer is correct...',
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Add Another Question CTA
            OutlinedButton.icon(
              onPressed: _addQuestionDraft,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Another Question'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
