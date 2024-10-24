import 'package:flutter/material.dart';
import 'package:todo_app/screens/home.dart';
import 'package:todo_app/screens/user_creation.dart';

import 'screens/login.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => LoginScreen(),
  '/createAccount': (context) => const CreateUserScreen(),
  '/home': (context) => const HomeScreen()
};
