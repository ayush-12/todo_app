import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/firebase_auth.cubit.dart';

import 'routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
          BlocProvider(create: (_) => FirebaseAuthCubit()),
      ],
      child: CupertinoApp(
        theme:const CupertinoThemeData(),
        initialRoute: '/',
        routes: appRoutes,
      ),
    );
  }
}
