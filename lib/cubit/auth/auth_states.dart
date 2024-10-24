abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSendingOtpState extends AuthState {}

class OtpInputState extends AuthState {
  final String verificationId;
  OtpInputState({required this.verificationId});
}

class OtpVerifyingState extends AuthState {}

class OtpFailureState extends AuthState {
  final String failureMessage;

  OtpFailureState({required this.failureMessage});
}

class AuthSuccessState extends AuthState {
  final bool doesUserExist;

  AuthSuccessState({required this.doesUserExist});
}

class AuthFailureState extends AuthState {
  final String failureMessage;

  AuthFailureState({required this.failureMessage});
}
