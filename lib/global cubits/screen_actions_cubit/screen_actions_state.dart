part of 'screen_actions_cubit.dart';

@immutable
sealed class ScreenActionsState {}

final class ScreenActionsInitial extends ScreenActionsState {}

final class ScreenActionsHandelScreenShotLoading extends ScreenActionsState {}

final class ScreenActionsUnPreventScreenShot extends ScreenActionsState {}

final class ScreenActionsPreventScreenShot extends ScreenActionsState {}

final class ScreenActionsHandelScreenShotFailure extends ScreenActionsState {}

final class ScreenActionsTakeScreenShot extends ScreenActionsState {}

final class ScreenActionsGoToReplayMessage extends ScreenActionsState {
  final int indexOfmessage;
  ScreenActionsGoToReplayMessage({required this.indexOfmessage});
}
final class ScreenActionsOpenkeyboard extends ScreenActionsState {
}
