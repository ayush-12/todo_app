import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/firebase_auth.cubit.dart';

import '../cubit/auth_states.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController optController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<FirebaseAuthCubit, AuthState>(
            listener: (context, state) {
          if (state is AuthSuccessState) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }, builder: (context, state) {
          if (state is AuthInitial || state is AuthSendingOtpState) {
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     CupertinoTextField(
                      controller: phoneNumberController,
                      placeholder: 'Enter mobile number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      onPressed: () {
                        context
                            .read<FirebaseAuthCubit>()
                            .loginWithPhone('+919876543210');
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
                if (state is AuthSendingOtpState)
                  const Center(child: CupertinoActivityIndicator()),
              ],
            );
          }

          if (state is OtpInputState || state is OtpVerifyingState) {
            return Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///TODO add number text field here with edit option
                     CupertinoTextField(
                      controller: optController ,
                      keyboardType: TextInputType.number,
                      placeholder: 'Enter OTP',
                    ),
                    const SizedBox(height: 16),
                    CupertinoButton(
                      onPressed: () {
                        context
                            .read<FirebaseAuthCubit>()
                            .verifyOTP(verificationId: (state as OtpInputState).verificationId, otp:'123456',);
                      },
                      child: const Text('Verify'),
                    ),
                  ],
                ),
                if (state is OtpVerifyingState)
                  const Center(child: CupertinoActivityIndicator()),
              ],
            );
          }

          if (state is AuthFailureState || state is OtpFailureState) {
            return const Text(
              'Failure message',
            );

            /// TODO: update this later
          }

          ///TODO: update this
          return const SizedBox.shrink();
        }),
      ),
    );
  }
}
