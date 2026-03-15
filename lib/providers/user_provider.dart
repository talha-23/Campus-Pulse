import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _userName;
  String? _userEmail;
  String? _userDepartment;
  int? _userYear;
  bool _isOnboardingComplete = false;
  bool _isLoggedIn = false;

  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userDepartment => _userDepartment;
  int? get userYear => _userYear;
  bool get isOnboardingComplete => _isOnboardingComplete;
  bool get isLoggedIn => _isLoggedIn;

  UserProvider() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name');
    _userEmail = prefs.getString('user_email');
    _userDepartment = prefs.getString('user_department');
    _userYear = prefs.getInt('user_year');
    _isOnboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    notifyListeners();
  }

  Future<void> completeOnboarding({
    required String name,
    required String email,
    required String department,
    required int year,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_department', department);
    await prefs.setInt('user_year', year);
    await prefs.setBool('onboarding_complete', true);
    await prefs.setBool('is_logged_in', true);

    _userName = name;
    _userEmail = email;
    _userDepartment = department;
    _userYear = year;
    _isOnboardingComplete = true;
    _isLoggedIn = true;
    
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? department,
    int? year,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (name != null) {
      await prefs.setString('user_name', name);
      _userName = name;
    }
    if (email != null) {
      await prefs.setString('user_email', email);
      _userEmail = email;
    }
    if (department != null) {
      await prefs.setString('user_department', department);
      _userDepartment = department;
    }
    if (year != null) {
      await prefs.setInt('user_year', year);
      _userYear = year;
    }

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    _isLoggedIn = false;
    notifyListeners();
  }
}