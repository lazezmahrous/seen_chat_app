part of 'prevent_screen_shot_cubit.dart';

@immutable
sealed class PreventScreenShotState {}

final class PreventScreenShotInitial extends PreventScreenShotState {}

final class PreventScreenShot extends PreventScreenShotState {}

final class PreventScreenShotSuccess extends PreventScreenShotState {}

final class PreventScreenShotFailure extends PreventScreenShotState {}

final class UnPreventScreenShot extends PreventScreenShotState {}
final class AnotherUserUnPreventScreenShot extends PreventScreenShotState {}
