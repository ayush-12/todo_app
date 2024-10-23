import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      theme:const CupertinoThemeData(),
      initialRoute: '/',
      routes: appRoutes,
    );
  }
}
