import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:meta/meta.dart';

import '../../../../services/encrypt_service.dart';
import '../../../../constanc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> loginUser(
      {required String email, required String password}) async {
    try {
      emit(LoginLoading());
      final encryptionHelper = EncryptionHelper();

      try {
        final encryptionHelper = EncryptionHelper();

        // تشفير كلمة المرور المدخلة
        String encryptedPassword = encryptionHelper.encryptText(password);

        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: encryptedPassword,
        );

        final firebaseMessaging = FirebaseMessaging.instance;
        await firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        final fcToken = await firebaseMessaging.getToken();

        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "fcToken": fcToken,
        });
        emit(LoginSuccess());
      } on FirebaseAuthException catch (ex) {
        emit(LoginFailure(errMessage: ex.code));
      }
    } catch (e) {
      print('error is : $e');
      emit(LoginFailure(errMessage: e.toString()));
    }
  }
}
