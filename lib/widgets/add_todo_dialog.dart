import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../models/todo/todo_item.dart';
import '../theme/theme.cubit.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({
    Key? key,
    required this.onAdd,
    this.initialTodo,
  }) : super(key: key);

  final Todo? initialTodo; // Optional initial todo for editing
  final Function(Todo) onAdd;

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  Priority _selectedPriority = Priority.low;
  DateTime? _dueDate;

  final _tagController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers and fields with existing todo data if available
    _titleController =
        TextEditingController(text: widget.initialTodo?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialTodo?.description ?? '');
    _selectedPriority = widget.initialTodo?.priority ?? Priority.low;
    _dueDate = widget.initialTodo?.dueDate;
  }

  // Method to pick a due date
  Future<void> _selectDueDate() async {
    final colors = context.read<ThemeCubit>().colors;
    await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: colors.backgroundColor,
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.dateAndTime,
          minimumDate: DateTime.now(),
          onDateTimeChanged: (DateTime value) {
            setState(() {
              _dueDate = value;
            });
          },
        ),
      ),
    );
  }

  void _saveTodo() {
    if (_titleController.text.isEmpty) {
      showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: const Text('Title cannot be empty.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    final newTodo = Todo(
      id: widget.initialTodo?.id ?? '',
      title: _titleController.text,
      description: _descriptionController.text,
      priority: _selectedPriority,
      dueDate: _dueDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onAdd(newTodo);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Add Todo'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CupertinoTextField(
                controller: _titleController,
                placeholder: 'Title',
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: _descriptionController,
                placeholder: 'Description',
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              const Text('Priority'),
              Center(
                child: CupertinoSegmentedControl<Priority>(
                  children: const {
                    Priority.low: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Low'),
                    ),
                    Priority.medium: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Medium'),
                    ),
                    Priority.high: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('High'),
                    ),
                  },
                  groupValue: _selectedPriority,
                  onValueChanged: (Priority value) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Due Date'),
                  CupertinoButton(
                    onPressed: _selectDueDate,
                    child: Text(
                      _dueDate == null
                          ? 'Select Date'
                          : DateFormat.yMd().add_jm().format(_dueDate!),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: CupertinoButton.filled(
                  onPressed: _saveTodo,
                  child: const Text('Save Todo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
