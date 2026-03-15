import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../providers/event_provider.dart';
import '../../widgets/event_card.dart';
import '../../utils/theme.dart';
import 'event_detail_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  EventCategory _selectedCategory = EventCategory.seminar;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategory = EventCategory.values[_tabController.index];
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Text('🎤'), text: 'Seminars'),
            Tab(icon: Text('📝'), text: 'Exams'),
            Tab(icon: Text('🎉'), text: 'Fests'),
            Tab(icon: Text('📢'), text: 'Notices'),
          ],
        ),
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          if (eventProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final events = eventProvider.getEventsByCategory(_selectedCategory);

          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No events in this category',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailScreen(event: event),
                    ),
                  );
                },
                child: EventCard(
                  event: event,
                  onReminderPressed: () {
                    eventProvider.toggleReminder(event.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddEventDialog(context);
        },
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    EventCategory selectedCategory = EventCategory.seminar;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(
                    'Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    selectedDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      selectedDate.hour,
                      selectedDate.minute,
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<EventCategory>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: EventCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Text(_getCategoryIcon(category)),
                        const SizedBox(width: 8),
                        Text(category.toString().split('.').last),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a title')),
                );
                return;
              }

              final newEvent = Event(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleController.text,
                description: descriptionController.text,
                date: selectedDate,
                location: locationController.text.isEmpty
                    ? 'TBD'
                    : locationController.text,
                category: selectedCategory,
                isReminderSet: false,
                reminderTime: null,
                imageUrl: null,
              );

              await Provider.of<EventProvider>(context, listen: false)
                  .addEvent(newEvent);

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Event "${newEvent.title}" added successfully'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  String _getCategoryIcon(EventCategory category) {
    switch (category) {
      case EventCategory.seminar:
        return '🎤';
      case EventCategory.exam:
        return '📝';
      case EventCategory.fest:
        return '🎉';
      case EventCategory.notice:
        return '📢';
    }
  }
}
