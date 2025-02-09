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
      todoList.sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0; // Both null
        if (a.dueDate == null) return 1; // a goes after b
        if (b.dueDate == null) return -1; // b goes after a
        return a.dueDate!.compareTo(b.dueDate!);
      });
      emit(LoadTodos(todos: todoList));
    } catch (e) {
      ///Todo handle error
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      final docRef = await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('todos')
          .add(todo.toJson());

      await updateTodoId(docRef.id);

      fetchTodos();
    } catch (e) {
      ///TODO hadnle error
    }
  }

  Future<void> deleteTodo(String todoId) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .delete();

      fetchTodos();
    } catch (e) {
      // TODO: Handle the error (e.g., show an error message)
    }
  }

  Future<void> updateTodo(Todo updatedTodo) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('todos')
          .doc(updatedTodo.id)
          .update(updatedTodo.toJson());

      fetchTodos();
    } catch (e) {
      // TODO: Handle the error (e.g., show an error message)
    }
  }

  Future<void> updateTodoId(String todoId) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .update({
        'id': todoId,
      });
    } catch (e) {
      ///delete todo if id is not updated
      FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .delete();
      // TODO: Handle the error (e.g., show an error message)
    }
  }

  void clearTodoOnLogout() {
    emit(LoadTodos(todos: []));
  }
}
