import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SettingsProvider - Manages app settings with persistence
///
/// This provider handles:
/// - Theme mode (dark/light/system)
/// - Accent color customization
/// - User preferences (notifications, haptics, etc.)
/// - All settings persist across app restarts
class SettingsProvider with ChangeNotifier {
  // Onboarding status
  bool _isFirstRun = true;

  // User preferences
  bool _notificationsEnabled = true;
  bool _hapticFeedbackEnabled = true;
  bool _autoRestTimer = true;
  bool _largeTouchTargets = false;
  bool _reducedMotion = false;
  int _defaultRestSeconds = 90;
  String _weightUnit = 'kg';
  int _weeklyGoal = 4;

  // User profile
  String _userName = 'Athlete';
  int _totalXP = 0;
  List<String> _unlockedAchievementIds = [];

  SettingsProvider() {
    _loadSettings();
  }

  // Getters
  bool get isFirstRun => _isFirstRun;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get hapticFeedbackEnabled => _hapticFeedbackEnabled;
  bool get autoRestTimer => _autoRestTimer;
  bool get largeTouchTargets => _largeTouchTargets;
  bool get reducedMotion => _reducedMotion;
  int get defaultRestSeconds => _defaultRestSeconds;
  String get weightUnit => _weightUnit;
  int get weeklyGoal => _weeklyGoal;
  String get userName => _userName;

  // Onboarding
  void completeOnboarding() {
    _isFirstRun = false;
    _saveSettings();
    notifyListeners();
  }

  // Preference setters
  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    _saveSettings();
    notifyListeners();
  }

  void setHapticFeedbackEnabled(bool value) {
    _hapticFeedbackEnabled = value;
    _saveSettings();
    notifyListeners();
  }

  void setAutoRestTimer(bool value) {
    _autoRestTimer = value;
    _saveSettings();
    notifyListeners();
  }

  void setLargeTouchTargets(bool value) {
    _largeTouchTargets = value;
    _saveSettings();
    notifyListeners();
  }

  void setReducedMotion(bool value) {
    _reducedMotion = value;
    _saveSettings();
    notifyListeners();
  }

  void setDefaultRestSeconds(int seconds) {
    _defaultRestSeconds = seconds;
    _saveSettings();
    notifyListeners();
  }

  void setWeightUnit(String unit) {
    _weightUnit = unit;
    _saveSettings();
    notifyListeners();
  }

  void setWeeklyGoal(int value) {
    _weeklyGoal = value;
    _saveSettings();
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    _saveSettings();
    notifyListeners();
  }

  // Level Logic: Level = floor(sqrt(XP / 500)) + 1
  int get userLevel {
    if (_totalXP < 500) return 1;
    return math.sqrt(_totalXP / 500).floor() + 1;
  }

  // Progress to next level (0.0 to 1.0)
  double get levelProgress {
    int currentL = userLevel;
    int xpForCurrent = (currentL - 1) * (currentL - 1) * 500;
    int xpForNext = currentL * currentL * 500;
    if (xpForNext <= xpForCurrent) return 0.0;
    return (math.max(0, _totalXP - xpForCurrent)) / (xpForNext - xpForCurrent);
  }

  void addXP(int amount) {
    _totalXP += amount;
    _saveSettings();
    notifyListeners();
  }

  void unlockAchievement(String id) {
    if (!_unlockedAchievementIds.contains(id)) {
      _unlockedAchievementIds.add(id);
      _saveSettings();
      notifyListeners();
    }
  }

  bool isAchievementUnlocked(String id) => _unlockedAchievementIds.contains(id);

  // Persistence
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('app_settings');

      if (data != null) {
        final json = jsonDecode(data) as Map<String, dynamic>;

        // Onboarding
        _isFirstRun = json['isFirstRun'] ?? true;

        // Preferences
        _notificationsEnabled = json['notificationsEnabled'] ?? true;
        _hapticFeedbackEnabled = json['hapticFeedbackEnabled'] ?? true;
        _autoRestTimer = json['autoRestTimer'] ?? true;
        _largeTouchTargets = json['largeTouchTargets'] ?? false;
        _reducedMotion = json['reducedMotion'] ?? false;
        _defaultRestSeconds = json['defaultRestSeconds'] ?? 90;
        _weightUnit = json['weightUnit'] ?? 'kg';
        _weeklyGoal = json['weeklyGoal'] ?? 4;

        // Profile
        _userName = json['userName'] ?? 'Athlete';
        _totalXP = json['totalXP'] ?? 0;
        _unlockedAchievementIds =
            List<String>.from(json['unlockedAchievementIds'] ?? []);

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonEncode({
        'isFirstRun': _isFirstRun,
        'notificationsEnabled': _notificationsEnabled,
        'hapticFeedbackEnabled': _hapticFeedbackEnabled,
        'autoRestTimer': _autoRestTimer,
        'largeTouchTargets': _largeTouchTargets,
        'reducedMotion': _reducedMotion,
        'defaultRestSeconds': _defaultRestSeconds,
        'weightUnit': _weightUnit,
        'weeklyGoal': _weeklyGoal,
        'userName': _userName,
        'totalXP': _totalXP,
        'unlockedAchievementIds': _unlockedAchievementIds,
      });
      await prefs.setString('app_settings', data);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }
}
