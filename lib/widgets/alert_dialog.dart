import 'package:flutter/cupertino.dart';

class ToDoAlertDialog extends StatelessWidget {
  const ToDoAlertDialog({
    super.key,
    required this.message,
  });

  final String message;
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: const Text('Alert'),
      message: Text(message),
      actions: [
        CupertinoActionSheetAction(
          child: const Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
