import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/models/todo/todo_item.dart';

import 'todo_states.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(FetchingTodos()) {
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('todos')
          .get();
      List<Todo> todoList = List.empty(growable: true);
      // Loop through documents and print them
      for (var doc in querySnapshot.docs) {
        Todo fetchedTodo = Todo.fromJson(doc.data() as Map<String, dynamic>);
        todoList.add(fetchedTodo);
      }

      emit(LoadTodos(todos: todoList));
    } catch (e) {
      ///Todo handle error
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('todos')
          .add(todo.toJson());

      fetchTodos(); // Refresh the list after adding a new todo
    } catch (e) {
      ///TODO hadnle error
    }
  }
}
