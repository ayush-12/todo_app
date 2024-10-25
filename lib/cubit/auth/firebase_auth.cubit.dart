import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_states.dart';

class FirebaseAuthCubit extends Cubit<AuthState> {
  FirebaseAuthCubit() : super(AuthInitial());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginWithPhone(String number) async {
    emit(AuthSendingOtpState());
    if (number.isEmpty || number.length < 10) {
      emit(AuthFailureState(failureMessage: 'Enter a valid number'));
      emit(AuthInitial());
    }
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91 $number',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        String uid = FirebaseAuth.instance.currentUser!.uid;
        checkUserExists(uid);
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(AuthFailureState(
            failureMessage: e.message ?? 'Verification failed.'));
      },
      codeSent: (String verificationId, int? resendToken) {
        emit(OtpInputState(verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        //TODO: handle this
      },
    );
  }

  Future<void> verifyOTP(
      {required String verificationId, required String otp}) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      String uid = FirebaseAuth.instance.currentUser!.uid;
      checkUserExists(uid);
    } catch (e) {
      emit(OtpFailureState(failureMessage: 'Invalid OTP'));
    }
  }

  editPhoneNumber() {
    emit(AuthInitial());
  }

  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      //await _auth.signOut();

      emit(AuthInitial()); // Return to phone input state after logout
    } catch (e) {
      ///TODO handle error
    }
  }

  Future<void> checkUserExists(String uid) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final userDoc = await firestore.collection('user').doc(uid).get();
      if (userDoc.exists) {
        emit(AuthSuccessState(doesUserExist: true));
      } else {
        emit(AuthSuccessState(doesUserExist: false));
      }
    } catch (e) {
      /// Handle error
    }
  }
}
