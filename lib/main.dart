import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/auth/firebase_auth.cubit.dart';
import 'package:todo_app/cubit/home/home_cubit.dart';
import 'package:todo_app/cubit/theme/theme.cubit.dart';
import 'package:todo_app/cubit/todo/todo_cubit.dart';

import 'cubit/user/user_cubit.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FirebaseAuthCubit()),
        BlocProvider(create: (_) => UserCubit()),
        BlocProvider(create: (_) => TodoCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => ThemeCubit())
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, theme) {
        return CupertinoApp(
          theme: CupertinoThemeData(
            brightness:
                theme == ThemeMode.dark ? Brightness.dark : Brightness.light,
          ),
          initialRoute: '/',
          routes: appRoutes,
        );
      }),
    );
  }
}
