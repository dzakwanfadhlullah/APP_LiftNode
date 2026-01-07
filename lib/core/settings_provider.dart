import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

/// SettingsProvider - Manages app settings with persistence
///
/// This provider handles:
/// - Theme mode (dark/light/system)
/// - Accent color customization
/// - User preferences (notifications, haptics, etc.)
/// - All settings persist across app restarts
class SettingsProvider with ChangeNotifier {
  // Theme settings
  ThemeMode _themeMode = ThemeMode.dark;
  Color _accentColor = AppColors.brandPrimary;

  // User preferences
  bool _notificationsEnabled = true;
  bool _hapticFeedbackEnabled = true;
  bool _autoRestTimer = true;
  int _defaultRestSeconds = 90;
  String _weightUnit = 'kg';

  // User profile
  String _userName = 'Athlete';

  // Available accent colors
  static const List<Color> accentColors = [
    AppColors.brandPrimary, // Green
    Color(0xFF3B82F6), // Blue
    Color(0xFFA855F7), // Purple
    Color(0xFFF97316), // Orange
    Color(0xFFEF4444), // Red
    Color(0xFF14B8A6), // Teal
  ];

  SettingsProvider() {
    _loadSettings();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  Color get accentColor => _accentColor;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get hapticFeedbackEnabled => _hapticFeedbackEnabled;
  bool get autoRestTimer => _autoRestTimer;
  int get defaultRestSeconds => _defaultRestSeconds;
  String get weightUnit => _weightUnit;
  String get userName => _userName;

  // Theme setters
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _saveSettings();
    notifyListeners();
  }

  void setAccentColor(Color color) {
    _accentColor = color;
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

  void setUserName(String name) {
    _userName = name;
    _saveSettings();
    notifyListeners();
  }

  // Persistence
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('app_settings');

      if (data != null) {
        final json = jsonDecode(data) as Map<String, dynamic>;

        // Theme
        _themeMode = ThemeMode.values[json['themeMode'] ?? 0];
        _accentColor =
            Color(json['accentColor'] ?? AppColors.brandPrimary.value);

        // Preferences
        _notificationsEnabled = json['notificationsEnabled'] ?? true;
        _hapticFeedbackEnabled = json['hapticFeedbackEnabled'] ?? true;
        _autoRestTimer = json['autoRestTimer'] ?? true;
        _defaultRestSeconds = json['defaultRestSeconds'] ?? 90;
        _weightUnit = json['weightUnit'] ?? 'kg';

        // Profile
        _userName = json['userName'] ?? 'Athlete';

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
        'themeMode': _themeMode.index,
        'accentColor': _accentColor.value,
        'notificationsEnabled': _notificationsEnabled,
        'hapticFeedbackEnabled': _hapticFeedbackEnabled,
        'autoRestTimer': _autoRestTimer,
        'defaultRestSeconds': _defaultRestSeconds,
        'weightUnit': _weightUnit,
        'userName': _userName,
      });
      await prefs.setString('app_settings', data);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }
}
