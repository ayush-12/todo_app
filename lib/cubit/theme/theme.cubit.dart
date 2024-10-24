import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeMode { light, dark }

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light); // Start with light mode

  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}
