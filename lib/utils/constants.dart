class AppConstants {
  // App Info
  static const String appName = 'Campus Pulse';
  static const String appVersion = '1.0.0';
  
  // Database
  static const String databaseName = 'campus_pulse.db';
  static const int databaseVersion = 1;
  
  // Notification Channels
  static const String notificationChannelId = 'campus_pulse_channel';
  static const String notificationChannelName = 'Campus Pulse Notifications';
  static const String notificationChannelDescription = 'Notifications for campus events';
  
  // Shared Preferences Keys
  static const String prefOnboardingComplete = 'onboarding_complete';
  static const String prefUserName = 'user_name';
  static const String prefUserEmail = 'user_email';
  static const String prefUserDepartment = 'user_department';
  static const String prefUserYear = 'user_year';
  static const String prefIsLoggedIn = 'is_logged_in';
  
  // API Endpoints (if using REST API)
  static const String baseUrl = 'https://api.campuspulse.com';
  static const String eventsEndpoint = '$baseUrl/events';
  static const String notificationsEndpoint = '$baseUrl/notifications';
  
  // Timing Constants
  static const int splashScreenDuration = 2; // seconds
  static const int notificationTimeout = 5; // seconds
  static const int cacheTimeout = 3600; // 1 hour in seconds
  
  // Error Messages
  static const String networkError = 'Network connection error. Please check your internet.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unknown error occurred.';
  static const String emptyFieldError = 'Please fill in all fields.';
  static const String invalidEmailError = 'Please enter a valid email address.';
}

class EventConstants {
  static const List<String> departments = [
    'Computer Science',
    'Information Technology',
    'Electronics',
    'Mechanical',
    'Civil',
    'Electrical',
    'Chemical',
    'Biotechnology',
  ];
  
  static const List<int> years = [1, 2, 3, 4];
  
  static const Map<String, String> categoryIcons = {
    'seminar': '🎤',
    'exam': '📝',
    'fest': '🎉',
    'notice': '📢',
  };
}