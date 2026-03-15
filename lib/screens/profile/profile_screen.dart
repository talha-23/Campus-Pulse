import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/notification_provider.dart';
import '../../utils/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditProfileDialog(context);
            },
          ),
        ],
      ),
      body: Consumer2<UserProvider, SettingsProvider>(
        builder: (context, userProvider, settingsProvider, child) {
          return ListView(
            children: [
              // Profile Header
              Container(
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
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryGreen,
                      child: Text(
                        userProvider.userName?[0].toUpperCase() ?? 'S',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userProvider.userName ?? 'Student Name',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userProvider.userEmail ?? 'student@college.edu',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${userProvider.userDepartment ?? 'Computer Science'} - Year ${userProvider.userYear ?? 2}',
                        style: const TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Settings Sections
              _buildSection(
                title: 'Notification Preferences',
                children: [
                  _buildSwitchTile(
                    icon: '🎤',
                    title: 'Seminar Notifications',
                    value: settingsProvider.preferences.seminarNotifications,
                    onChanged: (value) {
                      settingsProvider.updateNotificationSettings(
                        seminarNotifications: value,
                      );
                    },
                  ),
                  _buildSwitchTile(
                    icon: '📝',
                    title: 'Exam Notifications',
                    value: settingsProvider.preferences.examNotifications,
                    onChanged: (value) {
                      settingsProvider.updateNotificationSettings(
                        examNotifications: value,
                      );
                    },
                  ),
                  _buildSwitchTile(
                    icon: '🎉',
                    title: 'Fest Notifications',
                    value: settingsProvider.preferences.festNotifications,
                    onChanged: (value) {
                      settingsProvider.updateNotificationSettings(
                        festNotifications: value,
                      );
                    },
                  ),
                  _buildSwitchTile(
                    icon: '📢',
                    title: 'Notice Notifications',
                    value: settingsProvider.preferences.noticeNotifications,
                    onChanged: (value) {
                      settingsProvider.updateNotificationSettings(
                        noticeNotifications: value,
                      );
                    },
                  ),
                ],
              ),

              _buildSection(
                title: 'Reminder Settings',
                children: [
                  ListTile(
                    leading: const Icon(Icons.timer, color: AppColors.primaryGreen),
                    title: const Text('Remind me before events'),
                    subtitle: Text('${settingsProvider.preferences.reminderTime} minutes'),
                    onTap: () {
                      _showReminderTimeDialog(context, settingsProvider);
                    },
                  ),
                ],
              ),

              _buildSection(
                title: 'App Settings',
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications, color: AppColors.primaryGreen),
                    title: const Text('Notification Sound'),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeThumbColor: AppColors.primaryGreen,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.vibration, color: AppColors.primaryGreen),
                    title: const Text('Vibrate'),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeThumbColor: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),

              _buildSection(
                title: 'About',
                children: [
                  const ListTile(
                    leading: Icon(Icons.info, color: AppColors.primaryGreen),
                    title: Text('App Version'),
                    trailing: Text('1.0.0'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip, color: AppColors.primaryGreen),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to privacy policy
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help, color: AppColors.primaryGreen),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to help
                    },
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Logout'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 20)),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primaryGreen,
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final nameController = TextEditingController(text: userProvider.userName);
    final emailController = TextEditingController(text: userProvider.userEmail);
    final departmentController = TextEditingController(text: userProvider.userDepartment);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: departmentController,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                ),
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
            onPressed: () {
              userProvider.updateProfile(
                name: nameController.text,
                email: emailController.text,
                department: departmentController.text,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showReminderTimeDialog(BuildContext context, SettingsProvider provider) {
    int selectedTime = provider.preferences.reminderTime;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reminder Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<int>(
              title: const Text('15 minutes before'),
              value: 15,
              groupValue: selectedTime,
              onChanged: (value) => selectedTime = value!,
              activeColor: AppColors.primaryGreen,
            ),
            RadioListTile<int>(
              title: const Text('30 minutes before'),
              value: 30,
              groupValue: selectedTime,
              onChanged: (value) => selectedTime = value!,
              activeColor: AppColors.primaryGreen,
            ),
            RadioListTile<int>(
              title: const Text('1 hour before'),
              value: 60,
              groupValue: selectedTime,
              onChanged: (value) => selectedTime = value!,
              activeColor: AppColors.primaryGreen,
            ),
            RadioListTile<int>(
              title: const Text('2 hours before'),
              value: 120,
              groupValue: selectedTime,
              onChanged: (value) => selectedTime = value!,
              activeColor: AppColors.primaryGreen,
            ),
            RadioListTile<int>(
              title: const Text('1 day before'),
              value: 1440,
              groupValue: selectedTime,
              onChanged: (value) => selectedTime = value!,
              activeColor: AppColors.primaryGreen,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.updateReminderTime(selectedTime);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              userProvider.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}