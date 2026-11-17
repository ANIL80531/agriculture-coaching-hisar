import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/course_model.dart';
import '../../models/lesson_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/live_lecture_provider.dart';
import '../../providers/mcq_provider.dart';
import '../../providers/ppt_provider.dart';
import '../live/live_lecture_room_screen.dart';
import '../mcq/mcq_quiz_screen.dart';
import '../ppt/ppt_viewer_screen.dart';
import '../payment/upi_payment_screen.dart';

class CourseContentViewerScreen extends StatefulWidget {
  final CourseModel course;

  const CourseContentViewerScreen({super.key, required this.course});

  @override
  State<CourseContentViewerScreen> createState() => _CourseContentViewerScreenState();
}

class _CourseContentViewerScreenState extends State<CourseContentViewerScreen> {
  Lesson? _currentLesson;
  bool _isPlaying = false;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    if (widget.course.modules.isNotEmpty && widget.course.modules.first.lessons.isNotEmpty) {
      _currentLesson = widget.course.modules.first.lessons.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);
    final liveProvider = Provider.of<LiveLectureProvider>(context);
    final pptProvider = Provider.of<PptProvider>(context);
    final mcqProvider = Provider.of<McqProvider>(context);

    final hasPurchased = authProvider.hasPurchasedCourse(widget.course.id);
    final coursePpts = pptProvider.getDecksForCourse(widget.course.id);
    final courseQuizzes = mcqProvider.getQuizzesForCourse(widget.course.id);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(widget.course.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Video Player / Content Viewer Stage
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Video simulation canvas
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade900, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _currentLesson?.type == LessonType.quiz
                                ? Icons.assignment
                                : Icons.play_circle_outline,
                            size: 56,
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              _currentLesson?.title ?? 'Select a Lesson',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Video Play / Pause Overlay Button
                  IconButton(
                    iconSize: 56,
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    onPressed: () {
                      if (!hasPurchased && !(_currentLesson?.isFreePreview ?? false)) {
                        _showPurchaseRequiredSheet(context);
                      } else {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                      }
                    },
                  ),

                  // Bottom Controls Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      color: Colors.black54,
                      child: Row(
                        children: [
                          Text(
                            _isPlaying ? '04:15' : '00:00',
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 3,
                                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              ),
                              child: Slider(
                                value: _isPlaying ? 0.3 : 0.0,
                                onChanged: (val) {},
                                activeColor: AppTheme.primary,
                                inactiveColor: Colors.white30,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_currentLesson?.durationMinutes ?? 15}:00',
                            style: const TextStyle(color: Colors.white, fontSize: 11),
                          ),
                          const SizedBox(width: 8),
                          // Speed Selector
                          PopupMenuButton<double>(
                            initialValue: _playbackSpeed,
                            onSelected: (speed) {
                              setState(() {
                                _playbackSpeed = speed;
                              });
                            },
                            child: Text(
                              '${_playbackSpeed}x',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 0.75, child: Text('0.75x')),
                              const PopupMenuItem(value: 1.0, child: Text('1.0x Normal')),
                              const PopupMenuItem(value: 1.25, child: Text('1.25x')),
                              const PopupMenuItem(value: 1.5, child: Text('1.5x')),
                              const PopupMenuItem(value: 2.0, child: Text('2.0x')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Course Action Pills: Live Lecture, PPT Slides, MCQ Quiz
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                // Live Lecture Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final live = liveProvider.lectures.firstWhere(
                        (l) => l.courseId == widget.course.id,
                        orElse: () => liveProvider.lectures.first,
                      );

                      if (hasPurchased) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LiveLectureRoomScreen(lecture: live),
                          ),
                        );
                      } else {
                        _showPurchaseRequiredSheet(context);
                      }
                    },
                    icon: const Icon(Icons.live_tv, size: 16, color: AppTheme.liveRed),
                    label: const Text('Live Class', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // PPT Slides Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final deck = coursePpts.isNotEmpty ? coursePpts.first : pptProvider.decks.first;
                      if (hasPurchased) {
                        pptProvider.openDeck(deck);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PptViewerScreen(deck: deck),
                          ),
                        );
                      } else {
                        _showPurchaseRequiredSheet(context);
                      }
                    },
                    icon: const Icon(Icons.slideshow, size: 16, color: Colors.purple),
                    label: const Text('PPT Slides', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // MCQ Quiz Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final quiz = courseQuizzes.isNotEmpty ? courseQuizzes.first : mcqProvider.quizzes.first;
                      if (hasPurchased) {
                        mcqProvider.startQuiz(quiz);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => McqQuizScreen(quiz: quiz),
                          ),
                        );
                      } else {
                        _showPurchaseRequiredSheet(context);
                      }
                    },
                    icon: const Icon(Icons.quiz, size: 16, color: AppTheme.primary),
                    label: const Text('MCQ Test', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppTheme.border),

          // Locked Content Warning Banner (if student has not paid)
          if (!hasPurchased)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFFEF3C7),
              child: Row(
                children: [
                  const Icon(Icons.lock, color: Color(0xFFD97706), size: 20),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Preview Mode. Buy course via UPI to unlock all videos, live lectures & PPTs.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF92400E), fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpiPaymentScreen(course: widget.course),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Unlock', style: TextStyle(fontSize: 11)),
                  ),
                ],
              ),
            ),

          // Curriculum Lessons List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.course.modules.length,
              itemBuilder: (context, mIdx) {
                final module = widget.course.modules[mIdx];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...module.lessons.map((lesson) {
                      final isSelected = _currentLesson?.id == lesson.id;
                      final isUnlocked = hasPurchased || lesson.isFreePreview;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryLight : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppTheme.primary : AppTheme.border,
                          ),
                        ),
                        child: ListTile(
                          dense: true,
                          leading: Icon(
                            isUnlocked
                                ? (lesson.isCompleted ? Icons.check_circle : Icons.play_circle_fill)
                                : Icons.lock,
                            color: isUnlocked
                                ? (lesson.isCompleted ? AppTheme.success : AppTheme.primary)
                                : AppTheme.textSecondary,
                          ),
                          title: Text(
                            lesson.title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isUnlocked ? AppTheme.textPrimary : AppTheme.textSecondary,
                            ),
                          ),
                          subtitle: Text(
                            '${lesson.durationMinutes} mins • ${lesson.type.name.toUpperCase()}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                          ),
                          trailing: isUnlocked
                              ? Checkbox(
                                  value: lesson.isCompleted,
                                  onChanged: (_) {
                                    courseProvider.toggleLessonCompletion(
                                      widget.course.id,
                                      module.id,
                                      lesson.id,
                                    );
                                  },
                                )
                              : const Text('LOCKED', style: TextStyle(fontSize: 10, color: AppTheme.error, fontWeight: FontWeight.bold)),
                          onTap: () {
                            if (isUnlocked) {
                              setState(() {
                                _currentLesson = lesson;
                                _isPlaying = true;
                              });
                            } else {
                              _showPurchaseRequiredSheet(context);
                            }
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPurchaseRequiredSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock, size: 48, color: AppTheme.accent),
            const SizedBox(height: 12),
            const Text(
              'Unlock Full Course Access',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Purchase "${widget.course.title}" to get unlimited access to all video lessons, live lectures, MCQ tests, and PPT notes.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpiPaymentScreen(course: widget.course),
                    ),
                  );
                },
                icon: const Icon(Icons.flash_on),
                label: Text('Pay ₹${widget.course.price.toStringAsFixed(0)} via Any UPI App'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
