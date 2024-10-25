import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth/auth_states.dart';
import '../cubit/auth/firebase_auth.cubit.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/todo_loader.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<FirebaseAuthCubit, AuthState>(
            listener: (context, state) {
          if (state is AuthSuccessState) {
            Navigator.pushReplacementNamed(
              context,
              state.doesUserExist ? '/home' : '/createAccount',
            );
          }
          if (state is OtpFailureState) {
            showCupertinoDialog(
              context: context,
              builder: (context) =>
                  ToDoAlertDialog(message: state.failureMessage),
            );
          }
          if (state is AuthFailureState) {
            showCupertinoDialog(
              context: context,
              builder: (context) =>
                  ToDoAlertDialog(message: state.failureMessage),
            );
          }
        }, buildWhen: (previous, current) {
          return current is AuthInitial ||
              current is OtpInputState ||
              current is AuthSendingOtpState ||
              current is OtpVerifyingState;
        }, builder: (context, state) {
          return Stack(
            children: [
              if (state is AuthInitial)
                Center(
                    child: _LoginWidget(
                        phoneNumberController: phoneNumberController)),
              if (state is OtpInputState)
                Center(
                  child: _OtpInputWidget(
                    phoneNumber: phoneNumberController.text,
                    verificationId: state.verificationId,
                  ),
                ),
              if (state is AuthSendingOtpState || state is OtpVerifyingState)
                const Center(child: TodoLoader())
            ],
          );
        }),
      ),
    );
  }
}

class _OtpInputWidget extends StatefulWidget {
  const _OtpInputWidget({
    required this.phoneNumber,
    required this.verificationId,
  });

  final String phoneNumber;
  final String verificationId;

  @override
  State<_OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<_OtpInputWidget> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Otp has been sent to'),
        Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 50,
                child: Center(
                  child: Text(widget.phoneNumber),
                ),
              ),
            ),
            Positioned(
              right: 80,
              child: SizedBox(
                height: 50,
                child: CupertinoButton(
                  onPressed: () =>
                      context.read<FirebaseAuthCubit>().editPhoneNumber(),
                  child: const Icon(
                    CupertinoIcons.pen,
                    size: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            6,
            (index) {
              return SizedBox(
                width: 40,
                child: CupertinoTextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onChanged: (value) =>
                      _onChanged(value, index), // Handle input change
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: CupertinoButton.filled(
            onPressed: () {
              context.read<FirebaseAuthCubit>().verifyOTP(
                    verificationId: widget.verificationId,
                    otp: _collectOTP(),
                  );
            },
            child: const Text('Verify'),
          ),
        ),
      ],
    );
  }

  String _collectOTP() {
    return _controllers.map((controller) => controller.text).join('');
  }

  void _onChanged(String value, int index) {
    // Move focus to the next text field if the input is not empty
    if (value.length == 1 && index < 5) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      // Move focus to the previous text field if the input is cleared
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  void dispose() {
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class _LoginWidget extends StatelessWidget {
  const _LoginWidget({
    required this.phoneNumberController,
  });

  final TextEditingController phoneNumberController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 60,
          child: Center(
            child: CupertinoTextField(
              controller: phoneNumberController,
              placeholder: 'Enter mobile number',
              keyboardType: TextInputType.phone,
              padding: const EdgeInsets.all(16),
              prefix: const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('+91'),
              ),
              maxLength: 10,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: CupertinoButton.filled(
            onPressed: () {
              context
                  .read<FirebaseAuthCubit>()
                  .loginWithPhone(phoneNumberController.text);
            },
            child: const Text('Login'),
          ),
        ),
      ],
    );
  }
}
