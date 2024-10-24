import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/todo/todo_cubit.dart';
import 'package:todo_app/cubit/todo/todo_states.dart';
import 'package:todo_app/widgets/add_todo_dialog.dart';
import 'package:todo_app/widgets/todo_card.dart';
import 'package:todo_app/widgets/todo_loader.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('My Todos'),
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
        child: BlocBuilder<TodoCubit, TodoState>(
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
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TodoCard(
                    todo: todos[index],
                    onDelete: () {
                      context.read<TodoCubit>().deleteTodo(todos[index].id);
                    },
                    onEdit: () {},
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
