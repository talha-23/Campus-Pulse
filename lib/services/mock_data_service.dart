import '../models/event.dart';
import '../models/notification.dart';

class MockDataService {
  static List<Event> getMockEvents() {
    return [
      Event(
        id: '1',
        title: 'Flutter Workshop',
        description: 'Learn Flutter from scratch with hands-on projects',
        date: DateTime.now().add(const Duration(days: 2)),
        location: 'Computer Science Building, Room 101',
        category: EventCategory.seminar,
        isReminderSet: false,
        reminderTime: null,
        imageUrl: null,
      ),
      Event(
        id: '2',
        title: 'Mid-Term Exams',
        description: 'Computer Science Department Mid-Term Examinations',
        date: DateTime.now().add(const Duration(days: 7)),
        location: 'Exam Hall A',
        category: EventCategory.exam,
        isReminderSet: false,
        reminderTime: null,
        imageUrl: null,
      ),
      Event(
        id: '3',
        title: 'Spring Fest 2024',
        description: 'Annual cultural festival with music, dance, and food',
        date: DateTime.now().add(const Duration(days: 14)),
        location: 'Main Auditorium',
        category: EventCategory.fest,
        isReminderSet: false,
        reminderTime: null,
        imageUrl: null,
      ),
      Event(
        id: '4',
        title: 'Holiday Notice',
        description: 'University closed for Independence Day',
        date: DateTime.now().add(const Duration(days: 5)),
        location: 'All Campus',
        category: EventCategory.notice,
        isReminderSet: false,
        reminderTime: null,
        imageUrl: null,
      ),
      Event(
        id: '5',
        title: 'AI Seminar',
        description: 'Introduction to Artificial Intelligence and Machine Learning',
        date: DateTime.now().add(const Duration(hours: 3)),
        location: 'Online (Zoom)',
        category: EventCategory.seminar,
        isReminderSet: false,
        reminderTime: null,
        imageUrl: null,
      ),
    ];
  }

  static List<AppNotification> getMockNotifications() {
    return [
      AppNotification(
        id: 'n1',
        title: 'New Seminar Added',
        body: 'Flutter Workshop starting in 2 days',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.seminar,
        isRead: false,
        eventId: '1',
      ),
      AppNotification(
        id: 'n2',
        title: 'Exam Schedule',
        body: 'Mid-term exams begin next week',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.exam,
        isRead: true,
        eventId: '2',
      ),
      AppNotification(
        id: 'n3',
        title: 'Fest Registration',
        body: 'Spring Fest 2024 registrations are open',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        type: NotificationType.fest,
        isRead: false,
        eventId: '3',
      ),
    ];
  }
}