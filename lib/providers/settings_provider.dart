import 'package:flutter/material.dart';
import '../models/user_preferences.dart';
import '../services/database_service.dart';

class SettingsProvider extends ChangeNotifier {
  UserPreferences _preferences = UserPreferences(
    seminarNotifications: true,
    examNotifications: true,
    festNotifications: true,
    noticeNotifications: true,
    reminderTime: 30,
  );
  
  bool _isLoading = false;
  String? _error;

  final DatabaseService _databaseService = DatabaseService();

  UserPreferences get preferences => _preferences;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPreferences() async {
    _isLoading = true;
    notifyListeners();

    try {
      _preferences = await _databaseService.getPreferences();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateNotificationSettings({
    bool? seminarNotifications,
    bool? examNotifications,
    bool? festNotifications,
    bool? noticeNotifications,
  }) async {
    try {
      final updatedPreferences = UserPreferences(
        seminarNotifications: seminarNotifications ?? _preferences.seminarNotifications,
        examNotifications: examNotifications ?? _preferences.examNotifications,
        festNotifications: festNotifications ?? _preferences.festNotifications,
        noticeNotifications: noticeNotifications ?? _preferences.noticeNotifications,
        reminderTime: _preferences.reminderTime,
      );

      await _databaseService.updatePreferences(updatedPreferences);
      _preferences = updatedPreferences;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateReminderTime(int minutes) async {
    try {
      final updatedPreferences = UserPreferences(
        seminarNotifications: _preferences.seminarNotifications,
        examNotifications: _preferences.examNotifications,
        festNotifications: _preferences.festNotifications,
        noticeNotifications: _preferences.noticeNotifications,
        reminderTime: minutes,
      );

      await _databaseService.updatePreferences(updatedPreferences);
      _preferences = updatedPreferences;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}