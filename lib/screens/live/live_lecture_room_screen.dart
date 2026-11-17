import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../models/live_lecture_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/live_lecture_provider.dart';
import '../../providers/ppt_provider.dart';
import '../../widgets/live_status_indicator.dart';

class LiveLectureRoomScreen extends StatefulWidget {
  final LiveLectureModel lecture;

  const LiveLectureRoomScreen({super.key, required this.lecture});

  @override
  State<LiveLectureRoomScreen> createState() => _LiveLectureRoomScreenState();
}

class _LiveLectureRoomScreenState extends State<LiveLectureRoomScreen> {
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LiveLectureProvider>(context, listen: false).joinRoom(widget.lecture);
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final liveProvider = Provider.of<LiveLectureProvider>(context, listen: false);
    final user = authProvider.currentUser;

    liveProvider.sendChatMessage(
      senderId: user?.id ?? 'student_guest',
      senderName: user?.name ?? 'Student',
      senderAvatar: user?.photoUrl,
      message: text,
      isEducator: authProvider.isEducator,
    );

    _chatController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final liveProvider = Provider.of<LiveLectureProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final pptProvider = Provider.of<PptProvider>(context);

    final room = liveProvider.activeRoom ?? widget.lecture;
    final defaultDeck = pptProvider.decks.isNotEmpty ? pptProvider.decks.first : null;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Classroom Header Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF111827),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      liveProvider.leaveRoom();
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.title,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${room.instructorName} • ${room.courseTitle}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  LiveStatusIndicator(viewerCount: room.activeViewerCount + 1, compact: true),
                ],
              ),
            ),

            // Classroom Stage (Video Stream OR Shared PPT Slides)
            Expanded(
              flex: 4,
              child: Container(
                color: const Color(0xFF1E293B),
                child: liveProvider.isPresentationMode && defaultDeck != null
                    ? _buildPresentationSlideView(defaultDeck)
                    : _buildLiveVideoStage(room, liveProvider),
              ),
            ),

            // Interactive Classroom Controls Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: const Color(0xFF0F172A),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Mic Toggle
                  _buildControlButton(
                    icon: liveProvider.isMicMuted ? Icons.mic_off : Icons.mic,
                    label: liveProvider.isMicMuted ? 'Muted' : 'Mic On',
                    color: liveProvider.isMicMuted ? AppTheme.error : Colors.white70,
                    isActive: !liveProvider.isMicMuted,
                    onTap: () => liveProvider.toggleMic(),
                  ),

                  // Camera Toggle
                  _buildControlButton(
                    icon: liveProvider.isCameraOff ? Icons.videocam_off : Icons.videocam,
                    label: liveProvider.isCameraOff ? 'Camera Off' : 'Camera On',
                    color: liveProvider.isCameraOff ? AppTheme.error : Colors.white70,
                    isActive: !liveProvider.isCameraOff,
                    onTap: () => liveProvider.toggleCamera(),
                  ),

                  // Raise Hand Button
                  _buildControlButton(
                    icon: Icons.pan_tool,
                    label: liveProvider.isHandRaised ? 'Hand Raised' : 'Raise Hand',
                    color: liveProvider.isHandRaised ? AppTheme.accent : Colors.white70,
                    isActive: liveProvider.isHandRaised,
                    onTap: () => liveProvider.toggleHandRaise(),
                  ),

                  // Toggle Presentation Slide Mode
                  _buildControlButton(
                    icon: Icons.slideshow,
                    label: liveProvider.isPresentationMode ? 'Show Video' : 'Show Slides',
                    color: liveProvider.isPresentationMode ? AppTheme.secondary : Colors.white70,
                    isActive: liveProvider.isPresentationMode,
                    onTap: () => liveProvider.togglePresentationMode(),
                  ),

                  // Leave Lecture Room
                  _buildControlButton(
                    icon: Icons.call_end,
                    label: 'Leave',
                    color: AppTheme.error,
                    isActive: true,
                    onTap: () {
                      liveProvider.leaveRoom();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),

            // Live In-Class Chat Section
            Expanded(
              flex: 3,
              child: Container(
                color: const Color(0xFF1E293B),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      color: const Color(0xFF334155),
                      child: const Row(
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 14, color: Colors.white70),
                          SizedBox(width: 8),
                          Text(
                            'Live In-Class Questions & Discussion',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Chat messages list
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        itemCount: room.chatMessages.length,
                        itemBuilder: (context, index) {
                          final msg = room.chatMessages[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: msg.isEducator
                                      ? AppTheme.primary
                                      : const Color(0xFF475569),
                                  child: Text(
                                    msg.senderName.isNotEmpty ? msg.senderName[0] : 'S',
                                    style: const TextStyle(fontSize: 10, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${msg.senderName} ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: msg.isEducator
                                                ? const Color(0xFF818CF8)
                                                : Colors.white,
                                          ),
                                        ),
                                        if (msg.isEducator)
                                          WidgetSpan(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                              margin: const EdgeInsets.only(right: 4),
                                              decoration: const BoxDecoration(
                                                color: AppTheme.primary,
                                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                              ),
                                              child: const Text('HOST', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                        TextSpan(
                                          text: msg.message,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Chat Input Row
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      color: const Color(0xFF0F172A),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _chatController,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Ask educator a question...',
                                hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                                fillColor: const Color(0xFF1E293B),
                                filled: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppTheme.primary,
                            child: IconButton(
                              icon: const Icon(Icons.send, size: 16, color: Colors.white),
                              onPressed: _sendMessage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveVideoStage(LiveLectureModel room, LiveLectureProvider liveProvider) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundImage: NetworkImage(room.instructorAvatar),
                backgroundColor: AppTheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                '${room.instructorName} is Speaking',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(color: AppTheme.success, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  const Text('HD 1080p Stream Active', style: TextStyle(color: Colors.white60, fontSize: 11)),
                ],
              ),
            ],
          ),
        ),

        // Hand raised notification banner
        if (liveProvider.isHandRaised)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.pan_tool, size: 14, color: Colors.white),
                  SizedBox(width: 4),
                  Text('Hand Raised - Host Notified', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPresentationSlideView(dynamic deck) {
    final slide = deck.slides.first;

    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF0F172A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('SYNCHRONIZED SLIDES', style: TextStyle(color: AppTheme.secondary, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              Text(
                deck.title,
                style: const TextStyle(color: Colors.white60, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            slide.title,
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: slide.bulletPoints.map<Widget>((pt) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(color: AppTheme.secondary, fontSize: 14, fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                        pt,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: color, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
