import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo/todo_item.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TodoCard({
    Key? key,
    required this.todo,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGroupedBackground,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CupertinoListTile(
        padding: EdgeInsets.symmetric(vertical: 12),
        leading: _buildPriorityIcon(todo.priority),
        leadingSize: 60,
        title: Text(
          todo.title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              todo.description ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: CupertinoColors.systemGrey, fontSize: 16),
            ),
            Text(
              todo.dueDate != null
                  ? DateFormat.yMd().add_jm().format(todo.dueDate!)
                  : 'No Due Date',
              style: const TextStyle(
                fontSize: 16,
                color: CupertinoColors.systemGrey,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onDelete,
              child: const Icon(
                CupertinoIcons.delete,
                color: CupertinoColors.systemRed,
                size: 24,
              ),
            ),
          ],
        ),
        onTap: onEdit,
      ),
    );
  }

  Widget _buildPriorityIcon(Priority priority) {
    List<Color> colors = [
      CupertinoColors.systemGreen, // Low
      CupertinoColors.systemOrange, // Medium
      CupertinoColors.systemRed, // High
    ];

    int selectedIndex;
    switch (priority) {
      case Priority.high:
        selectedIndex = 2;
        break;
      case Priority.medium:
        selectedIndex = 1;
        break;
      case Priority.low:
      default:
        selectedIndex = 0;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: index == selectedIndex ? 12.0 : 8.0,
                height: index == selectedIndex ? 12.0 : 8.0,
                decoration: BoxDecoration(
                  color: colors[index],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _getPriorityLabel(priority),
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

// Helper method to get the priority label as a string.
  String _getPriorityLabel(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Medium';
      case Priority.low:
      default:
        return 'Low';
    }
  }
}
