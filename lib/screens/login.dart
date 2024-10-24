import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/firebase_auth.cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<FirebaseAuthCubit, AuthState>(
            builder: (context, state) {
          if (state is AuthInitial) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CupertinoTextField(
                  placeholder: 'Enter mobile number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  onPressed: () {
                    context.read<FirebaseAuthCubit>().loginWithPhone('s');
                  },
                  child: const Text('Login'),
                ),
              ],
            );
          }

          if (state is OtpVerificationState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CupertinoTextField(
                  placeholder: 'Enter OTP',
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  onPressed: () {},
                  child: const Text('Verify'),
                ),
              ],
            );
          }

          ///TODO: update this
          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
