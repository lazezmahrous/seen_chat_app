part of 'auth_cubit.dart';

@immutable
sealed class AuthCubitState {}

final class AuthCubitInitial extends AuthCubitState {}

final class AuthLoginLoading extends AuthCubitState {}

final class AuthLoginSuccess extends AuthCubitState {}

final class AuthLoginFaluire extends AuthCubitState {
  final String errMessage;
  AuthLoginFaluire({required this.errMessage});
}

final class AuthSignupLoading extends AuthCubitState {}

final class AuthSignupSuccess extends AuthCubitState {}

final class AuthSignupFaluire extends AuthCubitState {
  final String errMessage;
  AuthSignupFaluire({required this.errMessage});
}

final class PhoneAuthLoading extends AuthCubitState {}
final class PhoneAuthCodeSent extends AuthCubitState {
    final String verificationId;
PhoneAuthCodeSent({required this.verificationId});
}

final class PhoneAuthSuccess extends AuthCubitState {
  final String phoneNumber;
  final String userUid;

  PhoneAuthSuccess({required this.phoneNumber, required this.userUid});
}

final class PhoneAuthFaluire extends AuthCubitState {
  final String errMessage;
  PhoneAuthFaluire({required this.errMessage});
}
