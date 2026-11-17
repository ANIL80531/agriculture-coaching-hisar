import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../config/app_theme.dart';
import '../../models/ppt_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/ppt_provider.dart';

class PptUploadScreen extends StatefulWidget {
  const PptUploadScreen({super.key});

  @override
  State<PptUploadScreen> createState() => _PptUploadScreenState();
}

class _PptUploadScreenState extends State<PptUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String? _selectedCourseId;
  String? _selectedFileName;
  final int _slideCount = 5;

  @override
  void dispose() {
    _titleController.dispose();
    _topicController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _simulateFilePick() {
    setState(() {
      _selectedFileName = 'Lecture_${DateTime.now().millisecondsSinceEpoch % 1000}_Slides.pptx';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected presentation: $_selectedFileName'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  Future<void> _sharePresentation() async {
    if (!_formKey.currentState!.validate()) return;

    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final pptProvider = Provider.of<PptProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final selectedCourse = courseProvider.courses.firstWhere(
      (c) => c.id == _selectedCourseId,
      orElse: () => courseProvider.courses.first,
    );

    // Generate structured slides from educator's topic and notes
    final List<PptSlide> generatedSlides = [
      PptSlide(
        slideNumber: 1,
        title: _titleController.text.trim(),
        subtitle: _topicController.text.trim(),
        bulletPoints: [
          'Overview of ${_topicController.text.trim()}',
          'Key concepts and architectural best practices',
          'Live interactive implementation walkthrough',
          'Summary and hands-on assignment',
        ],
        notes: 'Introductory slide introducing the lecture agenda to students.',
      ),
      PptSlide(
        slideNumber: 2,
        title: 'Core Concepts & Principles',
        subtitle: 'Theoretical Foundations',
        bulletPoints: [
          'Understanding underlying protocol flow and data integrity',
          'Component lifecycle and event sequencing',
          'Handling edge cases, error states, and network timeouts',
        ],
        codeSnippet: '// Production sample snippet\nvoid executeStep() {\n  print("Executing ${_topicController.text.trim()}");\n}',
        notes: 'Highlight to students how asynchronous execution avoids blocking the main UI thread.',
      ),
      PptSlide(
        slideNumber: 3,
        title: 'Implementation & Case Studies',
        subtitle: 'Real-world Mobile Applications',
        bulletPoints: [
          'Integrating with backend REST / GraphQL endpoints',
          'Persisting state across app sessions and hot restarts',
          'Testing with unit and widget test suites',
        ],
        notes: 'Walk students through the live code example on GitHub.',
      ),
    ];

    final newDeck = PptDeck(
      id: 'ppt_${const Uuid().v4().substring(0, 8)}',
      courseId: selectedCourse.id,
      courseTitle: selectedCourse.title,
      title: _titleController.text.trim(),
      topic: _topicController.text.trim(),
      description: _descriptionController.text.trim(),
      instructorName: authProvider.currentUser?.name ?? 'Dr. Vikramaditya',
      sharedAt: DateTime.now(),
      slides: generatedSlides,
      viewsCount: 1,
    );

    await pptProvider.sharePptDeck(newDeck);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PPT Presentation shared successfully with enrolled students!'),
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
        title: const Text('Share PPT Presentation'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Upload Box
            InkWell(
              onTap: _simulateFilePick,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedFileName != null ? AppTheme.primary : AppTheme.border,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFDF2F8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.cloud_upload_outlined, size: 32, color: Color(0xFFDB2777)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _selectedFileName ?? 'Tap to select .PPTX / .PDF Presentation',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _selectedFileName != null ? AppTheme.primary : AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Supports PowerPoint (.pptx), Keynote (.key), and Adobe PDF (.pdf)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Deck Metadata Card
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
                  const Text('Presentation Details', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // Target Course
                  DropdownButtonFormField<String>(
                    value: _selectedCourseId,
                    decoration: const InputDecoration(labelText: 'Target Course for Enrolled Students'),
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

                  // Presentation Title
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Presentation Title',
                      hintText: 'e.g. Flutter Architecture & UPI Payments Masterdeck',
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Please enter a title' : null,
                  ),
                  const SizedBox(height: 12),

                  // Topic
                  TextFormField(
                    controller: _topicController,
                    decoration: const InputDecoration(
                      labelText: 'Topic / Chapter',
                      hintText: 'e.g. Clean Architecture & State Flow',
                    ),
                    validator: (val) => val == null || val.isEmpty ? 'Please enter a topic' : null,
                  ),
                  const SizedBox(height: 12),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description / Notes for Students',
                      hintText: 'Key highlights covered in this slide deck...',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Share CTA Button
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _sharePresentation,
                icon: const Icon(Icons.share),
                label: const Text('Share PPT with Students Now', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
