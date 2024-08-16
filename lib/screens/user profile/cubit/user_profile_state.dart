part of 'user_profile_cubit.dart';

@immutable
sealed class UserProfileState {}

final class UserProfileInitial extends UserProfileState {}

final class GetDataLoading extends UserProfileState {}

final class GetDataFailure extends UserProfileState {
  final String errMessage;
  GetDataFailure({required this.errMessage});
}

final class GetDataSuccess extends UserProfileState {
  final model.User user;
  GetDataSuccess({required this.user});
}

final class ChangeUserNameLoading extends UserProfileState {}

final class ChangeUserNameFailure extends UserProfileState {
    final String errMessage;
  ChangeUserNameFailure({required this.errMessage});

}

final class ChangeUserNameSuccess extends UserProfileState {}


final class ChangProfImgLoading extends UserProfileState {}
final class ChangProfImgFailure extends UserProfileState {
      final String errMessage;
  ChangProfImgFailure({required this.errMessage});

}
final class ChangProfImgSuccess extends UserProfileState {}
