import 'package:firebase_database/firebase_database.dart';
import '../models/event.dart';

class FirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  late DatabaseReference _eventsRef;

  FirebaseService() {
    _eventsRef = _database.ref('events');
  }

  // Listen to real-time event updates
  Stream<List<Event>> getEventsStream() {
    return _eventsRef.onValue.map((event) {
      final List<Event> events = [];
      final snapshot = event.snapshot;
      
      if (snapshot.value != null) {
        final Map<dynamic, dynamic> eventsMap = snapshot.value as Map;
        eventsMap.forEach((key, value) {
          final Map<String, dynamic> eventData = Map<String, dynamic>.from(value);
          eventData['id'] = key;
          events.add(Event.fromMap(eventData));
        });
      }
      
      return events;
    });
  }

  // Add new event to Firebase
  Future<void> addEvent(Event event) async {
    await _eventsRef.child(event.id).set(event.toMap());
  }

  // Update existing event
  Future<void> updateEvent(Event event) async {
    await _eventsRef.child(event.id).update(event.toMap());
  }

  // Delete event
  Future<void> deleteEvent(String eventId) async {
    await _eventsRef.child(eventId).remove();
  }

  // Get single event
  Future<Event?> getEvent(String eventId) async {
    final snapshot = await _eventsRef.child(eventId).get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data['id'] = eventId;
      return Event.fromMap(data);
    }
    return null;
  }

  // Get events by category
  Stream<List<Event>> getEventsByCategory(String category) {
    return _eventsRef
        .orderByChild('category')
        .equalTo(category)
        .onValue
        .map((event) {
          final List<Event> events = [];
          final snapshot = event.snapshot;
          
          if (snapshot.value != null) {
            final Map<dynamic, dynamic> eventsMap = snapshot.value as Map;
            eventsMap.forEach((key, value) {
              final Map<String, dynamic> eventData = Map<String, dynamic>.from(value);
              eventData['id'] = key;
              events.add(Event.fromMap(eventData));
            });
          }
          
          return events;
        });
  }
}