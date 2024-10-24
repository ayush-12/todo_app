import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_states.dart';



class FirebaseAuthCubit extends Cubit<AuthState> {
  FirebaseAuthCubit() : super(AuthInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginWithPhone(String number) async {
    emit(AuthSendingOtpState());

    await _auth.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        emit(AuthSuccessState());
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(AuthFailureState(failureMessage: e.message ?? 'Verification failed.'));
      },
      codeSent: (String verificationId, int? resendToken) {
        
        emit(OtpInputState(verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //TODO: handle this 
      },
    );
  }

  Future<void> verifyOTP({required String verificationId, required String otp}) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      emit(AuthSuccessState());
    } catch (e) {
      print('EXCEPTION $e');
      emit(OtpFailureState(failureMessage: 'Invalid OTP'));
    }
  }

  void logout() async {
    await _auth.signOut();
    emit(AuthInitial()); // Return to phone input state after logout
  }
}
