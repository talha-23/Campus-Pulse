import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../home/home_screen.dart';
import '../../services/notification_service.dart';
import '../../utils/theme.dart';
import '../../widgets/custom_button.dart';
import '../../screens/main_screen.dart';

class NotificationPermissionScreen extends StatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  State<NotificationPermissionScreen> createState() => _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState extends State<NotificationPermissionScreen> {
  bool _isRequesting = false;

  Future<void> _requestPermissions() async {
    setState(() => _isRequesting = true);

    try {
      final notificationService = NotificationService();
      final settings = await notificationService.requestPermissions();
      
      if (settings != null) {
        // Permissions granted
        _completeOnboarding();
      } else {
        // Permissions denied, still continue but show warning
        _showPermissionDeniedDialog();
      }
    } catch (e) {
      // Error requesting permissions
      _completeOnboarding();
    } finally {
      setState(() => _isRequesting = false);
    }
  }

  void _completeOnboarding() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    // Mark onboarding as complete
    userProvider.completeOnboarding(
      name: 'Student', // In real app, you'd collect this earlier
      email: 'student@college.edu',
      department: 'Computer Science',
      year: 2,
    );

    // Navigate to home
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) =>  MainScreen()),
      (route) => false,
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications Disabled'),
        content: const Text(
          'You won\'t receive notifications about campus events. '
          'You can enable them later in Settings.'
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _completeOnboarding();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primaryGreen, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    size: 80,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Stay Updated',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Get real-time notifications about campus events, '
                  'exam schedules, fests, and important announcements.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                if (_isRequesting)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                else ...[
                  CustomButton(
                    text: 'Enable Notifications',
                    onPressed: _requestPermissions,
                    backgroundColor: Colors.white,
                    textColor: AppColors.primaryGreen,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: const Text(
                      'Skip for now',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}