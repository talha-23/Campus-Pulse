import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../services/mock_data_service.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  final DatabaseService _databaseService = DatabaseService();
  final NotificationService _notificationService = NotificationService();

  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Try to load from database first
      final dbEvents = await _databaseService.getAllEvents();

      if (dbEvents.isEmpty) {
        // If no events in DB, load mock data
        _events = MockDataService.getMockEvents();

        // Save mock events to database
        for (var event in _events) {
          await _databaseService.insertEvent(event);
        }
      } else {
        _events = dbEvents;
      }

      _error = null;
    } catch (e) {
      print('Error loading events: $e');
      // Fallback to mock data on error
      _events = MockDataService.getMockEvents();
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEvent(Event event) async {
    try {
      await _databaseService.insertEvent(event);
      _events.add(event);

      if (event.isReminderSet) {
        await _notificationService.scheduleEventReminder(event);
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleReminder(String eventId) async {
    final index = _events.indexWhere((e) => e.id == eventId);
    if (index == -1) return;

    final event = _events[index];
    final updatedEvent = Event(
      id: event.id,
      title: event.title,
      description: event.description,
      date: event.date,
      location: event.location,
      category: event.category,
      isReminderSet: !event.isReminderSet,
      reminderTime: !event.isReminderSet ? event.date : null,
      imageUrl: event.imageUrl,
    );

    await _databaseService.insertEvent(updatedEvent);
    _events[index] = updatedEvent;

    if (updatedEvent.isReminderSet) {
      await _notificationService.scheduleEventReminder(updatedEvent);
    }

    notifyListeners();
  }

  List<Event> getEventsByCategory(EventCategory category) {
    return _events.where((event) => event.category == category).toList();
  }

  List<Event> getUpcomingEvents() {
    final now = DateTime.now();
    return _events.where((event) => event.date.isAfter(now)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}
