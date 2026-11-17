import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import 'student_home_screen.dart';
import 'student_my_courses_screen.dart';
import 'student_profile_screen.dart';
import '../live/live_lecture_room_screen.dart';
import '../../providers/live_lecture_provider.dart';
import 'package:provider/provider.dart';

class StudentMainNavigation extends StatefulWidget {
  final int initialIndex;

  const StudentMainNavigation({super.key, this.initialIndex = 0});

  @override
  State<StudentMainNavigation> createState() => _StudentMainNavigationState();
}

class _StudentMainNavigationState extends State<StudentMainNavigation> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    StudentHomeScreen(),
    StudentMyCoursesScreen(),
    StudentProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final liveProvider = Provider.of<LiveLectureProvider>(context);
    final hasActiveLive = liveProvider.activeLiveSessions.isNotEmpty;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          backgroundColor: Colors.white,
          elevation: 0,
          indicatorColor: AppTheme.primaryLight,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore, color: AppTheme.primary),
              label: 'Explore',
            ),
            const NavigationDestination(
              icon: Icon(Icons.school_outlined),
              selectedIcon: Icon(Icons.school, color: AppTheme.primary),
              label: 'My Courses',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: hasActiveLive,
                backgroundColor: AppTheme.liveRed,
                child: const Icon(Icons.person_outline),
              ),
              selectedIcon: const Icon(Icons.person, color: AppTheme.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
