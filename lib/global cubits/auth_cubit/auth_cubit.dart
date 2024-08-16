import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seen/models/user_model.dart' as model;

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  AuthCubit() : super(AuthCubitInitial());

  FirebaseAuth auth = FirebaseAuth.instance;
  late String _verificationId;

  Future<void> loginUser(
      {required String email, required String password}) async {
    try {
      emit(AuthLoginLoading());

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
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
        emit(AuthLoginSuccess());
      } on FirebaseAuthException catch (ex) {
        emit(AuthLoginFaluire(errMessage: ex.code));
      }
    } catch (e) {
      print('error is : $e');
    }
  }

  Future<void> signUpUser({
    String? userUid,
    required String email,
    required String phoneNumber,
    required String password,
    required String userName,
    required String profImg,
  }) async {
    emit(AuthSignupLoading());

    try {
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
      print(fcToken);

      if (email.isNotEmpty) {
        UserCredential user0 = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        model.User user = model.User(
          username: userName,
          phoneNumber: phoneNumber,
          password: password,
          profImg: profImg,
          lastSeen: DateTime.now().toString(),
          newSeen: DateTime.now().toString(),
          followers: [],
          uid: user0.user!.uid,
          fcToken: fcToken!,
          onLine: true,
        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(user.toJson());
      } else {
        model.User user = model.User(
          username: userName,
          phoneNumber: phoneNumber,
          password: password,
          profImg: profImg,
          lastSeen: DateTime.now().toString(),
          newSeen: DateTime.now().toString(),
          followers: [],
          uid: userUid!,
          fcToken: fcToken!,
          onLine: true,
        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userUid)
            .set(user.toJson());
      }

      emit(AuthSignupSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthSignupFaluire(errMessage: e.code));
    }
  }

  void verifyCode(
      {required String phoneNumber,
      required String smsCode,
      required BuildContext context}) async {
    try {
      if (_verificationId.isEmpty) {
        throw Exception("Verification ID is not set.");
      }
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      emit(
        PhoneAuthSuccess(
            phoneNumber: phoneNumber, userUid: userCredential.user!.uid),
      );
    } catch (e) {
      emit(
        PhoneAuthFaluire(errMessage: e.toString()),
      );
    }
  }

  void signUpWithOtp({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    emit(PhoneAuthLoading());
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        final User? user = auth.currentUser;
        if (user != null) {
          emit(PhoneAuthSuccess(phoneNumber: phoneNumber, userUid: user.uid));
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        emit(PhoneAuthFaluire(errMessage: e.message ?? 'Verification failed.'));
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        emit(PhoneAuthCodeSent(verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }
}
