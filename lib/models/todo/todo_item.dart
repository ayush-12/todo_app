import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'reminder.dart';
import '../timestamp_converter.dart';

part 'todo_item.freezed.dart';
part 'todo_item.g.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    String? description,
    @Default(false) bool isCompleted,
    @PriorityConverter() @Default(Priority.low) Priority priority,
    @TimestampConverter() DateTime? dueDate,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    Reminder? reminder,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  factory Todo.fromFirestore(DocumentSnapshot doc) =>
      Todo.fromJson(doc.data() as Map<String, dynamic>).copyWith(id: doc.id);
}

enum Priority { low, medium, high }

class PriorityConverter implements JsonConverter<Priority, String> {
  const PriorityConverter();

  @override
  Priority fromJson(String json) =>
      Priority.values.firstWhere((e) => e.name == json);

  @override
  String toJson(Priority priority) => priority.name;
}
