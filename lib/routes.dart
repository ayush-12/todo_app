import 'package:flutter/material.dart';
import 'package:todo_app/screens/home.dart';

import 'screens/login.dart';

final Map<String, WidgetBuilder> appRoutes = {
   '/': (context) =>  LoginScreen(),
   '/home': (context) => const HomeScreen()
 
};
