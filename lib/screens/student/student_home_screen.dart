import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/course_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/live_lecture_provider.dart';
import '../../widgets/course_card.dart';
import '../../widgets/live_status_indicator.dart';
import '../course/course_detail_screen.dart';
import '../course/course_content_viewer_screen.dart';
import '../live/live_lecture_room_screen.dart';
import '../payment/upi_payment_screen.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);
    final liveProvider = Provider.of<LiveLectureProvider>(context);
    final user = authProvider.currentUser;

    final activeLive = liveProvider.activeLiveSessions.isNotEmpty
        ? liveProvider.activeLiveSessions.first
        : null;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: user?.photoUrl != null ? NetworkImage(user!.photoUrl!) : null,
              backgroundColor: AppTheme.primaryLight,
              child: user?.photoUrl == null
                  ? const Icon(Icons.person, color: AppTheme.primary)
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${user?.name.split(' ').first ?? 'Student'} 👋',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'What would you like to learn today?',
                  style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                onChanged: (val) => courseProvider.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: 'Search courses, topics, or instructors...',
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                  suffixIcon: courseProvider.searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => courseProvider.setSearchQuery(''),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Active Live Lecture Banner (if running)
              if (activeLive != null) ...[
                _buildLiveLectureBanner(context, activeLive, authProvider),
                const SizedBox(height: 24),
              ],

              // Categories Row
              const Text(
                'Explore Topics',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: courseProvider.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = courseProvider.categories[index];
                    final isSelected = courseProvider.selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) => courseProvider.setCategory(cat),
                      selectedColor: AppTheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primary : AppTheme.border,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Available Courses
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Courses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${courseProvider.filteredCourses.length} available',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              if (courseProvider.filteredCourses.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text('No courses found matching your search.'),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: courseProvider.filteredCourses.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final course = courseProvider.filteredCourses[index];
                    final isEnrolled = authProvider.hasPurchasedCourse(course.id);

                    return CourseCard(
                      course: course,
                      isEnrolled: isEnrolled,
                      onTap: () {
                        if (isEnrolled) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseContentViewerScreen(course: course),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailScreen(course: course),
                            ),
                          );
                        }
                      },
                      onEnrollTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UpiPaymentScreen(course: course),
                          ),
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLiveLectureBanner(
    BuildContext context,
    dynamic activeLive,
    AuthProvider authProvider,
  ) {
    final isEnrolled = authProvider.hasPurchasedCourse(activeLive.courseId);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF312E81).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LiveStatusIndicator(viewerCount: activeLive.activeViewerCount),
              Text(
                activeLive.courseTitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            activeLive.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Instructor: ${activeLive.instructorName}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (isEnrolled) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LiveLectureRoomScreen(lecture: activeLive),
                    ),
                  );
                } else {
                  // Show prompt to buy course first
                  _showEnrollToJoinDialog(context, activeLive.courseId);
                }
              },
              icon: Icon(
                isEnrolled ? Icons.videocam : Icons.lock,
                size: 18,
              ),
              label: Text(
                isEnrolled ? 'Join Live Lecture Now' : 'Enroll to Join Live Class',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isEnrolled ? AppTheme.liveRed : AppTheme.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEnrollToJoinDialog(BuildContext context, String courseId) {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final course = courseProvider.getCourseById(courseId);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock, color: AppTheme.accent),
            SizedBox(width: 8),
            Text('Exclusive Live Class'),
          ],
        ),
        content: const Text(
          'This live lecture is exclusive to students enrolled in this course. Purchase the course with any UPI app to access live classes, full lecture videos, MCQs, and PPT notes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          if (course != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpiPaymentScreen(course: course),
                  ),
                );
              },
              child: const Text('Pay with UPI'),
            ),
        ],
      ),
    );
  }
}
