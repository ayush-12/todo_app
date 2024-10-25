import 'package:flutter/material.dart';

import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/user_creation.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginScreen(),
  '/createAccount': (context) => const CreateUserScreen(),
  '/home': (context) => const HomeScreen()
};
