enum EventCategory { seminar, exam, fest, notice }

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final EventCategory category;
  final bool isReminderSet;
  final DateTime? reminderTime;
  final String? imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.category,
    this.isReminderSet = false,
    this.reminderTime,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'category': category.index,
      'isReminderSet': isReminderSet ? 1 : 0,
      'reminderTime': reminderTime?.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      location: map['location'],
      category: EventCategory.values[map['category']],
      isReminderSet: map['isReminderSet'] == 1,
      reminderTime: map['reminderTime'] != null 
          ? DateTime.parse(map['reminderTime']) 
          : null,
      imageUrl: map['imageUrl'],
    );
  }
}