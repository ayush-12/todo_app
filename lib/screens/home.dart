import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/auth/firebase_auth.cubit.dart';
import 'package:todo_app/cubit/home/home_cubit.dart';
import 'package:todo_app/cubit/home/home_states.dart';
import 'package:todo_app/cubit/theme/theme.cubit.dart';
import 'package:todo_app/cubit/todo/todo_cubit.dart';
import 'package:todo_app/cubit/todo/todo_states.dart';
import 'package:todo_app/widgets/add_todo_dialog.dart';
import 'package:todo_app/widgets/todo_card.dart';
import 'package:todo_app/widgets/todo_loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    context.read<TodoCubit>().fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('My Todos'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.bars),
          onPressed: () {
            _toggleDrawer();
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.add),
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (_) => AddTodoDialog(onAdd: (todo) {
                context.read<TodoCubit>().addTodo(todo);
              }),
            );
          },
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<TodoCubit, TodoState>(
              buildWhen: (previous, current) {
                return current is LoadTodos;
              },
              builder: (context, state) {
                if (state is FetchingTodos) {
                  return const Center(
                    child: TodoLoader(),
                  );
                }
                final todos = (state as LoadTodos).todos;
                return todos.isEmpty
                    ? const Center(
                        child: Text('No Todo\'s Yet!!'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: TodoCard(
                              todo: todos[index],
                              onDelete: () {
                                context
                                    .read<TodoCubit>()
                                    .deleteTodo(todos[index].id);
                              },
                              onEdit: () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => AddTodoDialog(
                                    initialTodo: todos[index],
                                    onAdd: (updatedTodo) {
                                      context
                                          .read<TodoCubit>()
                                          .updateTodo(updatedTodo);
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
              },
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is DrawerState && state.shouldOpen) {
                  final colors = context.read<ThemeCubit>().colors;
                  return GestureDetector(
                    onTap: _closeDrawer,
                    child: Column(
                      children: [
                        Container(
                          color: colors.backgroundColor,
                          width: 250,
                          child: Column(
                            children: [
                              CupertinoListTile(
                                padding: const EdgeInsets.all(12),
                                title: const Text('Dark Mode'),
                                trailing: CupertinoSwitch(
                                    value: context.watch<ThemeCubit>().state ==
                                        Brightness.dark,
                                    onChanged: (value) {}),
                                onTap: () {
                                  _closeDrawer();
                                  context.read<ThemeCubit>().toggleTheme();
                                },
                              ),
                              const Divider(),
                              CupertinoListTile(
                                padding: const EdgeInsets.all(12),
                                title: const Text('Logout'),
                                onTap: () {
                                  context.read<TodoCubit>().clearTodoOnLogout();
                                  context.read<FirebaseAuthCubit>().logout();
                                  _closeDrawer();
                                  Navigator.pushReplacementNamed(context, '/');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleDrawer() {
    context.read<HomeCubit>().handleDrawer(!_isDrawerOpen);
    _isDrawerOpen = !_isDrawerOpen;
  }

  void _closeDrawer() {
    context.read<HomeCubit>().handleDrawer(false);
  }
}
