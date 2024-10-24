import 'package:flutter/cupertino.dart';

class TodoLoader extends StatelessWidget {
  const TodoLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 50,
      width: 50,
      child: CupertinoActivityIndicator(
        radius: 40,
      ),
    );
  }
}
