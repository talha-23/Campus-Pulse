enum NotificationType { seminar, exam, fest, notice, reminder }

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;
  final String? eventId;
  final Map<String, dynamic>? data;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    required this.type,
    this.eventId,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead ? 1 : 0,
      'type': type.index,
      'eventId': eventId,
      'data': data?.toString(),
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      timestamp: DateTime.parse(map['timestamp']),
      isRead: map['isRead'] == 1,
      type: NotificationType.values[map['type']],
      eventId: map['eventId'],
      data: map['data'] != null ? {} : null, // Simplified for example
    );
  }

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
    String? eventId,
    Map<String, dynamic>? data,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      eventId: eventId ?? this.eventId,
      data: data ?? this.data,
    );
  }
}