import 'package:flutter/material.dart';
import '../models/live_lecture_model.dart';
import '../services/mock_database.dart';

class LiveLectureProvider extends ChangeNotifier {
  List<LiveLectureModel> _lectures = [];
  LiveLectureModel? _activeRoom;

  // In-room classroom interactive states
  bool _isMicMuted = false;
  bool _isCameraOff = false;
  bool _isHandRaised = false;
  bool _isPresentationMode = false; // Toggle between teacher camera vs presentation slides

  List<LiveLectureModel> get lectures => _lectures;
  LiveLectureModel? get activeRoom => _activeRoom;
  bool get isMicMuted => _isMicMuted;
  bool get isCameraOff => _isCameraOff;
  bool get isHandRaised => _isHandRaised;
  bool get isPresentationMode => _isPresentationMode;

  List<LiveLectureModel> get activeLiveSessions =>
      _lectures.where((l) => l.isLiveNow).toList();

  List<LiveLectureModel> get upcomingSessions =>
      _lectures.where((l) => !l.isLiveNow).toList();

  LiveLectureProvider() {
    _loadLectures();
  }

  void _loadLectures() {
    _lectures = MockDatabase.getInitialLiveLectures();
    notifyListeners();
  }

  void joinRoom(LiveLectureModel lecture) {
    _activeRoom = lecture;
    _isMicMuted = false;
    _isCameraOff = false;
    _isHandRaised = false;
    _isPresentationMode = false;
    notifyListeners();
  }

  void leaveRoom() {
    _activeRoom = null;
    notifyListeners();
  }

  void toggleMic() {
    _isMicMuted = !_isMicMuted;
    notifyListeners();
  }

  void toggleCamera() {
    _isCameraOff = !_isCameraOff;
    notifyListeners();
  }

  void toggleHandRaise() {
    _isHandRaised = !_isHandRaised;
    notifyListeners();
  }

  void togglePresentationMode() {
    _isPresentationMode = !_isPresentationMode;
    notifyListeners();
  }

  /// Send message in live lecture chat
  void sendChatMessage({
    required String senderId,
    required String senderName,
    String? senderAvatar,
    required String message,
    required bool isEducator,
  }) {
    if (_activeRoom == null || message.trim().isEmpty) return;

    final newMsg = LiveChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      senderName: senderName,
      senderAvatar: senderAvatar,
      message: message.trim(),
      isEducator: isEducator,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [..._activeRoom!.chatMessages, newMsg];
    _activeRoom = _activeRoom!.copyWith(chatMessages: updatedMessages);

    // Also update the lecture in the list
    final idx = _lectures.indexWhere((l) => l.id == _activeRoom!.id);
    if (idx != -1) {
      _lectures[idx] = _activeRoom!;
    }

    notifyListeners();
  }

  /// Schedule a new live lecture (for educators)
  void scheduleLiveLecture(LiveLectureModel newLecture) {
    _lectures.insert(0, newLecture);
    notifyListeners();
  }
}
