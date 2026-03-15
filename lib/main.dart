import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/event_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/user_provider.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/events/events_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/events/event_detail_screen.dart';
import 'services/notification_service.dart';
import 'utils/theme.dart';
import 'models/event.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Notification Service
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Campus Pulse',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => WelcomeScreen(),
          '/home': (context) =>
              const MainScreen(), // Changed from HomeScreen to MainScreen
          '/events': (context) => const EventsScreen(),
          '/notifications': (context) => const NotificationsScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/event-detail': (context) {
            final event = ModalRoute.of(context)!.settings.arguments as Event;
            return EventDetailScreen(event: event);
          },
        },
      ),
    );
  }
}
