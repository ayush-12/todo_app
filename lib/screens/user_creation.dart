import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/user/user_cubit.dart';
import '../cubit/user/user_state.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserScreen> {
  String _name = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserCreated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is UserError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Create Account'),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CupertinoTextField(
                placeholder: 'Name',
                onChanged: (value) => _name = value,
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                placeholder: 'Email',
                onChanged: (value) => _email = value,
              ),
              const SizedBox(height: 12),
              CupertinoButton.filled(
                child: const Text('Create Account'),
                onPressed: () {
                  /// TODO: add validation explicitly as
                  /// CupertinoTextField does not support validators
                  context.read<UserCubit>().createUser(
                        name: _name,
                        email: _email,
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
