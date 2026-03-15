import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import 'notification_permission_screen.dart';
import '../../utils/theme.dart';
import '../../widgets/custom_button.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool seminarEnabled = true;
  bool examEnabled = true;
  bool festEnabled = true;
  bool noticeEnabled = true;
  int reminderTime = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Preferences'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What would you like to be notified about?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            _buildPreferenceTile(
              icon: '🎤',
              title: 'Seminars & Workshops',
              value: seminarEnabled,
              onChanged: (value) => setState(() => seminarEnabled = value),
            ),
            
            _buildPreferenceTile(
              icon: '📝',
              title: 'Exams & Deadlines',
              value: examEnabled,
              onChanged: (value) => setState(() => examEnabled = value),
            ),
            
            _buildPreferenceTile(
              icon: '🎉',
              title: 'Fests & Cultural Events',
              value: festEnabled,
              onChanged: (value) => setState(() => festEnabled = value),
            ),
            
            _buildPreferenceTile(
              icon: '📢',
              title: 'Important Notices',
              value: noticeEnabled,
              onChanged: (value) => setState(() => noticeEnabled = value),
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              'Reminder Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.lightGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: reminderTime,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 15, child: Text('15 minutes before')),
                    DropdownMenuItem(value: 30, child: Text('30 minutes before')),
                    DropdownMenuItem(value: 60, child: Text('1 hour before')),
                    DropdownMenuItem(value: 120, child: Text('2 hours before')),
                    DropdownMenuItem(value: 1440, child: Text('1 day before')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      reminderTime = value!;
                    });
                  },
                ),
              ),
            ),
            
            const Spacer(),
            
            CustomButton(
              text: 'Continue',
              onPressed: () {
                // Save preferences
                final settingsProvider = Provider.of<SettingsProvider>(
                  context, 
                  listen: false
                );
                
                settingsProvider.updateNotificationSettings(
                  seminarNotifications: seminarEnabled,
                  examNotifications: examEnabled,
                  festNotifications: festEnabled,
                  noticeNotifications: noticeEnabled,
                );
                
                settingsProvider.updateReminderTime(reminderTime);
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPermissionScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceTile({
    required String icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }
}