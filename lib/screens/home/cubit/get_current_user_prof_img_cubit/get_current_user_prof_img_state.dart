part of 'get_current_user_prof_img_cubit.dart';

@immutable
sealed class GetCurrentUserProfImgState {}

final class GetCurrentUserProfImgInitial extends GetCurrentUserProfImgState {}

final class GetCurrentUserProfImgLoading extends GetCurrentUserProfImgState {}

final class GetCurrentUserProfImgSuccess extends GetCurrentUserProfImgState {
  final String profImgUrl;
  GetCurrentUserProfImgSuccess({required this.profImgUrl});
}

final class GetCurrentUserProfImgFailure extends GetCurrentUserProfImgState {
  final String errMessage;
GetCurrentUserProfImgFailure({required this.errMessage});

}
