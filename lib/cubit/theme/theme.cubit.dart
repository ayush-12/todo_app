import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/design_system/todo_colors.dart';

class ThemeCubit extends Cubit<Brightness> {
  static const String _themeKey = 'isDarkMode';

  ThemeCubit() : super(Brightness.light) {
    _loadTheme();
  }

  /// Load theme from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool(_themeKey) ?? false;
    emit(isDarkMode ? Brightness.dark : Brightness.light);
  }

  /// Toggle theme and save to SharedPreferences
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = state == Brightness.light;
    await prefs.setBool(_themeKey, isDarkMode);
    emit(isDarkMode ? Brightness.dark : Brightness.light);
  }

  /// Get the appropriate color palette based on the theme
  TodoColors get colors => TodoColors.getPalette(state);
}
