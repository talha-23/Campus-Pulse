import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event.dart';
import '../../providers/event_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/custom_button.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({ super.key, required this.event });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with category
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      _getCategoryIcon(event.category),
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Event details
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                    Icons.calendar_today,
                    'Date & Time',
                    _formatDateTime(event.date),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    Icons.location_on,
                    'Location',
                    event.location,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Consumer<EventProvider>(
                    builder: (context, eventProvider, child) {
                      return CustomButton(
                        text: event.isReminderSet 
                            ? 'Remove Reminder' 
                            : 'Set Reminder',
                        onPressed: () {
                          eventProvider.toggleReminder(event.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                event.isReminderSet
                                    ? 'Reminder removed'
                                    : 'Reminder set for ${_formatTime(event.date)}',
                              ),
                              backgroundColor: AppColors.primaryGreen,
                            ),
                          );
                        },
                        backgroundColor: event.isReminderSet
                            ? Colors.grey
                            : AppColors.primaryGreen,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryGreen, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
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

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}