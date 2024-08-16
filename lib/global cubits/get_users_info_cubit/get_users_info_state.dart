part of 'get_users_info_cubit.dart';

@immutable
sealed class GetUsersInfoState {}

final class GetUsersInfoInitial extends GetUsersInfoState {}

final class GetUsersInfoLoading extends GetUsersInfoState {}

final class GetUsersInfoSuccess extends GetUsersInfoState {
  final model.User userData;
  GetUsersInfoSuccess({required this.userData});
}

final class GetUsersInfoFailure extends GetUsersInfoState {
  final String errMessage;
  GetUsersInfoFailure({required this.errMessage});
}
