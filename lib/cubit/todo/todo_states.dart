import 'package:todo_app/models/todo/todo_item.dart';

abstract class TodoState {}

class FetchingTodos extends TodoState {}

class SavingTodo extends TodoState {}

class LoadTodos extends TodoState {
  final List<Todo> todos;

  LoadTodos({required this.todos});
}
