import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/database_service.dart';
import '../services/mock_data_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  final DatabaseService _databaseService = DatabaseService();

  List<AppNotification> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();

    try {
      // For now, load mock notifications
      _notifications = MockDataService.getMockNotifications();
      _updateUnreadCount();
      _error = null;
    } catch (e) {
      print('Error loading notifications: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n.isRead).length;
  }

  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index == -1) return;

    _notifications[index] = _notifications[index].copyWith(isRead: true);
    _updateUnreadCount();
    notifyListeners();
  }

  Future<void> markAllAsRead() async {
    for (int i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    _unreadCount = 0;
    notifyListeners();
  }

  Future<void> addNotification(AppNotification notification) async {
    _notifications.insert(0, notification);
    _updateUnreadCount();
    notifyListeners();
  }

  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    _updateUnreadCount();
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }
}
