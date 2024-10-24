import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser({
    required String name,
    required String email,
  }) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('user').doc(uid).set({
        'name': name,
        'email': email,
      });
      emit(UserCreated());
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
