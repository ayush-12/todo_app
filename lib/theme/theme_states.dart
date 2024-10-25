abstract class ThemeState {}

class ThemeInitial extends ThemeState {}

class ToggleTheme extends ThemeState {
  final bool isDarkMode;

  ToggleTheme({required this.isDarkMode});
}
