import 'package:flutter_bloc/flutter_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {} // Initial state

class OtpVerificationState extends AuthState {} // Otp verification state

class FirebaseAuthCubit extends Cubit<AuthState> {
 FirebaseAuthCubit() : super(AuthInitial());

  Future<void> loginWithPhone(String number) async {
    emit(OtpVerificationState());
  }
}
