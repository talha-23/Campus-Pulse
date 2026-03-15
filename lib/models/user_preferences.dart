class UserPreferences {
  final bool seminarNotifications;
  final bool examNotifications;
  final bool festNotifications;
  final bool noticeNotifications;
  final int reminderTime; // minutes before event

  UserPreferences({
    required this.seminarNotifications,
    required this.examNotifications,
    required this.festNotifications,
    required this.noticeNotifications,
    this.reminderTime = 30,
  });

  Map<String, dynamic> toMap() {
    return {
      'seminarNotifications': seminarNotifications ? 1 : 0,
      'examNotifications': examNotifications ? 1 : 0,
      'festNotifications': festNotifications ? 1 : 0,
      'noticeNotifications': noticeNotifications ? 1 : 0,
      'reminderTime': reminderTime,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      seminarNotifications: map['seminarNotifications'] == 1,
      examNotifications: map['examNotifications'] == 1,
      festNotifications: map['festNotifications'] == 1,
      noticeNotifications: map['noticeNotifications'] == 1,
      reminderTime: map['reminderTime'] ?? 30,
    );
  }
}