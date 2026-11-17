class LiveChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String message;
  final bool isEducator;
  final DateTime timestamp;

  const LiveChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.message,
    this.isEducator = false,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'senderAvatar': senderAvatar,
      'message': message,
      'isEducator': isEducator,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LiveChatMessage.fromJson(Map<String, dynamic> json) {
    return LiveChatMessage(
      id: json['id'] as String,
      senderId: json['senderId'] as String,
      senderName: json['senderName'] as String,
      senderAvatar: json['senderAvatar'] as String?,
      message: json['message'] as String,
      isEducator: json['isEducator'] as bool? ?? false,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class LiveLectureModel {
  final String id;
  final String courseId;
  final String courseTitle;
  final String title;
  final String description;
  final String instructorName;
  final String instructorAvatar;
  final DateTime scheduledStartTime;
  final int durationMinutes;
  final bool isLiveNow;
  final int activeViewerCount;
  final String? linkedPptId;
  final List<LiveChatMessage> chatMessages;

  const LiveLectureModel({
    required this.id,
    required this.courseId,
    required this.courseTitle,
    required this.title,
    required this.description,
    required this.instructorName,
    required this.instructorAvatar,
    required this.scheduledStartTime,
    this.durationMinutes = 60,
    this.isLiveNow = false,
    this.activeViewerCount = 0,
    this.linkedPptId,
    this.chatMessages = const [],
  });

  LiveLectureModel copyWith({
    String? id,
    String? courseId,
    String? courseTitle,
    String? title,
    String? description,
    String? instructorName,
    String? instructorAvatar,
    DateTime? scheduledStartTime,
    int? durationMinutes,
    bool? isLiveNow,
    int? activeViewerCount,
    String? linkedPptId,
    List<LiveChatMessage>? chatMessages,
  }) {
    return LiveLectureModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      title: title ?? this.title,
      description: description ?? this.description,
      instructorName: instructorName ?? this.instructorName,
      instructorAvatar: instructorAvatar ?? this.instructorAvatar,
      scheduledStartTime: scheduledStartTime ?? this.scheduledStartTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isLiveNow: isLiveNow ?? this.isLiveNow,
      activeViewerCount: activeViewerCount ?? this.activeViewerCount,
      linkedPptId: linkedPptId ?? this.linkedPptId,
      chatMessages: chatMessages ?? this.chatMessages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'title': title,
      'description': description,
      'instructorName': instructorName,
      'instructorAvatar': instructorAvatar,
      'scheduledStartTime': scheduledStartTime.toIso8601String(),
      'durationMinutes': durationMinutes,
      'isLiveNow': isLiveNow,
      'activeViewerCount': activeViewerCount,
      'linkedPptId': linkedPptId,
      'chatMessages': chatMessages.map((c) => c.toJson()).toList(),
    };
  }

  factory LiveLectureModel.fromJson(Map<String, dynamic> json) {
    return LiveLectureModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      courseTitle: json['courseTitle'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      instructorName: json['instructorName'] as String,
      instructorAvatar: json['instructorAvatar'] as String? ?? '',
      scheduledStartTime: DateTime.parse(json['scheduledStartTime']),
      durationMinutes: json['durationMinutes'] as int? ?? 60,
      isLiveNow: json['isLiveNow'] as bool? ?? false,
      activeViewerCount: json['activeViewerCount'] as int? ?? 0,
      linkedPptId: json['linkedPptId'] as String?,
      chatMessages: (json['chatMessages'] as List<dynamic>? ?? [])
          .map((m) => LiveChatMessage.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}
